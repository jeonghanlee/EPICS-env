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
# Verifies the shipped caPutLog fragment with real EPICS processes: for each of
# six cases an iocLogServer, an IOC started by the installed iocsh.bash loader
# (no example IOC is built) and caput clients run in isolation
# and the messages received by the log server are checked. The result of every
# case is written to summary.json, in the established byte layout
# (two-space indentation, ASCII-only escapes), and printed as one verdict line.

use strict;
use warnings;

use Cwd ();
use Digest::SHA ();
use Encode ();
use File::Basename ();
use File::Path ();
use File::Spec ();
use File::Temp ();
use Getopt::Long qw(GetOptions);
use IO::Handle ();
use IO::Socket::INET ();
use Pod::Usage qw(pod2usage);
use POSIX ();
use Socket ();
use Time::HiRes ();

use constant EXIT_OK    => 0;
use constant EXIT_ERROR => 1;
use constant EXIT_USAGE => 2;

use constant DEFAULT_LOG_PORT => 7004;
use constant DEFAULT_TIMEOUT  => 30.0;
use constant QUIET_WINDOW     => 12.0;
use constant POLL_INTERVAL    => 0.1;

my %SHORT_ESCAPE = ("\n" => '\\n', "\r" => '\\r', "\t" => '\\t', "\b" => '\\b', "\f" => '\\f', '"' => '\\"', '\\' => '\\\\');

# Ordered JSON values with two-space indentation and ASCII-only string escapes.
sub dict { return bless [@_], 'Dict' }
sub int_value { my ($n) = @_; return bless \(my $copy = $n + 0), 'Int' }

sub json_string {
    my ($chars) = @_;
    my $out = '"';
    for my $char (split //, $chars) {
        my $code = ord $char;
        if (exists $SHORT_ESCAPE{$char}) { $out .= $SHORT_ESCAPE{$char} }
        elsif ($code >= 0x20 && $code <= 0x7e) { $out .= $char }
        elsif ($code > 0xFFFF) {
            my $offset = $code - 0x10000;
            $out .= sprintf('\\u%04x\\u%04x', 0xD800 + ($offset >> 10), 0xDC00 + ($offset & 0x3FF));
        }
        else { $out .= sprintf('\\u%04x', $code) }
    }
    return $out . '"';
}

sub json_node {
    my ($node, $level) = @_;
    return 'null' unless defined $node;
    my $type = ref $node;
    return ${$node} if $type eq 'Int';
    my $pad = '  ' x ($level + 1);
    my $end = '  ' x $level;
    if ($type eq 'Dict') {
        my @pairs = @{$node};
        return '{}' unless @pairs;
        my @items;
        while (my ($key, $value) = splice(@pairs, 0, 2)) {
            push @items, $pad . json_string($key) . ': ' . json_node($value, $level + 1);
        }
        return "{\n" . join(",\n", @items) . "\n$end}";
    }
    if ($type eq 'ARRAY') {
        return '[]' unless @{$node};
        return "[\n" . join(",\n", map { $pad . json_node($_, $level + 1) } @{$node}) . "\n$end]";
    }
    return json_string($node);
}

sub write_file {
    my ($path, $text) = @_;
    open(my $fh, '>:raw', $path) or die "$path: $!\n";
    print {$fh} Encode::encode('UTF-8', $text);
    close($fh) or die "$path: $!\n";
    return;
}

# Text of a file with invalid bytes replaced, or an empty string when it is absent.
sub read_text {
    my ($path) = @_;
    open(my $fh, '<:raw', $path) or return '';
    my $bytes = do { local $/; <$fh> };
    close($fh);
    return defined $bytes ? Encode::decode('UTF-8', $bytes, Encode::FB_DEFAULT) : '';
}

sub monotonic { return Time::HiRes::clock_gettime(Time::HiRes::CLOCK_MONOTONIC()) }
sub pause { select(undef, undef, undef, POLL_INTERVAL); return }

# Starts a child process and returns its handle. The environment is replaced by
# the given one; stdout and stderr go to the open handle, and a stdin pipe is
# kept open for the parent when requested.
sub spawn {
    my (%opt) = @_;
    my @argv = @{ $opt{argv} };
    my ($reader, $writer);
    if ($opt{stdin_pipe}) { pipe($reader, $writer) or die "pipe: $!\n" }
    my $pid = fork();
    defined $pid or die "fork: $!\n";
    if (!$pid) {
        if (defined $opt{cwd}) { chdir($opt{cwd}) or POSIX::_exit(126) }
        if ($reader) { close($writer); open(STDIN, '<&', $reader) or POSIX::_exit(126) }
        open(STDOUT, '>&', $opt{output}) or POSIX::_exit(126);
        open(STDERR, '>&', $opt{output}) or POSIX::_exit(126);
        %ENV = %{ $opt{env} };
        exec { $argv[0] } @argv or POSIX::_exit(127);
    }
    my %process = (pid => $pid, status => undef);
    if ($reader) {
        close($reader);
        $writer->autoflush(1);
        $process{stdin} = $writer;
    }
    return \%process;
}

# The exit status of a process that has ended, negative for a signal, or undef while it runs.
sub poll_process {
    my ($process) = @_;
    return $process->{status} if defined $process->{status};
    my $done = waitpid($process->{pid}, POSIX::WNOHANG());
    if ($done == $process->{pid}) {
        $process->{status} = ($? & 127) ? -($? & 127) : $? >> 8;
    }
    return $process->{status};
}

sub wait_process {
    my ($process, $seconds) = @_;
    my $deadline = monotonic() + $seconds;
    while (monotonic() < $deadline) {
        return 1 if defined poll_process($process);
        pause();
    }
    return defined poll_process($process) ? 1 : 0;
}

sub wait_for {
    my ($predicate, $timeout, $description, @processes) = @_;
    my $deadline = monotonic() + $timeout;
    while (monotonic() < $deadline) {
        for my $process (@processes) {
            my $status = poll_process($process);
            die "$description: process exited with $status\n" if defined $status;
        }
        return if $predicate->();
        pause();
    }
    die "Timed out: $description\n";
}

sub free_port {
    my $probe = IO::Socket::INET->new(LocalAddr => '127.0.0.1', LocalPort => 0, Proto => 'tcp', Listen => 1)
        or die "free port: $!\n";
    my $port = $probe->sockport;
    close($probe);
    return $port;
}

sub listening {
    my ($port) = @_;
    my $socket = IO::Socket::INET->new(PeerAddr => '127.0.0.1', PeerPort => $port, Proto => 'tcp', Timeout => 0.2);
    return 0 unless $socket;
    close($socket);
    return 1;
}

# Ends a process: asks the IOC shell to exit when it has a stdin pipe, then
# terminates and finally kills it.
sub stop_process {
    my ($process) = @_;
    return if !$process || defined poll_process($process);
    if ($process->{stdin}) {
        my $written = eval { local $SIG{PIPE} = 'IGNORE'; print { $process->{stdin} } "exit\n" and $process->{stdin}->flush; };
        return if $written && wait_process($process, 5);
    }
    kill('TERM', $process->{pid});
    return if wait_process($process, 5);
    kill('KILL', $process->{pid});
    waitpid($process->{pid}, 0);
    $process->{status} = ($? & 127) ? -($? & 127) : $? >> 8;
    return;
}

sub random_hex {
    open(my $fh, '<:raw', '/dev/urandom') or die "/dev/urandom: $!\n";
    read($fh, my $bytes, 6) == 6 or die "/dev/urandom: short read\n";
    close($fh);
    return unpack('H*', $bytes);
}

sub run_case {
    my ($args, $name, $option, $log_port, $omit_host) = @_;
    my $case_dir = "$args->{output}/$name";
    mkdir($case_dir) or die "$case_dir: $!\n";
    my $prefix = 'M6_' . random_hex() . ':';
    my $pv = $prefix . 'Value';
    my ($receiver_file, $ioc_file, $client_file) = ("$case_dir/received.log", "$case_dir/ioc.log", "$case_dir/clients.log");
    my %env = map { $_ => $ENV{$_} } grep { !/\A(?:EPICS_CA_|EPICS_CAS_|EPICS_IOC_LOG_)/ } keys %ENV;
    my $ca_port = free_port();
    %env = (%env,
        EXAMPLE_TOP => $args->{example}, IOCSH_TOP => $args->{iocsh_top}, TEST_PREFIX => $prefix,
        EPICS_CA_AUTO_ADDR_LIST => 'NO', EPICS_CA_ADDR_LIST => '127.0.0.1', EPICS_CA_SERVER_PORT => "$ca_port",
        EPICS_CAS_INTF_ADDR_LIST => '127.0.0.1', EPICS_CAS_BEACON_ADDR_LIST => '127.0.0.1',
        EPICS_CAS_AUTO_BEACON_ADDR_LIST => 'NO', EPICS_IOC_LOG_PORT => "$log_port",
        EPICS_IOC_LOG_FILE_NAME => $receiver_file, EPICS_IOC_LOG_FILE_LIMIT => '1000000',
    );
    my @macros = $omit_host ? () : ('LOG_INET=127.0.0.1');
    push @macros, "LOG_INET_PORT=$log_port", "OPTION=$option" if defined $option;
    $env{CAPUTLOG_MACROS} = join(',', @macros);
    delete @env{qw(LOG_INET LOG_INET_PORT OPTION EPICS_CA_PUT_LOG_ADDR)};
    write_file("$case_dir/inputs.json", json_node(dict(
        prefix => $prefix, macros => $env{CAPUTLOG_MACROS}, log_port => int_value($log_port), ca_port => $env{EPICS_CA_SERVER_PORT},
    ), 0) . "\n");
    my ($server, $ioc);
    my $put = sub {
        my ($value) = @_;
        my $output = File::Temp->new;
        my $pid = fork();
        defined $pid or die "fork: $!\n";
        if (!$pid) {
            open(STDOUT, '>&', $output) or POSIX::_exit(126);
            open(STDERR, '>&', $output) or POSIX::_exit(126);
            %ENV = %env;
            exec { "$args->{base_bin}/caput" } "$args->{base_bin}/caput", '-w', '3', $pv, "$value" or POSIX::_exit(127);
        }
        my $timed_out = !eval { local $SIG{ALRM} = sub { die "timeout\n" }; alarm(5); waitpid($pid, 0); alarm(0); 1 };
        if ($timed_out) { kill('KILL', $pid); waitpid($pid, 0) }
        my $status = $?;
        seek($output, 0, 0);
        my $text = do { local $/; readline($output) };
        $text = defined $text ? Encode::decode('UTF-8', $text, Encode::FB_DEFAULT) : '';
        open(my $log, '>>:raw', $client_file) or die "$client_file: $!\n";
        print {$log} Encode::encode('UTF-8', $text);
        close($log) or die "$client_file: $!\n";
        die "Command 'caput -w 3 $pv $value' timed out after 5 seconds\n" if $timed_out;
        if ($status != 0) {
            (my $trimmed = $text) =~ s/\A\s+|\s+\z//g;
            die "caput failed for $pv: $trimmed\n";
        }
        return;
    };
    my $messages = sub { return grep { index($_, $pv) >= 0 } split /\n/, read_text($receiver_file) };
    my $result;
    my $ok = eval {
        open(my $server_output, '>:raw', "$case_dir/server.log") or die "$case_dir/server.log: $!\n";
        open(my $ioc_output, '>:raw', $ioc_file) or die "$ioc_file: $!\n";
        # Refuse to use a receiver belonging to another process.
        socket(my $probe, Socket::PF_INET(), Socket::SOCK_STREAM(), 0) or die "socket: $!\n";
        bind($probe, Socket::pack_sockaddr_in($log_port, Socket::inet_aton('127.0.0.1'))) or die "bind: $!\n";
        close($probe);
        $server = spawn(argv => [ "$args->{base_bin}/iocLogServer" ], env => \%env, output => $server_output);
        wait_for(sub { listening($log_port) }, $args->{timeout}, 'log server ready', $server);
        $ioc = spawn(argv => [ 'bash', '-c', 'script=$1; shift; command=("$@"); set --; source "$script" || exit 3; exec "${command[@]}"', 'bash', $args->{env_script},
                               'stdbuf', '-oL', '-eL', $args->{iocsh}, $args->{startup} ],
                     cwd => $case_dir, env => \%env, output => $ioc_output, stdin_pipe => 1);
        wait_for(sub { index(read_text($ioc_file), 'iocRun: All initialization complete') >= 0 }, $args->{timeout}, 'IOC initialized', $server, $ioc);
        my $active = !(defined $option && ($option == -1 || $option == 9)) && !$omit_host;
        if ($active) {
            wait_for(sub { index(read_text($ioc_file), 'caPutLog: successfully initialized') >= 0 }, $args->{timeout}, 'caPutLog initialized', $server, $ioc);
            my $output = read_text($ioc_file);
            my ($ready, $config) = (index($output, 'iocRun: All initialization complete'), index($output, 'caPutLogInit config:'));
            die "substring not found\n" if $config < 0;
            die "Logger initialized before IOC initialization completed\n" if $ready > $config;
        }
        else {
            my $expected = defined $option && $option == -1 ? 'Disabled' : 'Unknown (must be -1, 0, 1, or 2)';
            $expected = 'macLib: macro LOG_INET is ' if $omit_host;
            wait_for(sub { index(read_text($ioc_file), $expected) >= 0 }, $args->{timeout}, 'expected startup diagnostic', $server, $ioc);
            die "Unexpected successful initialization\n" if index(read_text($ioc_file), 'caPutLog: successfully initialized') >= 0;
        }
        $put->(17);
        if ($active) {
            wait_for(sub { scalar grep { /new=17/ && /old=0/ } $messages->() }, $args->{timeout}, 'first real put received', $server, $ioc);
            my $baseline = () = $messages->();
            $put->(17);
            if (defined $option && ($option == 1 || $option == 2)) {
                wait_for(sub { (() = $messages->()) > $baseline }, $args->{timeout}, 'unchanged put received', $server, $ioc);
            }
            else {
                my $deadline = monotonic() + QUIET_WINDOW;
                while (monotonic() < $deadline) {
                    die "Process exited during unchanged-value check\n" if defined poll_process($ioc) || defined poll_process($server);
                    die "Default mode logged an unchanged put\n" if (() = $messages->()) != $baseline;
                    pause();
                }
            }
            $put->(29);
            wait_for(sub { scalar grep { /new=29/ && /old=17/ } $messages->() }, $args->{timeout}, 'second value change received', $server, $ioc);
        }
        else {
            my $deadline = monotonic() + QUIET_WINDOW;
            while (monotonic() < $deadline) {
                die "Process exited during negative check\n" if defined poll_process($ioc) || defined poll_process($server);
                die "Unexpected put log for disabled/invalid startup\n" if $messages->();
                pause();
            }
        }
        $result = dict(case => $name, result => 'Pass', received => int_value(scalar(() = $messages->())));
        1;
    };
    my $error = $@;
    stop_process($ioc);
    stop_process($server);
    die $error if !$ok && $error =~ /\Ainterrupted\n/;
    if (!$ok) {
        $error =~ s/\n\z//;
        die "$error\n";
    }
    return $result;
}

sub main {
    my %args = (arch => 'linux-x86_64', timeout => DEFAULT_TIMEOUT);
    my $help = 0;
    GetOptions('base=s' => \$args{base}, 'arch=s' => \$args{arch}, 'iocsh-top=s' => \$args{iocsh_top},
               'output=s' => \$args{output}, 'timeout=f' => \$args{timeout}, 'help|h' => \$help)
        or pod2usage(-exitval => EXIT_USAGE, -verbose => 0, -output => \*STDERR);
    pod2usage(-exitval => EXIT_OK, -verbose => 1, -output => \*STDOUT) if $help;
    (!@ARGV && defined $args{base} && defined $args{output})
        or pod2usage(-exitval => EXIT_USAGE, -verbose => 0, -output => \*STDERR);
    my $usage_error = sub { print STDERR "verify_caputlog.pl: error: $_[0]\n"; return EXIT_USAGE };
    $args{example} = File::Basename::dirname(Cwd::abs_path($0));
    my $base = Cwd::abs_path($args{base});
    defined $base or return $usage_error->("Required file not found: $args{base}");
    $args{base} = $base;
    $args{base_bin} = "$base/bin/$args{arch}";
    $args{iocsh} = "$args{base_bin}/iocsh.bash";
    $args{env_script} = File::Basename::dirname($base) . '/setEpicsEnv.bash';
    $args{startup} = "$args{example}/iocBoot/caPutLog-shell.cmd";
    my $top = defined $args{iocsh_top} ? $args{iocsh_top} : File::Basename::dirname(File::Basename::dirname($args{example})) . '/commonIocsh';
    $args{iocsh_top} = Cwd::abs_path($top) // $top;
    $args{fragment} = "$args{iocsh_top}/iocsh/caPutLog.iocsh";
    $args{output} = File::Spec->rel2abs($args{output});
    for my $path ($args{iocsh}, $args{env_script}, $args{startup}, "$args{base_bin}/caput", "$args{base_bin}/iocLogServer", $args{fragment}) {
        return $usage_error->("Required file not found: $path") unless -f $path;
    }
    my $stdbuf = grep { -x "$_/stdbuf" } split /:/, $ENV{PATH} // '';
    return $usage_error->('stdbuf is required for observable IOC output') unless $stdbuf;
    return $usage_error->('--timeout must be positive') unless $args{timeout} > 0;
    -e $args{output} and die "$args{output}: File exists\n";
    File::Path::make_path($args{output});
    -d $args{output} or die "$args{output}: $!\n";
    local $SIG{INT}  = sub { die "interrupted\n" };
    local $SIG{TERM} = sub { die "interrupted\n" };
    my @results;
    my @cases = (
        [ 'defaults', undef, DEFAULT_LOG_PORT, 0 ], [ 'all_puts', 1, free_port(), 0 ], [ 'unfiltered', 2, free_port(), 0 ],
        [ 'disabled', -1, free_port(), 0 ], [ 'invalid_option', 9, free_port(), 0 ], [ 'missing_host', undef, DEFAULT_LOG_PORT, 1 ],
    );
    for my $case (@cases) {
        my ($name, $option, $port, $omit_host) = @{$case};
        my $result = eval { run_case(\%args, $name, $option, $port, $omit_host) };
        if (!$result) {
            my $error = $@;
            die $error if $error =~ /\Ainterrupted\n/;
            $error =~ s/\n\z//;
            $result = dict(case => $name, result => 'Fail', error => $error);
        }
        push @results, $result;
        my %fields = @{$result};
        printf "[ %s ] %s: %s\n", uc $fields{result}, $name, exists $fields{error} ? $fields{error} : 'observed expected behavior';
        STDOUT->flush;
        my $report = dict(
            base => $args{base}, ioc => $args{iocsh}, fragment => $args{fragment},
            fragment_sha256 => Digest::SHA->new(256)->addfile($args{fragment}, 'b')->hexdigest, cases => \@results,
        );
        write_file("$args{output}/summary.json", json_node($report, 0) . "\n");
    }
    print "Evidence: $args{output}\n";
    return (grep { { @{$_} }->{result} ne 'Pass' } @results) ? EXIT_ERROR : EXIT_OK;
}

my $status;
eval {
    $status = main();
    defined $status or die "internal error: main returned no exit status\n";
    1;
} or do {
    my $error = $@;
    print STDERR "verify_caputlog.pl: $error";
    $status = $error =~ /\Ainterrupted\n/ ? 130 : EXIT_ERROR;
};
exit $status;

__END__

=head1 NAME

verify_caputlog.pl - verify the shipped caPutLog fragment with real EPICS processes

=head1 SYNOPSIS

verify_caputlog.pl --base <installed-base> --output <new-directory> [--arch <arch>] [--iocsh-top <dir>] [--timeout <seconds>]

=head1 DESCRIPTION

Runs six cases (defaults, all_puts, unfiltered, disabled, invalid_option,
missing_host), each with its own iocLogServer, an IOC started by the
C<iocsh.bash> of the installed tree with C<iocBoot/caPutLog-shell.cmd>, and
caput clients, and checks the messages the log server receives. The tree is the
directory that holds B<base>, and its C<setEpicsEnv.bash> is sourced for the
IOC. The output directory must not exist; it receives one directory per case
and summary.json. No IOC has to be built.

=head1 OPTIONS

=over 4

=item B<--base> I<dir>

The installed EPICS Base.

=item B<--output> I<dir>

A new directory for the evidence.

=item B<--arch> I<name>

The host architecture, default C<linux-x86_64>.

=item B<--iocsh-top> I<dir>

The commonIocsh checkout, default the one next to the examples directory.

=item B<--timeout> I<seconds>

The wait for each readiness condition, default 30.

=item B<--help>, B<-h>

Print this help and exit with status 0.

=back

=head1 EXIT STATUS

0 when every case passes, 1 when a case fails, 2 on a usage error or a missing prerequisite.

=cut
