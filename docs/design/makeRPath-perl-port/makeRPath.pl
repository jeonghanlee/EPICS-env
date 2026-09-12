#!/usr/bin/env perl
#*************************************************************************
# SPDX-License-Identifier: EPICS
# EPICS BASE is distributed subject to a Software License Agreement found
# in file LICENSE that is included with this distribution.
#*************************************************************************

use strict;
use warnings;
use 5.10.1;   # for the defined-or operator //

use Getopt::Long;
use File::Spec;
use Pod::Usage;

# Example:
#   target to be installed as: /build/bin/blah
#   post-install will copy as: /install/bin/blah
#
# Need to link against:
#   /install/lib/libA.so
#   /build/lib/libB.so
#   /other/lib/libC.so
#
# Want final result to be:
#   -rpath $ORIGIN/../lib -rpath /other/lib \
#   -rpath-link /build/lib -rpath-link /install/lib

warn "[" . join(' ', $0, @ARGV) . "]\n"
    if ($ENV{EPICS_DEBUG_RPATH} // '') eq 'YES';

# Defaults for command-line arguments
my $final  = File::Spec->curdir();
my $root   = '';
my $origin = '$ORIGIN';
my $help   = 0;

GetOptions(
    'final|F=s'  => \$final,
    'root|R=s'   => \$root,
    'origin|O=s' => \$origin,
    'help|h'     => \$help,
) or pod2usage(
    -exitval   => 2,
    -verbose   => 1,
    -noperldoc => 1,
);

pod2usage(
    -exitval   => 0,
    -verbose   => 2,
    -noperldoc => 1,
) if $help;

# Lexically normalize an absolute path the way Python's os.path.normpath()
# does: collapse '.', resolve '..' against the preceding component, and drop
# '..' that would climb above the root. Purely textual, no filesystem access.
sub normpath {
    my ($p) = @_;
    return '.' if $p eq '';
    my $abs = ($p =~ m{^/});
    my @out;
    foreach my $c (split m{/+}, $p) {
        next if $c eq '' || $c eq '.';
        if ($c eq '..') {
            if (@out && $out[-1] ne '..') {
                pop @out;
            } elsif (!$abs) {
                push @out, $c;
            }
        } else {
            push @out, $c;
        }
    }
    my $r = join('/', @out);
    $r = '/' . $r if $abs;
    return $r eq '' ? '.' : $r;
}

# Normalize to absolute form lexically (rel2abs, not Cwd::abs_path) so that
# a --final install location which does not exist yet is still accepted.
my $fdir  = normpath(File::Spec->rel2abs($final));
my @roots = map { normpath(File::Spec->rel2abs($_)) }
            grep { length } split(/:/, $root);

# Find the root which contains the final location, and remember the final
# location relative to that enclosing root ($frel).
my $froot;
my $frel;
foreach my $r (@roots) {
    my $rel = File::Spec->abs2rel($fdir, $r);
    if ($rel !~ m{^\.\.}) {
        # final dir is under this root
        $froot = $r;
        $frel  = $rel;
        last;
    }
}

if (!defined $froot) {
    warn "makeRPath: Final location $fdir\n" .
         "Not under any of: @roots\n";
    @roots = ();   # Skip $ORIGIN handling below
}

# Join $origin with a relative path the way os.path.join() does:
#   - an absolute second argument replaces the origin entirely
#     (used for paths outside any root);
#   - an empty base returns the path unchanged (no spurious leading slash);
#   - a base already ending in '/' is not given a second separator.
sub join_origin {
    my ($base, $path) = @_;
    return $path if File::Spec->file_name_is_absolute($path);
    return $path if $base eq '';
    return $base =~ m{/$} ? "$base$path" : "$base/$path";
}

my (@output, %seen);
sub emit {
    my ($opt) = @_;
    push @output, $opt unless $seen{$opt}++;
}

foreach my $path (@ARGV) {
    $path = normpath(File::Spec->rel2abs($path));
    my $rel = $path;   # default: outside every root, keep the absolute path

    foreach my $r (@roots) {
        my $rrel = File::Spec->abs2rel($path, $r);
        next if $rrel =~ m{^\.\.};   # path not under this root

        # Some older binutils don't handle $ORIGIN correctly when locating
        # dependencies of libraries, so also provide the absolute path for
        # internal use by 'ld' only.
        emit("-Wl,-rpath-link,$path");

        # frel is the final location relative to the enclosing root,
        # rrel is the target location relative to the same root, so the
        # target relative to the final location is abs2rel($rrel, $frel).
        $rel = File::Spec->abs2rel($rrel, $frel);
        last;
    }

    emit("-Wl,-rpath," . join_origin($origin, $rel));
}

print join(' ', @output), "\n";

__END__

=head1 NAME

makeRPath.pl - Compute and output -rpath entries for given paths

=head1 SYNOPSIS

makeRPath.pl [options] [path ...]

=head1 OPTIONS

    -h, --help      Display detailed help and exit
    -F, --final     Final install location for ELF file
    -R, --root      Root(s) of relocatable tree, separated by ':'
    -O, --origin    Origin path (default: '$ORIGIN')

=head1 DESCRIPTION

Computes and outputs -rpath entries for each of the given paths.
Paths under C<--root> will be computed as relative to C<--final>.

=head1 EXAMPLE

A library to be placed in C</build/lib> and linked against libraries in
C</build/lib>, C</build/module/lib>, and C</other/lib> would pass

  makeRPath.pl -F /build/lib -R /build /build/lib /build/module/lib /other/lib

which generates

  -Wl,-rpath,$ORIGIN/. -Wl,-rpath,$ORIGIN/../module/lib -Wl,-rpath,/other/lib

=cut
