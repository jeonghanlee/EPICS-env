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
# Decides whether a failed site dependency audit may be accepted. The strict
# JSON report of `make check.module-deps FORMAT=json` is read from stdin. A
# failed audit is accepted only when every finding that is not
# declared-unobserved is an unknown token found by a listed source scan in an
# existing file below a module source directory outside configure.

use strict;
use warnings;

use File::Spec ();
use JSON::PP ();
use Pod::Usage qw(pod2usage);

use constant EXIT_OK   => 0;
use constant EXIT_STOP => 2;

my %ACCEPTED_SOURCES = map { $_ => 1 } qw(
    make-libs make-dbd dbd-include db-file db-record db-proto startup-db startup-dbd source-include
);

sub stop {
    my ($message) = @_;
    die "$message\n";
}

sub is_string { my ($v) = @_; return defined $v && !ref $v && !JSON::PP::is_bool($v) }

# The components of a path as Python's PurePath.parts gives them for a
# relative path: empty and "." components are dropped.
sub path_parts {
    my ($path) = @_;
    return grep { length $_ && $_ ne '.' } split m{/}, $path, -1;
}

sub check_report {
    my ($report, $checkout) = @_;
    ref $report eq 'HASH' or stop('report is not an object');
    exists $report->{strict} or stop('missing strict');
    exists $report->{modules} or stop('missing modules');
    (is_string($report->{strict}) && $report->{strict} eq 'YES' && ref $report->{modules} eq 'ARRAY' && @{ $report->{modules} })
        or stop('incomplete strict report');
    my $count = 0;
    for my $module (@{ $report->{modules} }) {
        ref $module eq 'HASH' or stop('module is not an object');
        exists $module->{findings} && ref $module->{findings} eq 'ARRAY' or stop('module without findings');
        for my $finding (@{ $module->{findings} }) {
            ref $finding eq 'HASH' or stop('finding is not an object');
            exists $finding->{type} or stop('finding without type');
            next if is_string($finding->{type}) && $finding->{type} eq 'declared-unobserved';
            my $path   = exists $finding->{path} ? $finding->{path} : '';
            my $source = exists $finding->{source} ? $finding->{source} : '';
            (is_string($path) && !ref $source) or stop('finding with an invalid path or source');
            my @parts = path_parts($path);
            my $unacceptable =
                !is_string($finding->{type}) || $finding->{type} ne 'unknown'
                || !is_string($source) || !$ACCEPTED_SOURCES{$source}
                || $path =~ m{\A/} || @parts < 2
                || $parts[0] !~ /-src\z/
                || grep({ $_ eq '..' || $_ eq 'configure' } @parts)
                || !-f File::Spec->catfile($checkout, @parts);
            $unacceptable and stop('configuration or unclassified finding');
            $count++;
        }
    }
    $count or stop('failed audit without source findings');
    return;
}

sub main {
    my (@argv) = @_;
    if (@argv == 1 && ($argv[0] eq '-h' || $argv[0] eq '--help')) {
        pod2usage(-exitval => EXIT_OK, -verbose => 1, -output => \*STDOUT);
    }
    @argv == 1 or pod2usage(-exitval => EXIT_STOP, -verbose => 0, -output => \*STDERR);
    my $checkout = $argv[0];
    my $text = do { local $/; <STDIN> };
    $text = '' unless defined $text;
    my $ok = eval {
        my $report = JSON::PP->new->allow_nonref->decode($text);
        check_report($report, $checkout);
        1;
    };
    if (!$ok) {
        my $error = $@;
        $error =~ s/\n\z//;
        $error =~ s/ at \S+ line \d+\.?\z//;
        print STDERR "SITE-DEPENDENCY-STOP: $error\n";
        return EXIT_STOP;
    }
    print "SITE-DEPENDENCY-FINDINGS: retain the audit output for review.\n";
    return EXIT_OK;
}

my $status;
eval {
    $status = main(@ARGV);
    defined $status or die "internal error: main returned no exit status\n";
    1;
} or do {
    my $error = $@;
    print STDERR "site-dependency-audit.pl: $error";
    $status = EXIT_STOP;
};
exit $status;

__END__

=head1 NAME

site-dependency-audit.pl - accept only source-level findings of a failed site dependency audit

=head1 SYNOPSIS

site-dependency-audit.pl <site-checkout> < report.json

=head1 DESCRIPTION

Reads the strict JSON report of C<make check.module-deps FORMAT=json> from
stdin. It exits with status 0 and prints C<SITE-DEPENDENCY-FINDINGS> when every
finding that is not C<declared-unobserved> is an C<unknown> token reported by
one of the source scans (C<make-libs>, C<make-dbd>, C<dbd-include>,
C<db-file>, C<db-record>, C<db-proto>, C<startup-db>, C<startup-dbd>,
C<source-include>) in an existing file below a C<*-src> directory of
B<site-checkout>, outside C<configure>, and at least one such finding exists.
Otherwise it prints C<SITE-DEPENDENCY-STOP> with the reason to stderr and exits
with status 2.

=head1 OPTIONS

=over 4

=item B<--help>, B<-h>

Print this help and exit with status 0.

=back

=head1 EXIT STATUS

0 when the findings are accepted, 2 when the report is rejected or the usage is wrong.

=cut
