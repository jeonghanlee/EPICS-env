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
# Exercises the prerequisite check of tools/linstat-carry/verify.pl as a
# subprocess. A compiler that cannot link with the undefined-behavior sanitizer,
# as on a machine without its runtime package, must stop the run with a diagnostic
# that names the package; a working compiler must pass the check.
# LINSTAT_VERIFY_TOOL names another copy of the verifier to test.

use strict;
use warnings;

use Cwd ();
use File::Basename ();
use File::Temp ();
use POSIX ();
use Test::More;

use File::Path ();

# Temporary files are created below work/scratch of the repository (EPICS_ENV_SCRATCH names another
# directory), and each run removes them when it ends. Child commands inherit TMPDIR.
my $SCRATCH_BASE = $ENV{EPICS_ENV_SCRATCH} // File::Basename::dirname(File::Basename::dirname(File::Basename::dirname(Cwd::abs_path($0)))) . '/work/scratch';
File::Path::make_path($SCRATCH_BASE);
-d $SCRATCH_BASE && -w _ or die "$SCRATCH_BASE: not a writable directory\n";
$ENV{TMPDIR} = $SCRATCH_BASE;

my $TOOL = $ENV{LINSTAT_VERIFY_TOOL} // File::Basename::dirname(Cwd::abs_path($0)) . '/verify.pl';
my $work = File::Temp->newdir('linstat-prerequisites-XXXXXX', TMPDIR => 1, CLEANUP => 1);

# Runs the verifier and returns its exit status, stdout and stderr.
sub run_tool {
    my (@args) = @_;
    my $err = File::Temp->new;
    my $pid = open(my $out, '-|');
    defined $pid or die "fork: $!\n";
    if (!$pid) {
        open(STDERR, '>&', $err) or POSIX::_exit(126);
        exec { $^X } $^X, $TOOL, @args or POSIX::_exit(127);
    }
    my $stdout = do { local $/; <$out> };
    close($out);
    my $status = ($? & 127) ? 'signal ' . ($? & 127) : $? >> 8;
    seek($err, 0, 0);
    my $stderr = do { local $/; <$err> };
    return ($status, defined $stdout ? $stdout : '', defined $stderr ? $stderr : '');
}

# A compiler stand-in that fails the way the linker does without the sanitizer
# runtime and otherwise runs the real compiler.
my $fake = "$work/fake-cxx";
open(my $fh, '>', $fake) or die "$fake: $!\n";
print {$fh} <<'SH';
#!/bin/sh
for arg in "$@"; do
    if [ "$arg" = "-fsanitize=undefined" ]; then
        echo "/usr/bin/ld: cannot find /usr/lib64/libubsan.so.1.0.0" >&2
        exit 1
    fi
done
exec g++ "$@"
SH
close($fh) or die "$fake: $!\n";
chmod(0755, $fake) or die "chmod: $!\n";

# Without the sanitizer runtime the run stops with a diagnostic that names the package.
{
    my $dir = "$work/stopped";
    my ($status, undef, $stderr) = run_tool('--source', "$work/no-source", '--base', "$work/no-base", '--work-dir', $dir, '--cxx', $fake);
    is($status, 1, 'missing sanitizer runtime: exit status 1');
    like($stderr, qr/Prerequisite missing/, 'missing sanitizer runtime: the diagnostic names the prerequisite');
    like($stderr, qr/libubsan on Rocky Linux and Red Hat, libubsan1 on Debian and Ubuntu/, 'missing sanitizer runtime: the diagnostic names the packages');
    ok(-s "$dir/report.json", 'missing sanitizer runtime: the report is still written');
}

# With a compiler that links, the prerequisite passes and the run goes on to the next
# check, which fails here because no source checkout exists.
SKIP: {
    skip 'g++ is not available', 2 unless grep { -x "$_/g++" } split /:/, $ENV{PATH} // '';
    my $dir = "$work/continued";
    my ($status, undef, $stderr) = run_tool('--source', "$work/no-source", '--base', "$work/no-base", '--work-dir', $dir, '--cxx', 'g++');
    is($status, 1, 'working compiler: the run goes on and fails at the missing source');
    unlike($stderr, qr/Prerequisite missing/, 'working compiler: the prerequisite passes');
}

done_testing();
