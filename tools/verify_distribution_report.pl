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
# Exercises tools/distribution-report.pl as a subprocess against retained
# distribution evidence and a real candidate tree: the recorded summaries, a
# separate loader source, rejected log omissions and inconsistent counts, a
# nonzero test exit, malformed result records, manifest changes, the recorded
# debug sections, and a truncated copy of a real ELF file.
# DISTRIBUTION_REPORT_TOOL names another copy of the tool to test.
#
# Usage: verify_distribution_report.pl <release_checkout> <run_evidence> <candidate_tree>

use strict;
use warnings;

use Cwd ();
use File::Basename ();
use File::Copy ();
use File::Find ();
use File::Path ();
use File::Temp ();
use JSON::PP ();
use POSIX ();
use Test::More;

@ARGV == 3 or do { print STDERR "Usage: verify_distribution_report.pl <release_checkout> <run_evidence> <candidate_tree>\n"; exit 2 };
my ($SOURCE, $EVIDENCE, $TREE) = map { Cwd::abs_path($_) // die "$_: $!\n" } @ARGV;
my $TOOL = $ENV{DISTRIBUTION_REPORT_TOOL} // File::Basename::dirname(Cwd::abs_path($0)) . '/distribution-report.pl';
my $JSON = JSON::PP->new->canonical;

sub slurp {
    my ($path) = @_;
    open(my $fh, '<:raw', $path) or die "$path: $!\n";
    my $content = do { local $/; <$fh> };
    close($fh);
    return defined $content ? $content : '';
}

sub spew {
    my ($path, $content) = @_;
    open(my $fh, '>:raw', $path) or die "$path: $!\n";
    print {$fh} $content;
    close($fh) or die "$path: $!\n";
    return;
}

# Runs the tool and returns its exit status, stdout and stderr.
sub run_tool {
    my (@args) = @_;
    my $err = File::Temp->new;
    my $pid = open(my $out, '-|');
    defined $pid or die "fork: $!\n";
    if (!$pid) {
        open(STDERR, '>&', $err) or POSIX::_exit(126);
        exec { $^X } $^X, $TOOL, map({ "$_" } @args) or POSIX::_exit(127);
    }
    my $stdout = do { local $/; <$out> };
    close($out);
    my $status = ($? & 127) ? 'signal ' . ($? & 127) : $? >> 8;
    seek($err, 0, 0);
    my $stderr = do { local $/; <$err> };
    return ($status, defined $stdout ? $stdout : '', defined $stderr ? $stderr : '');
}

# Calls the tool, asserts its exit status, and returns the decoded report, or
# undef for status 2 after asserting that nothing was written to stdout.
sub call {
    my ($name, $status, @args) = @_;
    my ($got, $stdout, $stderr) = run_tool(@args);
    is($got, $status, "$name: exit status") or diag($stderr);
    if ($status == 2) {
        is($stdout, '', "$name: no report on stdout");
        ok(length $stderr, "$name: a diagnostic on stderr");
        return;
    }
    return unless length $stdout;
    return $JSON->decode($stdout);
}

sub result_arguments {
    my $logs = "$EVIDENCE/guest-logs";
    return ('results', '--source', $SOURCE,
        '--loader-run', "$logs/loader-run.log", '--loader-logs', "$logs/loader",
        '--common-installed', "$logs/common-installed.log", '--common-isolated', "$logs/common-isolated.log",
        '--caputlog', "$logs/caputlog/summary.json");
}

sub option_index {
    my ($arguments, $option) = @_;
    for my $i (0 .. $#{$arguments}) { return $i + 1 if $arguments->[$i] eq $option }
    die "no option $option\n";
}

my $scratch = File::Temp->newdir('distribution-report-XXXXXX', TMPDIR => 1, CLEANUP => 1);

# Recorded summaries.
{
    my $report = call('recorded summaries', 0, result_arguments());
    ok($report && !$report->{reported_failure}, 'recorded summaries: no failure reported');
    ok($report && $report->{loader}{checks} > 0, 'recorded summaries: the loader checks are counted');
}

# A separate loader source, and a different runner order that must be rejected.
{
    my $relative = 'examples/iocsh/tests/run_all.bash';
    my $runner   = "$scratch/$relative";
    File::Path::make_path(File::Basename::dirname($runner));
    File::Copy::copy("$SOURCE/$relative", $runner) or die "$runner: $!\n";
    my @arguments = (result_arguments(), '--loader-source', "$scratch");
    is_deeply(call('separate loader source', 0, @arguments), call('same source', 0, result_arguments()),
              'separate loader source: the same report');
    my $text = slurp($runner);
    $text =~ /^readonly ORDER=\(\n(.*?)^\)/ms or fail('the runner has an ORDER array');
    my ($start, $end) = ($-[1], $+[1]);
    my @lines = substr($text, $start, $end - $start) =~ /([^\n]*\n)/g;
    cmp_ok(scalar @lines, '>', 1, 'the runner lists more than one script');
    @lines[0, 1] = @lines[1, 0];
    spew($runner, substr($text, 0, $start) . join('', @lines) . substr($text, $end));
    call('swapped runner order', 2, @arguments);
}

# Incomplete or inconsistent loader logs.
{
    my @arguments = result_arguments();
    my $loader    = slurp($arguments[4]);
    my ($first)   = $loader =~ /\A([^\n]*\n)/;
    my $v1        = $loader;
    $v1 =~ s/\Q$first\E//;
    my @variants  = ($v1, $first . $loader);
    push @variants, substr($loader, 0, index($loader, 'run done '));
    (my $v4 = $loader) =~ s/SUMMARY ok=(\d+)/'SUMMARY ok=' . ($1 + 1)/e;
    isnt($v4, $loader, 'the evidence has a counted loader summary');
    push @variants, $v4;
    my $changed = "$scratch/loader.log";
    $arguments[4] = $changed;
    my $n = 0;
    for my $text (@variants) {
        $n++;
        spew($changed, $text);
        call("inconsistent loader log $n", 2, @arguments);
    }
}

# A reported nonzero exit.
{
    my @arguments = result_arguments();
    (my $text = slurp($arguments[4])) =~ s/ exit 0/ exit 1/;
    my $changed = "$scratch/loader.log";
    spew($changed, $text);
    $arguments[4] = $changed;
    my $report = call('reported exit failure', 1, @arguments);
    ok($report && $report->{reported_failure}, 'reported exit failure: the failure is reported');
}

# Malformed failure records.
{
    my @mutations = (
        [ '--loader-run', 'run done ', "verify_directives exit 1, SUMMARY ok=15 fail=\nrun done " ],
        [ '--common-installed', 'OVERALL: PASS', "RESULT verify_serial.sh: FAIL (exit 1)\nOVERALL: PASS" ],
        [ '--common-isolated', 'OVERALL: PASS', "OVERALL: FAIL (exit 1)\nOVERALL: PASS" ],
    );
    for my $mutation (@mutations) {
        my ($option, $before, $after) = @{$mutation};
        my @arguments = result_arguments();
        my $index     = option_index(\@arguments, $option);
        my $original  = slurp($arguments[$index]);
        ok(index($original, $before) >= 0, "malformed $option: the evidence holds the text to change");
        my $position = index($original, $before);
        substr($original, $position, length $before) = $after;
        my $changed = "$scratch/malformed.log";
        spew($changed, $original);
        $arguments[$index] = $changed;
        call("malformed $option", 2, @arguments);
    }
}

# Missing results.
{
    for my $option ('--common-installed', '--common-isolated', '--caputlog') {
        my @arguments = result_arguments();
        my $index     = option_index(\@arguments, $option);
        my $changed   = "$scratch/incomplete";
        my $text      = slurp($arguments[$index]);
        if ($option eq '--caputlog') {
            my $data = $JSON->decode($text);
            pop @{ $data->{cases} };
            $text = $JSON->encode($data);
        }
        else {
            $text =~ s/RESULT verify_linstat\.sh: PASS//;
        }
        spew($changed, $text);
        $arguments[$index] = $changed;
        call("missing results $option", 2, @arguments);
    }
}

# Manifest comparison.
{
    my $before = "$EVIDENCE/installed-manifest.json";
    is_deeply(call('manifest self comparison', 0, 'diff', $before, $before), { added => [], removed => [], changed => [] },
              'manifest self comparison: nothing differs');
    my $entries = $JSON->decode(slurp($before));
    my $removed = pop @{$entries};
    my $original = $entries->[0]{mode};
    $entries->[0]{mode} = $original ne '0o700' ? '0o700' : '0o755';
    push @{$entries}, { path => 'report-test-directory', type => 'directory', mode => '0o755' };
    my $after = "$scratch/after.json";
    spew($after, $JSON->encode($entries));
    my $result = call('manifest changes', 1, 'diff', $before, $after);
    is_deeply($result->{added}, ['report-test-directory'], 'manifest changes: the added path');
    is_deeply($result->{removed}, [ $removed->{path} ], 'manifest changes: the removed path');
    is_deeply($result->{changed}[0]{fields}, ['mode'], 'manifest changes: the changed field');
    push @{$entries}, $entries->[0];
    spew($after, $JSON->encode($entries));
    call('manifest duplicate path', 2, 'diff', $before, $after);
}

# A manifest mode outside the accepted form (0o followed by one to four octal
# digits) is rejected, and the two extremes of the form are accepted.
{
    my $before   = "$EVIDENCE/installed-manifest.json";
    my $entries  = $JSON->decode(slurp($before));
    my $original = $entries->[0]{mode};
    my $after    = "$scratch/mode.json";
    for my $bad ('0o', '0o12345', '0o8', '0o-1', '644', '0O644', '') {
        $entries->[0]{mode} = $bad;
        spew($after, $JSON->encode($entries));
        call("invalid mode '$bad'", 2, 'diff', $before, $after);
    }
    for my $good ('0o0', '0o7777') {
        $entries->[0]{mode} = $good;
        spew($after, $JSON->encode($entries));
        my $report = call("valid mode '$good'", $good eq $original ? 0 : 1, 'diff', $before, $after);
        is_deeply($report->{changed}[0]{fields}, ['mode'], "valid mode '$good': only the mode differs") if $good ne $original;
    }
}

# The real debug scan and a truncated ELF copy.
{
    my $report   = call('real debug scan', 0, 'debug', $TREE);
    my $previous = $JSON->decode(slurp("$EVIDENCE/debug-sections.json"));
    for my $key (qw(elf_files archives debug_sections)) {
        is_deeply($report->{$key}, $previous->{$key}, "real debug scan: $key equals the recorded value");
    }
    my $source;
    File::Find::find({ no_chdir => 1, wanted => sub {
        return if defined $source || -l $_ || !-f $_;
        open(my $fh, '<:raw', $_) or return;
        read($fh, my $magic, 4);
        close($fh);
        $source = $File::Find::name if defined $magic && $magic eq "\x7fELF";
    } }, $TREE);
    ok(defined $source, 'the candidate holds an ELF file');
    my $target = "$scratch/truncated.so";
    File::Copy::copy($source, $target) or die "$target: $!\n";
    truncate($target, 32) or die "$target: $!\n";
    my $other = File::Temp->newdir('distribution-truncated-XXXXXX', TMPDIR => 1, CLEANUP => 1);
    File::Copy::copy($target, "$other/truncated.so") or die "$other: $!\n";
    call('truncated ELF', 2, 'debug', "$other");
}

done_testing();
