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
# Verifies the retained linStat carries against the real pinned source without
# a full IOC build: the carries and the site patch are applied to exported
# copies of the pin, the real table sources are compiled with a controlled
# clock, and the RTC, netstat, MSI database and CONFIG results are asserted.
# Every command, its environment, status and output is written to report.json
# in the established byte layout (two-space indentation, ASCII-only escapes).

use strict;
use warnings;

use Cwd ();
use Digest::SHA ();
use Encode ();
use File::Basename ();
use File::Copy ();
use File::Glob qw(bsd_glob);
use File::Path ();
use File::Spec ();
use File::Temp ();
use Getopt::Long qw(GetOptions);
use Pod::Usage qw(pod2usage);
use POSIX ();
use Time::HiRes ();
use Time::Local ();

use constant EXIT_OK    => 0;
use constant EXIT_ERROR => 1;
use constant EXIT_USAGE => 2;

use constant PIN           => 'b4729e43c8ee9791975abbc7e06b870f46fb9661';
use constant TIMEZONE      => 'America/Los_Angeles';
use constant COMMAND_LIMIT => 120;


# Temporary files are created below work/scratch of the repository (EPICS_ENV_SCRATCH names another
# directory), and each run removes them when it ends. Child commands inherit TMPDIR.
my $SCRATCH_BASE = $ENV{EPICS_ENV_SCRATCH} // File::Basename::dirname(File::Basename::dirname(File::Basename::dirname(Cwd::abs_path($0)))) . '/work/scratch';
File::Path::make_path($SCRATCH_BASE);
-d $SCRATCH_BASE && -w _ or die "$SCRATCH_BASE: not a writable directory\n";
$ENV{TMPDIR} = $SCRATCH_BASE;

my $ROOT = File::Basename::dirname(File::Basename::dirname(File::Basename::dirname(Cwd::abs_path($0))));
my $PROBE_SOURCE = File::Basename::dirname(Cwd::abs_path($0)) . '/table_probe.cpp';
my $AXIS_EPOCH = Time::Local::timegm(0, 0, 12, 15, 6, 2026);

# Ordered JSON values: a dictionary keeps its pairs in insertion order, and an
# integer or boolean is tagged so that it is not written as a string.
sub dict { return bless [@_], 'Dict' }
sub int_value { my ($n) = @_; return bless \(my $copy = $n + 0), 'Int' }
sub bool_value { my ($b) = @_; return bless \(my $copy = $b ? 1 : 0), 'Bool' }

my %SHORT_ESCAPE = ("\n" => '\\n', "\r" => '\\r', "\t" => '\\t', "\b" => '\\b', "\f" => '\\f', '"' => '\\"', '\\' => '\\\\');

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

# Writes a value with two-space indentation, as json.dumps(indent=2) does.
sub json_node {
    my ($node, $level) = @_;
    return 'null' unless defined $node;
    my $type = ref $node;
    return ${$node} if $type eq 'Int';
    return ${$node} ? 'true' : 'false' if $type eq 'Bool';
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

sub read_bytes {
    my ($path) = @_;
    open(my $fh, '<:raw', $path) or die "$path: $!\n";
    my $content = do { local $/; <$fh> };
    close($fh);
    return defined $content ? $content : '';
}

sub write_text {
    my ($path, $text) = @_;
    open(my $fh, '>:raw', $path) or die "$path: $!\n";
    print {$fh} Encode::encode('UTF-8', $text);
    close($fh) or die "$path: $!\n";
    return;
}

# Returns an absolute path with symlinks resolved as far as the path exists and
# the remaining components appended lexically.
sub resolve_path {
    my ($path) = @_;
    my $head = File::Spec->rel2abs($path);
    my @rest;
    until (-e $head || -l $head || $head eq '/') {
        unshift @rest, File::Basename::basename($head);
        $head = File::Basename::dirname($head);
    }
    my $real = Cwd::abs_path($head);
    defined $real or die "$head: $!\n";
    for my $part (@rest) {
        next if $part eq '.';
        if ($part eq '..') { $real = File::Basename::dirname($real); next }
        $real = $real eq '/' ? "/$part" : "$real/$part";
    }
    return $real;
}

sub ensure {
    my ($condition, $what) = @_;
    $condition or die "Assertion failed: $what\n";
    return;
}

sub now_iso {
    my ($seconds, $micro) = Time::HiRes::gettimeofday();
    my @t = gmtime($seconds);
    my $text = sprintf('%04d-%02d-%02dT%02d:%02d:%02d', $t[5] + 1900, $t[4] + 1, $t[3], $t[2], $t[1], $t[0]);
    $text .= sprintf('.%06d', $micro) if $micro;
    return $text . '+00:00';
}

# The calendar fields of one instant in the verification time zone.
sub local_fields {
    my ($epoch) = @_;
    my @fields;
    {
        local $ENV{TZ} = TIMEZONE;
        POSIX::tzset();
        @fields = localtime($epoch);
    }
    POSIX::tzset();
    return @fields;
}

sub parse_instant {
    my ($instant) = @_;
    $instant =~ /\A(\d{4})-(\d\d)-(\d\d)T(\d\d):(\d\d):(\d\d)\z/ or die "bad instant $instant\n";
    return Time::Local::timegm($6, $5, $4, $3, $2 - 1, $1);
}

sub replace_all {
    my ($text, $old, $new) = @_;
    $text =~ s/\Q$old\E/$new/g;
    return $text;
}

sub new_verification {
    my ($args) = @_;
    my $work = resolve_path($args->{work_dir});
    -e $work and die "$work: File exists\n";
    File::Path::make_path($work);
    -d $work or die "$work: $!\n";
    return { args => $args, work => $work, commands => [], results => [] };
}

sub set_result {
    my ($self, $key, $value) = @_;
    push @{ $self->{results} }, $key, $value;
    return;
}

# Runs one command with the environment of this process plus LC_ALL=C and the
# given variables, records it, and fails when its status is not the expected one.
sub run_command {
    my ($self, $argv, %opt) = @_;
    my $cwd      = defined $opt{cwd} ? $opt{cwd} : $self->{work};
    my $expected = exists $opt{expected} ? $opt{expected} : 0;
    my $data     = $opt{data};
    my %env      = %{ $opt{env} || {} };
    my @argv     = map { "$_" } @{$argv};
    my $out      = File::Temp->new;
    my $err      = File::Temp->new;
    my $in;
    if (defined $data) {
        $in = File::Temp->new;
        print {$in} Encode::encode('UTF-8', $data);
        close($in) or die "stdin: $!\n";
    }
    my $pid = fork();
    defined $pid or die "fork: $!\n";
    if (!$pid) {
        chdir($cwd) or POSIX::_exit(126);
        if ($in) { open(STDIN, '<', $in->filename) or POSIX::_exit(126) }
        open(STDOUT, '>&', $out) or POSIX::_exit(126);
        open(STDERR, '>&', $err) or POSIX::_exit(126);
        $ENV{LC_ALL} = 'C';
        $ENV{$_} = $env{$_} for keys %env;
        exec { $argv[0] } @argv or POSIX::_exit(127);
    }
    my $timed_out = 0;
    eval {
        local $SIG{ALRM} = sub { die "timeout\n" };
        alarm(COMMAND_LIMIT);
        waitpid($pid, 0);
        alarm(0);
        1;
    } or do {
        $timed_out = 1;
        kill('KILL', $pid);
        waitpid($pid, 0);
    };
    my $status = $?;
    my $code   = ($status & 127) ? -($status & 127) : $status >> 8;
    for my $handle ($out, $err) { seek($handle, 0, 0) }
    my ($stdout, $stderr) = map { my $bytes = do { local $/; readline($_) }; defined $bytes ? $bytes : '' } ($out, $err);
    $stdout = Encode::decode('UTF-8', $stdout, Encode::FB_CROAK);
    $stderr = Encode::decode('UTF-8', $stderr, Encode::FB_CROAK);
    push @{ $self->{commands} }, dict(
        argv => \@argv, cwd => "$cwd", time => now_iso(), env => dict(map { ($_ => $env{$_}) } sort keys %env),
        stdin => $data, exit_code => int_value($code), stdout => $stdout, stderr => $stderr,
    );
    die 'Command timed out after ' . COMMAND_LIMIT . " seconds: @argv\n" if $timed_out;
    if (defined $expected && $code != $expected) {
        die "Unexpected exit $code: @argv\n$stderr";
    }
    return { code => $code, stdout => $stdout, stderr => $stderr };
}

sub export_tree {
    my ($self, $label) = @_;
    my $tree = "$self->{work}/$label/linStat-src";
    File::Path::make_path($tree);
    run_command($self, [ 'tar', '-xf', "$self->{work}/pin.tar", '-C', $tree ]);
    return $tree;
}

sub apply_patch {
    my ($self, $tree, $patch) = @_;
    my @args = ('patch', '--batch', '--fuzz=0', '--no-backup-if-mismatch', '-p0', '-i', $patch);
    run_command($self, [ @args, '--dry-run' ], cwd => $tree);
    run_command($self, \@args, cwd => $tree);
    return;
}

sub compile_probe {
    my ($self, $tree, $table, $label) = @_;
    my $src  = "$tree/statApp/src";
    my $base = resolve_path($self->{args}{base});
    my $arch = $self->{args}{arch};
    my $executable = "$self->{work}/$label";
    my $rtc = $table eq 'rtc';
    run_command($self, [
        $self->{args}{cxx}, '-std=c++17', '-g', '-O1', '-fsanitize=undefined',
        '-fno-sanitize-recover=all', '-pthread',
        '-DTABLE_SOURCE="' . ($rtc ? 'tblRTC.cpp' : 'tblNetstat.cpp') . '"',
        '-DTABLE_REGISTER=' . ($rtc ? 'linStatRTCTable' : 'linStatNetstatTable'),
        '-DTABLE_NAME="' . $table . '"',
        "-I$src", "-I$base/include", "-I$base/include/os/Linux", "-I$base/include/compiler/gcc",
        $PROBE_SOURCE, "$src/tblBase.cpp", "$src/nlreact.cpp", "$src/iochooks.cpp",
        "-L$base/lib/$arch", "-Wl,-rpath,$base/lib/$arch",
        '-ldbCore', '-lCom', '-ldl', '-o', $executable,
    ]);
    return $executable;
}

sub probe {
    my ($self, $executable, $fixture, $epoch, %opt) = @_;
    my $result = run_command($self, [ $executable, $fixture, "$epoch" ], expected => (exists $opt{expected} ? $opt{expected} : 0),
        env => { TZ => TIMEZONE, UBSAN_OPTIONS => 'print_stacktrace=1' });
    my %values;
    for my $line (split /\n/, $result->{stdout}) {
        next unless $line =~ /=/;
        my ($key, $value) = split /=/, $line, 2;
        $values{$key} = $value;
    }
    return ($result, \%values);
}

sub verify_rtc {
    my ($self, $upstream, $corrected) = @_;
    my $old = compile_probe($self, $upstream, 'rtc', 'rtc-upstream');
    my $new = compile_probe($self, $corrected, 'rtc', 'rtc-corrected');
    my @cases;
    my @instants = (
        '2026-01-15T12:00:00', '2026-07-15T12:00:00', '2026-03-08T09:59:00',
        '2026-03-08T10:01:00', '2026-11-01T07:59:00', '2026-11-01T10:01:00',
    );
    for my $instant (@instants) {
        my $epoch = parse_instant($instant);
        for my $kind (['utc', 0], ['local', 1]) {
            my ($label, $ref) = @{$kind};
            my @fields = $label eq 'utc' ? gmtime($epoch) : local_fields($epoch);
            (my $name = $instant) =~ s/:/-/g;
            $name .= "-$label";
            my $fixture = "$self->{work}/$name.rtc";
            write_text($fixture, POSIX::strftime("rtc_date : %Y-%m-%d\nrtc_time : %H:%M:%S\nbatt_status : okay\n", @fields));
            my (undef, $values) = probe($self, $new, $fixture, $epoch);
            ensure($values->{delta} eq '0' && $values->{ref} eq "$ref", "$name delta and ref");
            ensure($values->{battery} eq '2' && $values->{last_ok} eq '1', "$name battery and last_ok");
            push @cases, $name;
            if ($instant eq '2026-07-15T12:00:00' && $label eq 'local') {
                my (undef, $before) = probe($self, $old, $fixture, $epoch);
                ensure($before->{delta} eq '3600', 'upstream reports the false DST difference');
                set_result($self, dst_before_after => [ int_value($before->{delta}), int_value($values->{delta}) ]);
            }
        }
    }
    my $valid = "rtc_date : 2026-07-15\nrtc_time : 12:00:00\nbatt_status : okay\n";
    my @variants = (
        [ 'bad-date',      replace_all($valid, '2026-07-15', 'invalid') ],
        [ 'bad-time',      replace_all($valid, '12:00:00', 'invalid') ],
        [ 'trailing-date', replace_all($valid, '2026-07-15', '2026-07-15x') ],
        [ 'trailing-time', replace_all($valid, '12:00:00', '12:00:00x') ],
        [ 'missing-date',  replace_all($valid, "rtc_date : 2026-07-15\n", '') ],
        [ 'missing-time',  replace_all($valid, "rtc_time : 12:00:00\n", '') ],
    );
    for my $variant (@variants) {
        my ($name, $content) = @{$variant};
        my $fixture = "$self->{work}/$name.rtc";
        write_text($fixture, $content);
        my (undef, $values) = probe($self, $new, $fixture, $AXIS_EPOCH);
        ensure(!exists $values->{delta} && !exists $values->{ref}, "$name omits delta and ref");
        ensure($values->{battery} eq '2', "$name battery");
        if ($name =~ /\Abad-/) {
            my ($before) = probe($self, $old, $fixture, $AXIS_EPOCH, expected => undef);
            ensure($before->{code} != 0 && index($before->{stderr}, 'null pointer') >= 0, "$name upstream null pointer");
        }
        push @cases, $name;
    }
    my (undef, $absent) = probe($self, $new, "$self->{work}/absent.rtc", $AXIS_EPOCH);
    ensure($absent->{last_ok} eq '0' && !exists $absent->{delta}, 'missing file');
    push @cases, 'missing-file';
    my $offset = "$self->{work}/offset.rtc";
    write_text($offset, replace_all($valid, '12:00:00', '11:59:55'));
    my (undef, $shifted) = probe($self, $new, $offset, $AXIS_EPOCH);
    ensure($shifted->{delta} eq '5' && $shifted->{ref} eq '0', 'five second offset');
    push @cases, 'utc-five-second-offset';
    set_result($self, rtc_cases => \@cases);
    return;
}

sub verify_netstat {
    my ($self, $pin, $corrected) = @_;
    my $fixture = "$self->{work}/netstat.capture";
    open(my $out, '>:raw', $fixture) or die "$fixture: $!\n";
    print {$out} read_bytes('/proc/net/netstat');
    close($out) or die "$fixture: $!\n";
    my @observations;
    for my $item ([ $pin, 'netstat-pin' ], [ $corrected, 'netstat-corrected' ]) {
        my $executable = compile_probe($self, $item->[0], 'netstat', $item->[1]);
        my (undef, $values) = probe($self, $executable, $fixture, $AXIS_EPOCH);
        ensure($values->{last_ok} eq '1' && keys %{$values} > 2, 'netstat values');
        push @observations, $values;
    }
    my @keys = (sort keys %{ $observations[0] });
    ensure(join("\0", @keys) eq join("\0", sort keys %{ $observations[1] }), 'netstat keys equal');
    ensure(!grep({ $observations[0]{$_} ne $observations[1]{$_} } @keys), 'netstat values equal');
    set_result($self, netstat_equal_values => int_value(scalar(keys %{ $observations[0] }) - 2));
    return;
}

sub record_names {
    my ($text) = @_;
    return $text =~ /record\([^,]+,\s*"([^"]+)"/g;
}

sub verify_databases {
    my ($self, $pin, $corrected) = @_;
    my $msi = resolve_path($self->{args}{base}) . "/bin/$self->{args}{arch}/msi";
    my @legacy;
    for my $item ([ $pin, 'pin' ], [ $corrected, 'corrected' ]) {
        my ($tree, $label) = @{$item};
        my $dbdir = "$tree/statApp/Db";
        my $db    = "$self->{work}/$label-nic.db";
        write_text($db, run_command($self, [ $msi, '-S', 'linStatNIC.substitutions' ], cwd => $dbdir)->{stdout});
        push @legacy, run_command($self, [ $msi, '-V', '-M', 'IOC=VERIFY,NIC=lo', $db ])->{stdout};
        next unless $label eq 'corrected';
        for my $macros ('P=CUSTOM:NET,NIC=lo', 'P=CUSTOM:NET,IOC=VERIFY,NIC=lo') {
            my $expanded = run_command($self, [ $msi, '-V', '-M', $macros, $db ])->{stdout};
            my @names = record_names($expanded);
            ensure(@names == 48 && !grep({ index($_, 'CUSTOM:NET:') != 0 } @names), "48 custom records for $macros");
            ensure(index($expanded, 'ifstat|lo|') >= 0, 'ifstat record');
        }
        write_text("$self->{work}/netStat.db", run_command($self, [ $msi, '-S', 'netStat.substitutions' ], cwd => $dbdir)->{stdout});
        my $hostdb = "$self->{work}/host.db";
        write_text($hostdb, run_command($self, [ $msi, '-I', $dbdir, '-I', $self->{work}, '-S', 'linStatHost.substitutions' ], cwd => $dbdir)->{stdout});
        my $host  = run_command($self, [ $msi, '-V', '-M', 'IOC=VERIFY', $hostdb ])->{stdout};
        my %names = map { $_ => 1 } record_names($host);
        ensure(!grep({ !$names{"VERIFY:RTC:$_"} } qw(DLT REF BAT)), 'RTC host records');
    }
    ensure($legacy[0] eq $legacy[1], 'legacy NIC expansion is equal');
    set_result($self, nic_legacy_equal => bool_value(1));
    set_result($self, nic_custom_records => int_value(48));
    set_result($self, rtc_records => int_value(3));
    return;
}

sub verify_configuration {
    my ($self, $pin, $corrected) = @_;
    my $base = resolve_path($self->{args}{base});
    my @generic;
    for my $tree ($pin, $corrected) {
        my $parent  = File::Basename::dirname($tree);
        my $install = "$parent/install";
        File::Path::make_path("$install/cfg");
        File::Copy::copy("$tree/configure/CONFIG_LINSTAT_VERSION", "$install/cfg/CONFIG_LINSTAT_VERSION")
            or die "CONFIG_LINSTAT_VERSION: $!\n";
        write_text("$tree/configure/RELEASE.local", "EPICS_BASE=$base\n");
        write_text("$tree/configure/CONFIG_SITE.local", "INSTALL_LOCATION=$install\n");
        my $probe = "TOP=$tree\ninclude \$(TOP)/configure/CONFIG\n\$(info VERSION=\$(LINSTAT_1_2_1))\n.PHONY: probe\nprobe:;\@true\n";
        my @command = ('make', '--no-print-directory', '-f', '-', 'probe', "EPICS_HOST_ARCH=$self->{args}{arch}");
        push @generic, run_command($self, \@command, cwd => $tree, data => $probe)->{stdout};
        run_command($self, [
            'make', '--no-print-directory', '-f', "$ROOT/configure/RULES_MODS_CONFIG", 'conf.linStat',
            "TOP=$parent", 'SRC_PATH_MODULES=linStat-src', "INSTALL_LOCATION_BASE=$base", "INSTALL_LOCATION_LINSTAT=$install",
        ]);
        my $actual = run_command($self, \@command, cwd => $tree, data => $probe)->{stdout};
        ensure(index($actual, 'VERSION=YES') >= 0, 'the existing recipe resolves the version');
    }
    ensure(index($generic[0], "VERSION=\n") >= 0 && index($generic[1], 'VERSION=YES') >= 0, 'generic configuration');
    set_result($self, generic_config_fixed => bool_value(1));
    set_result($self, existing_recipe_resolves_both => bool_value(1));
    return;
}

# Fails before any source is touched when the compiler cannot link a program with the
# undefined-behavior sanitizer, which the probes need, and names the package to install.
sub check_sanitizer_runtime {
    my ($self) = @_;
    my $probe = "$self->{work}/sanitizer-probe.cpp";
    write_text($probe, "int main() { return 0; }\n");
    my $result = run_command($self, [ $self->{args}{cxx}, '-fsanitize=undefined', '-x', 'c++', $probe, '-o', "$self->{work}/sanitizer-probe" ],
                             expected => undef);
    return if $result->{code} == 0;
    die "Prerequisite missing: $self->{args}{cxx} cannot link a program with -fsanitize=undefined. "
        . "Install the C++ sanitizer runtime (libubsan on Rocky Linux and Red Hat, libubsan1 on Debian and Ubuntu) and run again.\n"
        . $result->{stderr};
}

sub execute {
    my ($self) = @_;
    check_sanitizer_runtime($self);
    my $source = resolve_path($self->{args}{source});
    my $head = run_command($self, [ 'git', '-C', $source, 'rev-parse', 'HEAD' ])->{stdout};
    $head =~ s/\A\s+|\s+\z//g;
    ensure($head eq PIN, 'the source is at the pinned commit');
    ensure(run_command($self, [ 'git', '-C', $source, 'status', '--porcelain' ])->{stdout} eq '', 'the source is clean');
    run_command($self, [ 'git', '-C', $source, 'archive', '--format=tar', "--output=$self->{work}/pin.tar", PIN ]);
    my ($pin, $upstream, $corrected) = map { export_tree($self, $_) } qw(pin upstream corrected);
    my @carries = sort { $a cmp $b } bsd_glob("$ROOT/patch/1.2.1-[0-9][0-9]-*.p0.patch");
    my @sites   = sort { $a cmp $b } bsd_glob("$ROOT/patch/1.2.1-site*.p0.patch");
    ensure(@carries == 5 && @sites == 1, 'five carries and one site patch');
    for my $tree ($upstream, $corrected) {
        apply_patch($self, $tree, $_) for @carries;
    }
    apply_patch($self, $corrected, $_) for @sites;
    set_result($self, patch_sha256 => dict(map { (File::Basename::basename($_) => Digest::SHA->new(256)->addfile($_, 'b')->hexdigest) } @carries, @sites));
    verify_rtc($self, $upstream, $corrected);
    verify_netstat($self, $pin, $corrected);
    verify_databases($self, $pin, $corrected);
    verify_configuration($self, $pin, $corrected);
    return;
}

sub write_report {
    my ($self) = @_;
    my $report = "$self->{work}/report.json";
    write_text($report, json_node(dict(results => dict(@{ $self->{results} }), commands => $self->{commands}), 0) . "\n");
    print "$report\n";
    return;
}

sub main {
    my %args = (arch => 'linux-x86_64', cxx => 'g++');
    my $help = 0;
    GetOptions(
        'source=s' => \$args{source}, 'base=s' => \$args{base}, 'work-dir=s' => \$args{work_dir},
        'arch=s' => \$args{arch}, 'cxx=s' => \$args{cxx}, 'help|h' => \$help,
    ) or pod2usage(-exitval => EXIT_USAGE, -verbose => 0, -output => \*STDERR);
    pod2usage(-exitval => EXIT_OK, -verbose => 1, -output => \*STDOUT) if $help;
    (!@ARGV && defined $args{source} && defined $args{base} && defined $args{work_dir})
        or pod2usage(-exitval => EXIT_USAGE, -verbose => 0, -output => \*STDERR);
    my $self = eval { new_verification(\%args) };
    if (!$self) {
        my $error = $@;
        print STDERR "verify.pl: $error";
        return EXIT_ERROR;
    }
    my $failure;
    if (eval { execute($self); 1 }) {
        set_result($self, status => 'PASS');
    }
    else {
        $failure = $@;
        set_result($self, status => 'FAIL');
        set_result($self, error => $failure);
    }
    write_report($self);
    if (defined $failure) {
        print STDERR "verify.pl: $failure";
        return EXIT_ERROR;
    }
    print "PASS: real-source RTC, netstat, MSI and CONFIG checks; full IOC acceptance remains pending.\n";
    return EXIT_OK;
}

my $status;
eval {
    $status = main();
    defined $status or die "internal error: main returned no exit status\n";
    1;
} or do {
    my $error = $@;
    print STDERR "verify.pl: $error";
    $status = EXIT_ERROR;
};
exit $status;

__END__

=head1 NAME

verify.pl - verify the retained linStat carries against the real pinned source

=head1 SYNOPSIS

verify.pl --source <linStat-checkout> --base <installed-base> --work-dir <new-directory> [--arch <arch>] [--cxx <compiler>]

=head1 DESCRIPTION

Exports the pinned linStat commit, applies the five carries and the site patch,
compiles the real table sources with a controlled clock and checks the RTC,
netstat, MSI database and CONFIG results. The work directory must not exist. All
commands, environments, statuses and outputs are written to report.json in it.

=head1 OPTIONS

=over 4

=item B<--source> I<dir>

The linStat checkout, clean and at the pinned commit.

=item B<--base> I<dir>

The installed EPICS Base.

=item B<--work-dir> I<dir>

A new directory for the exports, fixtures, probes and report.json.

=item B<--arch> I<name>

The host architecture, default C<linux-x86_64>.

=item B<--cxx> I<compiler>

The C++ compiler, default C<g++>.

=item B<--help>, B<-h>

Print this help and exit with status 0.

=back

=head1 EXIT STATUS

0 when every check passes, 1 when a check fails or the work directory exists, 2 on a usage error.

=cut
