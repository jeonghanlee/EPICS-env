#!/usr/bin/env perl
#
#  Copyright (c) 2026 -         Jeong Han Lee
#
#  The program is free software: you can redistribute
#  it and/or modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation, either version 2 of the
#  License, or any newer version.
#
#  This program is distributed in the hope that it will be useful, but WITHOUT
#  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
#  more details.
#
#  You should have received a copy of the GNU General Public License along with
#  this program. If not, see https://www.gnu.org/licenses/gpl-2.0.txt
#
# Writes a deterministic JSON manifest of a directory tree to stdout: one
# record per descendant, sorted by relative path, in the established byte
# format (two-space indentation, ASCII-only string escapes, octal modes
# written as 0o<digits>).

use strict;
use warnings;

use Cwd ();
use Digest::SHA ();
use Encode ();
use Fcntl qw(:mode);
use Getopt::Long qw(GetOptions);
use Pod::Usage qw(pod2usage);

use constant EXIT_OK    => 0;
use constant EXIT_ERROR => 1;
use constant EXIT_USAGE => 2;

my %SHORT_ESCAPE = (
    "\n" => '\\n', "\r" => '\\r', "\t" => '\\t', "\b" => '\\b', "\f" => '\\f',
    '"'  => '\\"', '\\' => '\\\\',
);

# Decodes a file name as UTF-8 and maps every byte that is not part of a valid
# sequence to the lone surrogate U+DC00 + byte, so a name that is not valid
# UTF-8 keeps one distinct code point per bad byte and sorts by code point.
sub fsdecode {
    my ($bytes) = @_;
    my $chars = '';
    my $rest  = $bytes;
    while (length $rest) {
        $chars .= Encode::decode('UTF-8', $rest, Encode::FB_QUIET);
        last unless length $rest;
        $chars .= chr(0xDC00 + ord(substr($rest, 0, 1, '')));
    }
    return $chars;
}

# Writes a character string as a JSON string with every character outside
# space..tilde escaped, using a surrogate pair above U+FFFF.
sub json_string {
    my ($chars) = @_;
    no warnings 'surrogate';
    my $out = '"';
    for my $char (split //, $chars) {
        my $code = ord $char;
        if (exists $SHORT_ESCAPE{$char}) {
            $out .= $SHORT_ESCAPE{$char};
        }
        elsif ($code >= 0x20 && $code <= 0x7e) {
            $out .= $char;
        }
        elsif ($code > 0xFFFF) {
            my $offset = $code - 0x10000;
            $out .= sprintf('\\u%04x\\u%04x', 0xD800 + ($offset >> 10), 0xDC00 + ($offset & 0x3FF));
        }
        else {
            $out .= sprintf('\\u%04x', $code);
        }
    }
    return $out . '"';
}

# Appends the record of every descendant of one directory and recurses into
# real directories only; a symlink is recorded and never followed.
sub scan_directory {
    my ($root, $relative, $entries) = @_;
    my $directory = length $relative ? "$root/$relative" : $root;
    opendir(my $handle, $directory) or die "$directory: $!\n";
    my @names = grep { $_ ne '.' && $_ ne '..' } readdir($handle);
    closedir($handle) or die "$directory: $!\n";
    for my $name (@names) {
        my $child_relative = length $relative ? "$relative/$name" : $name;
        my $path           = "$root/$child_relative";
        my @stat           = lstat($path) or die "$path: $!\n";
        my $mode           = $stat[2];
        my %entry          = (
            path => fsdecode($child_relative),
            mode => sprintf('0o%o', S_IMODE($mode)),
        );
        if (S_ISLNK($mode)) {
            my $target = readlink($path);
            defined $target or die "$path: $!\n";
            @entry{qw(type target)} = ('symlink', fsdecode($target));
        }
        elsif (S_ISDIR($mode)) {
            $entry{type} = 'directory';
        }
        elsif (S_ISREG($mode)) {
            open(my $stream, '<:raw', $path) or die "$path: $!\n";
            my $digest = Digest::SHA->new(256);
            $digest->addfile($stream);
            close($stream) or die "$path: $!\n";
            @entry{qw(type size sha256)} = ('file', $stat[7], $digest->hexdigest);
        }
        else {
            die "Unsupported file type: $path\n";
        }
        push @{$entries}, \%entry;
        scan_directory($root, $child_relative, $entries) if S_ISDIR($mode);
    }
    return;
}

# Returns the JSON text of the manifest of one existing directory.
sub manifest {
    my ($tree) = @_;
    -e $tree or die "$tree: $!\n";
    my $root = Cwd::abs_path($tree);
    defined $root or die "$tree: $!\n";
    -d $root or die "Expected an existing tree directory\n";
    my @entries;
    scan_directory($root, '', \@entries);
    @entries = sort { $a->{path} cmp $b->{path} } @entries;
    return "[]\n" unless @entries;
    my @records;
    for my $entry (@entries) {
        my @fields = (
            '"path": ' . json_string($entry->{path}),
            '"mode": ' . json_string($entry->{mode}),
            '"type": ' . json_string($entry->{type}),
        );
        push @fields, '"target": ' . json_string($entry->{target}) if exists $entry->{target};
        push @fields, '"size": ' . $entry->{size}                  if exists $entry->{size};
        push @fields, '"sha256": ' . json_string($entry->{sha256}) if exists $entry->{sha256};
        push @records, "  {\n    " . join(",\n    ", @fields) . "\n  }";
    }
    return "[\n" . join(",\n", @records) . "\n]\n";
}

sub main {
    my (@argv) = @_;
    my $help = 0;
    local $SIG{__WARN__} = sub { print STDERR "tree-manifest.pl: $_[0]" };
    GetOptions('help|h' => \$help) or pod2usage(-exitval => EXIT_USAGE, -verbose => 0, -output => \*STDERR);
    pod2usage(-exitval => EXIT_OK, -verbose => 1, -output => \*STDOUT) if $help;
    @argv == 1 or pod2usage(-exitval => EXIT_USAGE, -verbose => 0, -output => \*STDERR);
    my $text = eval { manifest($argv[0]) };
    if (!defined $text) {
        my $error = $@;
        $error =~ s/\n\z//;
        print STDERR "tree-manifest.pl: $error\n";
        return EXIT_ERROR;
    }
    print STDOUT $text or do { print STDERR "tree-manifest.pl: stdout: $!\n"; return EXIT_ERROR };
    close(STDOUT) or do { print STDERR "tree-manifest.pl: stdout: $!\n"; return EXIT_ERROR };
    return EXIT_OK;
}

my $status;
eval {
    $status = main(@ARGV);
    defined $status or die "internal error: main returned no exit status\n";
    1;
} or do {
    my $error = $@;
    print STDERR "tree-manifest.pl: $error";
    $status = EXIT_ERROR;
};
exit $status;

__END__

=head1 NAME

tree-manifest.pl - write a deterministic JSON manifest of a directory tree

=head1 SYNOPSIS

tree-manifest.pl <tree>

tree-manifest.pl --help

=head1 DESCRIPTION

Writes a JSON array to stdout with one record per descendant of the existing
directory B<tree>, sorted by relative path. A record holds the relative path,
the permission bits written as C<0o<octal>>, the type (C<file>, C<directory>
or C<symlink>), the symlink target or the size and SHA-256 of a regular file.
Symlinks are recorded and never followed, a read error ends the run without a
manifest, and a file that is neither regular, directory nor symlink is refused.

Keep the tree unchanged during scanning and redirect stdout outside the tree.
The manifest does not record the root directory itself, ownership or timestamps.

=head1 OPTIONS

=over 4

=item B<--help>, B<-h>

Print this help and exit with status 0.

=back

=head1 EXIT STATUS

0 on success, 1 when the tree cannot be scanned completely, 2 on a usage error.

=cut
