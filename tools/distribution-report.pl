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
# Reports tree manifest differences, debug sections of a tree, and the
# aggregated loader, commonIocsh and caPutLog test summaries as JSON on stdout,
# in the established byte layout (two-space indentation, ASCII-only string
# escapes, object keys in their input order).

use strict;
use warnings;
use feature 'unicode_strings';

use Cwd ();
use Encode ();
use Fcntl qw(:mode);
use File::Temp ();
use Getopt::Long qw(GetOptionsFromArray);
use Pod::Usage qw(pod2usage);
use POSIX ();

use constant EXIT_OK      => 0;
use constant EXIT_FAILURE => 1;
use constant EXIT_INVALID => 2;

use File::Basename ();
use File::Path ();

# Temporary files are created below work/scratch of the repository (EPICS_ENV_SCRATCH names another
# directory), and each run removes them when it ends. Child commands inherit TMPDIR.
my $SCRATCH_BASE = $ENV{EPICS_ENV_SCRATCH} // File::Basename::dirname(File::Basename::dirname(Cwd::abs_path($0))) . '/work/scratch';
# A checkout that cannot take the directory keeps the TMPDIR it was given.
if (eval { File::Path::make_path($SCRATCH_BASE); 1 } && -d $SCRATCH_BASE && -w _) {
    $ENV{TMPDIR} = $SCRATCH_BASE;
}

my %OBSERVATION_SCRIPTS = map { $_ => 1 } qw(verify_minimal_example verify_readme_update_command observe_truncated_library);
my %CAPUTLOG_CASES      = map { $_ => 1 } qw(defaults all_puts unfiltered disabled invalid_option missing_host);
my $SUMMARY             = qr/SUMMARY ok=(\d+) fail=(\d+)/;

sub require_that {
    my ($condition, $message) = @_;
    $condition or die "$message\n";
    return;
}

# ---- ordered JSON values -------------------------------------------------
# An object keeps its keys in input order; integers, floats, booleans and null
# keep their JSON type so that the output repeats it.

sub new_object { return bless { keys => [], map => {} }, 'Object' }
sub object_set {
    my ($object, $key, $value) = @_;
    push @{ $object->{keys} }, $key unless exists $object->{map}{$key};
    $object->{map}{$key} = $value;
    return;
}
sub dict { my $object = new_object(); while (my ($k, $v) = splice(@_, 0, 2)) { object_set($object, $k, $v) } return $object }
sub int_value { my ($n) = @_; return bless \(my $copy = $n), 'Int' }
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

# The shortest decimal text that reads back as the same double, in the form
# Python's repr gives (positional for exponents -4 to 15, otherwise d.ddde+XX).
sub float_text {
    my ($text) = @_;
    my $value = $text + 0;
    return 'NaN' if $value != $value;
    return $value > 0 ? 'Infinity' : '-Infinity' if $value == 9**9**9 || $value == -9**9**9;
    my ($digits, $exponent);
    for my $precision (1 .. 17) {
        my $candidate = sprintf('%.*e', $precision - 1, $value);
        next unless $candidate + 0 == $value;
        my ($mantissa, $exp) = $candidate =~ /\A(-?[\d.]+)e([+-]\d+)\z/ or next;
        ($digits, $exponent) = ($mantissa, $exp + 0);
        last;
    }
    defined $digits or $digits = sprintf('%.16e', $value) and $exponent = 0;
    my $sign = $digits =~ s/\A-// ? '-' : '';
    $digits =~ s/\.//;
    $digits =~ s/0+\z// if length($digits) > 1;
    if ($exponent >= -4 && $exponent < 16) {
        my $body;
        if ($exponent >= 0) {
            $digits .= '0' x ($exponent + 1 - length $digits) if length($digits) < $exponent + 1;
            $body = substr($digits, 0, $exponent + 1) . '.' . (length($digits) > $exponent + 1 ? substr($digits, $exponent + 1) : '0');
        }
        else {
            $body = '0.' . ('0' x (-$exponent - 1)) . $digits;
        }
        return $sign . $body;
    }
    my $mantissa = length($digits) > 1 ? substr($digits, 0, 1) . '.' . substr($digits, 1) : $digits;
    return sprintf('%s%se%s%02d', $sign, $mantissa, $exponent < 0 ? '-' : '+', abs $exponent);
}

sub json_node {
    my ($node, $level) = @_;
    return 'null' unless defined $node;
    my $type = ref $node;
    return ${$node} if $type eq 'Int';
    return float_text(${$node}) if $type eq 'Float';
    return ${$node} ? 'true' : 'false' if $type eq 'Bool';
    my $pad = '  ' x ($level + 1);
    my $end = '  ' x $level;
    if ($type eq 'Object') {
        return '{}' unless @{ $node->{keys} };
        return "{\n" . join(",\n", map { $pad . json_string($_) . ': ' . json_node($node->{map}{$_}, $level + 1) } @{ $node->{keys} }) . "\n$end}";
    }
    if ($type eq 'ARRAY') {
        return '[]' unless @{$node};
        return "[\n" . join(",\n", map { $pad . json_node($_, $level + 1) } @{$node}) . "\n$end]";
    }
    return json_string($node);
}

# A strict reader with the grammar of Python's json.loads: duplicate keys keep
# the first position and the last value, NaN and Infinity are numbers, control
# characters in strings are errors, and text after the value is an error. It
# consumes the text through the match position only; assigning pos() on a long
# character string converts the offset from its start each time.
sub parse_json {
    my ($text, $what) = @_;
    pos($text) = 0;
    my $fail  = sub { die sprintf("Invalid JSON in %s: %s at offset %d\n", $what, $_[0], pos($text) // 0) };
    my $space = sub { $text =~ /\G[ \t\n\r]*/gc };
    my ($value, $string);
    $string = sub {
        my $out = '';
        while (1) {
            if ($text =~ /\G([^"\\\x00-\x1f]+)/gc) { $out .= $1; next }
            return $out if $text =~ /\G"/gc;
            if ($text =~ /\G\\u([0-9a-fA-F]{4})/gc) {
                my $code = hex $1;
                if ($code >= 0xD800 && $code <= 0xDBFF && $text =~ /\G\\u([dD][c-fC-F][0-9a-fA-F]{2})/gc) {
                    $code = 0x10000 + (($code - 0xD800) << 10) + (hex($1) - 0xDC00);
                }
                $out .= chr $code;
                next;
            }
            if ($text =~ /\G\\(["\\\/bfnrt])/gc) {
                my %map = (b => "\b", f => "\f", n => "\n", r => "\r", t => "\t");
                $out .= exists $map{$1} ? $map{$1} : $1;
                next;
            }
            $fail->('unterminated or invalid string');
        }
    };
    $value = sub {
        $space->();
        if ($text =~ /\G\{/gc) {
            my $object = new_object();
            $space->();
            return $object if $text =~ /\G\}/gc;
            while (1) {
                $space->();
                $text =~ /\G"/gc or $fail->('expected a property name');
                my $key = $string->();
                $space->();
                $text =~ /\G:/gc or $fail->('expected ":"');
                object_set($object, $key, $value->());
                $space->();
                next if $text =~ /\G,/gc;
                return $object if $text =~ /\G\}/gc;
                $fail->('expected "," or "}"');
            }
        }
        if ($text =~ /\G\[/gc) {
            my @items;
            $space->();
            return \@items if $text =~ /\G\]/gc;
            while (1) {
                push @items, $value->();
                $space->();
                next if $text =~ /\G,/gc;
                return \@items if $text =~ /\G\]/gc;
                $fail->('expected "," or "]"');
            }
        }
        return $string->() if $text =~ /\G"/gc;
        if ($text =~ /\G(-?(?:0|[1-9]\d*))(\.\d+)?([eE][+-]?\d+)?/gc) {
            my ($whole, $fraction, $exponent) = ($1, $2, $3);
            return bless \(my $f = $whole . (defined $fraction ? $fraction : '') . (defined $exponent ? $exponent : '')), 'Float'
                if defined $fraction || defined $exponent;
            $whole = '0' if $whole eq '-0';
            return int_value($whole);
        }
        if ($text =~ /\G(true|false|null|NaN|-?Infinity)/gc) {
            my $word = $1;
            return bool_value(1) if $word eq 'true';
            return bool_value(0) if $word eq 'false';
            return undef if $word eq 'null';
            return bless \(my $f = $word eq 'NaN' ? 'nan' : $word eq 'Infinity' ? 'inf' : '-inf'), 'Float';
        }
        $fail->('unexpected token');
    };
    my $result = $value->();
    $space->();
    (pos($text) // 0) == length $text or $fail->('extra data');
    return $result;
}

# ---- files and text -------------------------------------------------------

sub read_text {
    my ($path) = @_;
    open(my $fh, '<:raw', $path) or die "$path: $!\n";
    my $bytes = do { local $/; <$fh> };
    close($fh) or die "$path: $!\n";
    $bytes = '' unless defined $bytes;
    my $text = eval { Encode::decode('UTF-8', $bytes, Encode::FB_CROAK) };
    defined $text or die "$path: not valid UTF-8\n";
    return $text;
}

# Lines as Python's str.splitlines() splits them, without the line ends.
sub splitlines {
    my ($text) = @_;
    my @lines;
    my $rest = $text;
    while (length $rest) {
        $rest =~ s/\A([^\r\n\x0b\x0c\x1c-\x1e\x85\x{2028}\x{2029}]*)(\r\n|[\r\n\x0b\x0c\x1c-\x1e\x85\x{2028}\x{2029}])?// or last;
        push @lines, $1;
        last unless defined $2;
    }
    return @lines;
}

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

sub result_lines {
    my ($text, $prefix, $pattern, $label) = @_;
    my @rows;
    for my $line (splitlines($text)) {
        next unless $line =~ /\A(?:$prefix)/;
        my @groups = $line =~ /\A(?:$pattern)\z/;
        require_that(scalar(@groups) > 0, "Malformed $label: $line");
        push @rows, \@groups;
    }
    return @rows;
}

# ---- manifest comparison --------------------------------------------------

sub entry_get {
    my ($entry, $key) = @_;
    return $entry->{map}{$key};
}

sub same_value {
    my ($a, $b) = @_;
    return json_node($a, 0) eq json_node($b, 0);
}

sub load_manifest {
    my ($path) = @_;
    my $entries = parse_json(read_text($path), $path);
    require_that(ref $entries eq 'ARRAY', "Manifest must be an array: $path");
    my %result;
    for my $entry (@{$entries}) {
        require_that(ref $entry eq 'Object', 'Manifest entry must be an object');
        my $name = entry_get($entry, 'path');
        require_that(defined $name && !ref $name && length $name && $name ne '.', 'Invalid manifest path');
        my @parts = grep { length $_ && $_ ne '.' } split m{/}, $name, -1;
        require_that($name !~ m{\A/} && !grep({ $_ eq '..' } @parts) && join('/', @parts) eq $name, "Noncanonical manifest path: $name");
        require_that(!exists $result{$name}, "Duplicate manifest path: $name");
        my $kind = entry_get($entry, 'type');
        my %fields = (path => 1, mode => 1, type => 1);
        my $is_kind = defined $kind && !ref $kind;
        if ($is_kind && $kind eq 'file') {
            $fields{size} = $fields{sha256} = 1;
            my $size = entry_get($entry, 'size');
            require_that(ref $size eq 'Int' && ${$size} !~ /\A-/, "Invalid file size: $name");
            my $hash = entry_get($entry, 'sha256');
            require_that(defined $hash && !ref $hash && ($hash =~ /\A[0-9a-f]{64}\z/ ? 1 : 0), "Invalid SHA-256: $name");
        }
        elsif ($is_kind && $kind eq 'symlink') {
            $fields{target} = 1;
            my $target = entry_get($entry, 'target');
            require_that(defined $target && !ref $target && length $target, "Invalid symlink target: $name");
        }
        else {
            require_that($is_kind && $kind eq 'directory', "Unsupported entry type: $name");
        }
        my @keys = sort @{ $entry->{keys} };
        require_that(join("\0", @keys) eq join("\0", sort keys %fields), "Unexpected manifest fields: $name");
        my $mode = entry_get($entry, 'mode');
        require_that(defined $mode && !ref $mode && ($mode =~ /\A0o[0-7]{1,4}\z/ ? 1 : 0), "Invalid file mode: $name");
        $result{$name} = $entry;
    }
    return \%result;
}

sub differences {
    my ($args) = @_;
    my ($before, $after) = (load_manifest($args->{before}), load_manifest($args->{after}));
    my @changed;
    for my $name (sort grep { exists $after->{$_} } keys %{$before}) {
        my %union = map { $_ => 1 } @{ $before->{$name}{keys} }, @{ $after->{$name}{keys} };
        my @fields = sort grep { !same_value(entry_get($before->{$name}, $_), entry_get($after->{$name}, $_)) } keys %union;
        push @changed, dict(path => $name, fields => \@fields, before => $before->{$name}, after => $after->{$name}) if @fields;
    }
    my @added   = sort grep { !exists $before->{$_} } keys %{$after};
    my @removed = sort grep { !exists $after->{$_} } keys %{$before};
    my $report  = dict(added => \@added, removed => \@removed, changed => \@changed);
    return ($report, (@added || @removed || @changed) ? EXIT_FAILURE : EXIT_OK);
}

# ---- debug sections ---------------------------------------------------------

sub run_readelf {
    my ($path) = @_;
    my $out = File::Temp->new;
    my $err = File::Temp->new;
    my $pid = fork();
    defined $pid or die "fork: $!\n";
    if (!$pid) {
        open(STDOUT, '>&', $out) or POSIX::_exit(126);
        open(STDERR, '>&', $err) or POSIX::_exit(126);
        $ENV{LC_ALL} = 'C';
        exec { 'readelf' } 'readelf', '-SW', $path or POSIX::_exit(127);
    }
    waitpid($pid, 0);
    my $status = $?;
    seek($out, 0, 0);
    seek($err, 0, 0);
    my ($stdout, $stderr) = map { my $b = do { local $/; readline($_) }; defined $b ? $b : '' } ($out, $err);
    return ($status, $stdout, $stderr);
}

sub scan_tree {
    my ($root, $relative, $report, $found) = @_;
    my $directory = length $relative ? "$root/$relative" : $root;
    opendir(my $handle, $directory) or die "$directory: $!\n";
    my @names = sort grep { $_ ne '.' && $_ ne '..' } readdir($handle);
    closedir($handle);
    for my $name (@names) {
        my $child = length $relative ? "$relative/$name" : $name;
        my $path  = "$root/$child";
        my @stat  = lstat($path) or die "$path: $!\n";
        my $mode  = $stat[2];
        if (S_ISLNK($mode)) { next }
        if (S_ISDIR($mode)) { scan_tree($root, $child, $report, $found); next }
        require_that(S_ISREG($mode), "Unsupported file type: $path");
        open(my $stream, '<:raw', $path) or die "$path: $!\n";
        my $magic = '';
        my $count = read($stream, $magic, 8);
        defined $count or die "$path: $!\n";
        close($stream);
        require_that($magic ne "!<thin>\n", "Thin archive needs external members: $path");
        if ($magic =~ /\A\x7fELF/) { $report->{elf}++ }
        elsif ($magic eq "!<arch>\n") { $report->{archives}++ }
        else { next }
        my ($status, $stdout, $stderr) = run_readelf($path);
        (my $trimmed = $stderr) =~ s/\A\s+|\s+\z//g;
        require_that($status == 0 && $trimmed eq '', "readelf failed for $path: $trimmed");
        my %sections = map { $_ => 1 } $stdout =~ /^\s*\[\s*\d+\]\s+(\.(?:zdebug|debug)\S*)\s/mg;
        push @{$found}, [ fsdecode($child), [ sort keys %sections ] ] if %sections;
    }
    return;
}

sub debug_sections {
    my ($args) = @_;
    my $root = Cwd::abs_path($args->{tree});
    defined $root or die "$args->{tree}: $!\n";
    require_that(-d $root, 'Expected a tree directory');
    my %report = (elf => 0, archives => 0);
    my @found;
    scan_tree($root, '', \%report, \@found);
    require_that($report{elf} > 0, 'No ELF files found');
    my @sorted = sort { $a->[0] cmp $b->[0] } @found;
    return (dict(
        elf_files => int_value($report{elf}), archives => int_value($report{archives}),
        debug_sections => [ map { dict(path => $_->[0], sections => $_->[1]) } @sorted ],
    ), EXIT_OK);
}

# ---- test summaries -----------------------------------------------------------

sub runner_names {
    my ($path, $array) = @_;
    my $text = read_text($path);
    my @blocks = $text =~ /^readonly (?:-a )?\Q$array\E=\(\n(.*?)^\)/msg;
    require_that(@blocks == 1, "Unsupported runner array: $path");
    my @names = split ' ', $blocks[0];
    my %seen;
    require_that(@names && !grep({ $seen{$_}++ } @names) && !grep({ !/\A[a-z][a-z0-9_.]*\z/ } @names), "Invalid runner names: $path");
    return @names;
}

sub loader_results {
    my ($source, $run_log, $logs) = @_;
    my @names = runner_names("$source/examples/iocsh/tests/run_all.bash", 'ORDER');
    my $text  = read_text($run_log);
    my @rows  = result_lines($text, qr/[ \t]*[\w.-]+[ \t]+exit\b/, qr/(\w+) exit (\d+)(?:, SUMMARY ok=(\d+) fail=(\d+))?/, 'loader result');
    require_that(join("\0", map { $_->[0] } @rows) eq join("\0", @names), 'Incomplete, duplicate, or unordered loader results');
    my @done = result_lines($text, qr/[ \t]*run done\b/, qr/run done (.+)/, 'loader completion');
    (my $trimmed = $text) =~ s/\s+\z//;
    my @lines = splitlines($trimmed);
    require_that(@done == 1 && @lines && ($lines[-1] =~ /\Arun done / ? 1 : 0), 'Missing loader completion marker');
    my (@result, $checks, $failed);
    $checks = 0;
    $failed = 0;
    for my $row (@rows) {
        my ($name, $status, $ok, $fail) = @{$row};
        my @summaries = result_lines(read_text("$logs/$name.log"), qr/[ \t]*SUMMARY\b/, $SUMMARY, 'loader summary');
        if ($OBSERVATION_SCRIPTS{$name}) {
            require_that(!@summaries && !defined $ok, "Unexpected observation summary: $name");
        }
        else {
            require_that(@summaries == 1 && defined $ok && $summaries[0][0] eq $ok && $summaries[0][1] eq $fail && $ok + $fail > 0,
                         "Missing or inconsistent summary: $name");
        }
        push @result, dict(script => $name, exit => int_value($status), ok => defined $ok ? int_value($ok) : undef,
                           fail => defined $fail ? int_value($fail) : undef);
        $checks += $ok if defined $ok;
        $failed = 1 if $status != 0 || (defined $fail && $fail != 0);
    }
    my %name_set = map { $_ => 1 } @names;
    return dict(scripts => \@result, checks => int_value($checks), failed => bool_value($failed),
                runtime_observations_require_review => [ sort grep { $name_set{$_} } keys %OBSERVATION_SCRIPTS ]);
}

sub count_matches {
    my ($text, $pattern) = @_;
    my $count = () = $text =~ /$pattern/g;
    return $count;
}

sub common_results {
    my ($source, $log) = @_;
    my @names = runner_names("$source/examples/commonIocsh/tests/run_all.sh", 'SCRIPTS');
    my $text  = read_text($log);
    my @starts;
    while ($text =~ /^==== ([\w.]+) ====$/mg) { push @starts, [ $1, $-[0], $+[0] ] }
    require_that(join("\0", map { $_->[0] } @starts) eq join("\0", @names), 'Incomplete or duplicate commonIocsh scripts');
    my @all = result_lines($text, qr/[ \t]*RESULT\b/, qr/RESULT ([\w.]+): (PASS|FAIL)/, 'commonIocsh result');
    require_that(join("\0", map { $_->[0] } @all) eq join("\0", @names), 'Incomplete commonIocsh results');
    my @overall = result_lines($text, qr/[ \t]*OVERALL\b/, qr/OVERALL: (PASS|FAIL)/, 'commonIocsh completion');
    require_that(@overall == 1 && rindex($text, 'OVERALL:') > $starts[-1][1], 'Missing commonIocsh completion marker');
    my (@rows, $checks, $failed);
    $checks = 0;
    $failed = !(@overall == 1 && $overall[0][0] eq 'PASS');
    for my $index (0 .. $#starts) {
        my $end   = $index + 1 < @starts ? $starts[ $index + 1 ][1] : length $text;
        my $block = substr($text, $starts[$index][2], $end - $starts[$index][2]);
        my @counts = result_lines($block, qr/[ \t]*PASS=/, qr/PASS=(\d+) FAIL=(\d+)/, 'commonIocsh counts');
        my @result;
        while ($block =~ /^RESULT ([\w.]+): (PASS|FAIL)$/mg) { push @result, [ $1, $2 ] }
        require_that(@counts == 1 && @result == 1 && $result[0][0] eq $all[$index][0] && $result[0][1] eq $all[$index][1],
                     "Missing commonIocsh summary: $starts[$index][0]");
        my ($ok, $fail) = @{ $counts[0] };
        require_that($ok + $fail > 0 && count_matches($block, qr/^PASS: /m) == $ok && count_matches($block, qr/^FAIL: /m) == $fail,
                     "Inconsistent commonIocsh counts: $starts[$index][0]");
        push @rows, dict(script => $starts[$index][0], ok => int_value($ok), fail => int_value($fail), result => $result[0][1]);
        $checks += $ok;
        $failed = 1 if $fail != 0 || $result[0][1] ne 'PASS';
    }
    return dict(scripts => \@rows, checks => int_value($checks), failed => bool_value($failed));
}

sub test_results {
    my ($args) = @_;
    my $loader    = loader_results(defined $args->{loader_source} && length $args->{loader_source} ? $args->{loader_source} : $args->{source},
                                   $args->{loader_run}, $args->{loader_logs});
    my $installed = common_results($args->{source}, $args->{common_installed});
    my $isolated  = common_results($args->{source}, $args->{common_isolated});
    my $summary   = parse_json(read_text($args->{caputlog}), $args->{caputlog});
    require_that(ref $summary eq 'Object' && ref(entry_get($summary, 'cases')) eq 'ARRAY', 'Invalid caPutLog summary');
    my $cases = entry_get($summary, 'cases');
    require_that(!grep({ !(ref $_ eq 'Object' && defined entry_get($_, 'case') && !ref entry_get($_, 'case')) } @{$cases}), 'Invalid caPutLog case');
    my %names = map { entry_get($_, 'case') => 1 } @{$cases};
    require_that(@{$cases} == keys(%CAPUTLOG_CASES) && !grep({ !$names{$_} } keys %CAPUTLOG_CASES) && keys(%names) == keys(%CAPUTLOG_CASES),
                 'Incomplete or duplicate caPutLog cases');
    require_that(!grep({ my $r = entry_get($_, 'result'); !(defined $r && !ref $r && ($r eq 'Pass' || $r eq 'Fail')) } @{$cases}), 'Invalid caPutLog result');
    my $failed = ${ $loader->{map}{failed} } || ${ $installed->{map}{failed} } || ${ $isolated->{map}{failed} }
        || grep({ entry_get($_, 'result') ne 'Pass' } @{$cases});
    return (dict(
        loader => $loader, common_installed => $installed, common_isolated => $isolated, caputlog => $cases,
        reported_failure => bool_value($failed),
        scope => 'Summary aggregation only; verify process exits, isolation, runtime observations and OS baseline separately.',
    ), $failed ? EXIT_FAILURE : EXIT_OK);
}

# ---- command line -------------------------------------------------------------

sub usage_error {
    my ($message) = @_;
    print STDERR "distribution-report.pl: $message\n" if defined $message;
    pod2usage(-exitval => EXIT_INVALID, -verbose => 0, -output => \*STDERR);
}

sub main {
    my (@argv) = @_;
    my ($command, @rest) = @argv;
    if (!defined $command || $command eq '-h' || $command eq '--help') {
        pod2usage(-exitval => (defined $command ? EXIT_OK : EXIT_INVALID), -verbose => 1, -output => (defined $command ? \*STDOUT : \*STDERR));
    }
    my ($run, %args);
    if ($command eq 'diff') {
        GetOptionsFromArray(\@rest, 'help|h' => sub { pod2usage(-exitval => EXIT_OK, -verbose => 1, -output => \*STDOUT) }) or usage_error();
        @rest == 2 or usage_error('diff expects a before and an after manifest');
        @args{qw(before after)} = @rest;
        $run = \&differences;
    }
    elsif ($command eq 'debug') {
        GetOptionsFromArray(\@rest, 'help|h' => sub { pod2usage(-exitval => EXIT_OK, -verbose => 1, -output => \*STDOUT) }) or usage_error();
        @rest == 1 or usage_error('debug expects one tree');
        $args{tree} = $rest[0];
        $run = \&debug_sections;
    }
    elsif ($command eq 'results') {
        GetOptionsFromArray(\@rest,
            'source=s' => \$args{source}, 'loader-run=s' => \$args{loader_run}, 'loader-logs=s' => \$args{loader_logs},
            'common-installed=s' => \$args{common_installed}, 'common-isolated=s' => \$args{common_isolated},
            'caputlog=s' => \$args{caputlog}, 'loader-source=s' => \$args{loader_source},
            'help|h' => sub { pod2usage(-exitval => EXIT_OK, -verbose => 1, -output => \*STDOUT) },
        ) or usage_error();
        !@rest or usage_error('unexpected argument');
        for my $required (qw(source loader_run loader_logs common_installed common_isolated caputlog)) {
            defined $args{$required} or usage_error('missing required option for results');
        }
        $run = \&test_results;
    }
    else {
        usage_error("unknown command $command");
    }
    my ($report, $status);
    if (!eval { ($report, $status) = $run->(\%args); 1 }) {
        my $error = $@;
        $error =~ s/\n\z//;
        print STDERR "distribution-report.pl: $error\n";
        return EXIT_INVALID;
    }
    print STDOUT json_node($report, 0), "\n" or do { print STDERR "distribution-report.pl: stdout: $!\n"; return EXIT_INVALID };
    close(STDOUT) or do { print STDERR "distribution-report.pl: stdout: $!\n"; return EXIT_INVALID };
    return $status;
}

my $status;
eval {
    $status = main(@ARGV);
    defined $status or die "internal error: main returned no exit status\n";
    1;
} or do {
    my $error = $@;
    print STDERR "distribution-report.pl: $error";
    $status = EXIT_INVALID;
};
exit $status;

__END__

=head1 NAME

distribution-report.pl - report manifest differences, debug sections, and test summaries

=head1 SYNOPSIS

distribution-report.pl diff <before_manifest> <after_manifest>

distribution-report.pl debug <installed_tree>

distribution-report.pl results --source <dir> --loader-run <file> --loader-logs <dir> --common-installed <file> --common-isolated <file> --caputlog <file> [--loader-source <dir>]

=head1 DESCRIPTION

Reads existing evidence and writes one JSON report to stdout. It does not run
the test suites and does not approve a distribution.

B<diff> classifies the complete difference of two manifests written by
tree-manifest.pl: added and removed paths, and changed fields with their before
and after entries. B<debug> runs C<readelf -SW> on regular ELF files and static
archives below a tree, without following symlinks, and lists the C<.debug*> and
C<.zdebug*> sections by relative path. B<results> aggregates the saved loader,
commonIocsh and caPutLog summaries and requires every script of the executed
runners, in order and once each.

=head1 OPTIONS

=over 4

=item B<--help>, B<-h>

Print this help and exit with status 0.

=back

=head1 EXIT STATUS

0 for identical manifests, a complete scan, or complete summaries without a
reported failure. 1 for manifest differences or a reported test failure.
2 for invalid, incomplete, unreadable, or inconsistent input, and for a usage error.

=cut
