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
# Exercises the restart of the IOC by verify_caputlog.pl with real EPICS processes.
# Another process holds the Channel Access port of the first start on both TCP and UDP,
# as a process that takes the port between its choice and its use does; the IOC then
# reports that it cannot start. The verifier must keep the log of that start, start
# the IOC again on a new port, and pass the case.
# The shell verifier verify_caputlog.sh restarts the same way when CAPUTLOG_CA_PORT names the
# held port. CAPUTLOG_VERIFY_TOOL and CAPUTLOG_VERIFY_SHELL name other copies of the two to test.
#
# Usage: verify_caputlog_retry.pl <installed_base>

use strict;
use warnings;

use Cwd ();
use File::Basename ();
use File::Temp ();
use IO::Socket::INET ();
use POSIX ();
use Test::More;

@ARGV == 1 or do { print STDERR "Usage: verify_caputlog_retry.pl <installed_base>\n"; exit 2 };
my $base = Cwd::abs_path($ARGV[0]) // die "$ARGV[0]: $!\n";
my $TOOL = $ENV{CAPUTLOG_VERIFY_TOOL} // File::Basename::dirname(Cwd::abs_path($0)) . '/verify_caputlog.pl';
my $SHELL = $ENV{CAPUTLOG_VERIFY_SHELL} // File::Basename::dirname(Cwd::abs_path($0)) . '/tests/verify_caputlog.sh';
my $work = File::Temp->newdir('caputlog-retry-XXXXXX', TMPDIR => 1, CLEANUP => 1);

sub slurp {
    my ($path) = @_;
    open(my $fh, '<:raw', $path) or return '';
    my $content = do { local $/; <$fh> };
    close($fh);
    return defined $content ? $content : '';
}

# Holds one port on both TCP and UDP of the loopback address until the objects go away.
sub hold_port {
    # A free TCP port number can be in use as a UDP port of another process, so try again
    # with another number until both protocols are held.
    for my $try (1 .. 20) {
        my $tcp = IO::Socket::INET->new(LocalAddr => '127.0.0.1', LocalPort => 0, Proto => 'tcp', Listen => 5) or die "tcp: $!\n";
        my $port = $tcp->sockport;
        my $udp = IO::Socket::INET->new(LocalAddr => '127.0.0.1', LocalPort => $port, Proto => 'udp');
        return ($port, $tcp, $udp) if $udp;
    }
    die "no port number is free on both TCP and UDP\n";
}

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

my ($port, @holders) = hold_port();
my $evidence = "$work/evidence";
my ($status, $stdout, $stderr) = run_tool('--base', $base, '--output', $evidence, '--case', 'disabled', '--ca-port', $port, '--timeout', '10');
is($status, 0, 'the case passes after a restart') or diag("$stdout$stderr");
like($stdout, qr/\[ PASS \] disabled:/, 'the verdict line reports the pass');
my $first = slurp("$evidence/disabled/ioc.log.attempt1");
like($first, qr/CAS: No TCP server started/, 'the log of the failed first start is kept and names the cause');
unlike($first, qr/iocRun: All initialization complete/, 'the first start did not complete');
like(slurp("$evidence/disabled/ioc.log"), qr/iocRun: All initialization complete/, 'the second start completed');
my ($recorded) = slurp("$evidence/disabled/inputs.json") =~ /"ca_port": "(\d+)"/;
ok(defined $recorded && $recorded != $port, 'the inputs record the port of the successful start, not the held port');

# The shell verifier: the same held port, the workspace kept so that its logs can be read.
{
    my ($shell_port, @shell_holders) = hold_port();
    my $tmp = "$work/shell-tmp";
    mkdir($tmp) or die "$tmp: $!\n";
    my $err = File::Temp->new;
    my $pid = open(my $out, '-|');
    defined $pid or die "fork: $!\n";
    if (!$pid) {
        open(STDERR, '>&', $err) or POSIX::_exit(126);
        $ENV{DIST_TOP} = File::Basename::dirname($base);
        $ENV{TC32SIM} = '/nonexistent';
        $ENV{CAPUTLOG_CA_PORT} = $shell_port;
        $ENV{KEEP_WORKSPACE} = '1';
        $ENV{TMPDIR} = $tmp;
        $ENV{COMMONIOCSH_TEST_TRASH} = "$work/shell-trash";
        exec { 'bash' } 'bash', $SHELL or POSIX::_exit(127);
    }
    my $text = do { local $/; <$out> };
    close($out);
    my $status = $? >> 8;
    $text = '' unless defined $text;
    is($status, 0, 'the shell verifier passes after a restart') or diag($text);
    like($text, qr/PASS=3 FAIL=0/, 'the shell verifier reports three passed checks');
    my @logs = glob("$tmp/*/ioc.log.attempt1");
    is(scalar(@logs), 1, 'the shell verifier keeps the log of the failed first start');
    like(@logs ? slurp($logs[0]) : '', qr/CAS: No TCP server started/, 'the kept log names the cause');
}

# Neither verifier leaves an IOC of its own behind in ioc-runner: no configuration file and no unit.
{
    my @confs = glob("$ENV{HOME}/.config/procServ.d/caputlog-*.conf");
    is(scalar(@confs), 0, 'no caputlog IOC configuration is left in ioc-runner') or diag("@confs");
    my $units = qx{systemctl --user list-units --all --no-legend 'epics-\@caputlog-*' 2>&1};
    is($units, '', 'no caputlog IOC unit is left in the user systemd session') or diag($units);
}

done_testing();
