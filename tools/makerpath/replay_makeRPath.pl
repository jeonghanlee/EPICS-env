#!/usr/bin/env perl
# Replays the makeRPath calls recorded from a real build (working directory, argument count and
# arguments, NUL separated) through makeRPath.py and makeRPath.pl, and compares exit status and
# stdout bytes. Usage: replay_makeRPath.pl <calls.nul>
# Environment: MAKERPATH_PY, MAKERPATH_PL (both required), MAKERPATH_PYTHON, MAKERPATH_PERLS as in compare_makeRPath.pl.
# A recording is made by running a Base or module build with MAKERPATH set to a script that appends
# the working directory, the argument count, and the arguments (each followed by NUL) to a file and then
# runs makeRPath.py.
use strict;
use warnings;
use 5.10.1;
use Cwd ();
use File::Temp ();
use POSIX ();

use File::Basename ();
use File::Path ();

# Temporary files are created below work/scratch of the repository (EPICS_ENV_SCRATCH names another
# directory), and each run removes them when it ends. Child commands inherit TMPDIR.
my $SCRATCH_BASE = $ENV{EPICS_ENV_SCRATCH} // File::Basename::dirname(File::Basename::dirname(File::Basename::dirname(Cwd::abs_path($0)))) . '/work/scratch';
File::Path::make_path($SCRATCH_BASE);
-d $SCRATCH_BASE && -w _ or die "$SCRATCH_BASE: not a writable directory\n";
$ENV{TMPDIR} = $SCRATCH_BASE;

my $PY     = $ENV{MAKERPATH_PY} or die "set MAKERPATH_PY\n";
my $PL     = $ENV{MAKERPATH_PL} or die "set MAKERPATH_PL\n";
$_ = Cwd::abs_path($_) // $_ for ($PY, $PL);
my $PYTHON = $ENV{MAKERPATH_PYTHON} // 'python3';
my @PERLS  = split ' ', ($ENV{MAKERPATH_PERLS} // $^X);
@ARGV == 1 or die "usage: replay_makeRPath.pl <calls.nul>\n";

open(my $fh, '<:raw', $ARGV[0]) or die "$ARGV[0]: $!\n";
my $data = do { local $/; <$fh> };
close($fh);
my @fields = split /\0/, $data, -1;
pop @fields if @fields && $fields[-1] eq '';
my @calls;
while (@fields) {
    my $cwd = shift @fields;
    my $count = shift @fields;
    defined $count && $count =~ /\A\d+\z/ or die "malformed record near cwd $cwd\n";
    my @args = splice(@fields, 0, $count);
    @args == $count or die "short record for cwd $cwd\n";
    push @calls, { cwd => $cwd, args => \@args };
}

sub run_command {
    my ($command, $cwd) = @_;
    my $out = File::Temp->new;
    my $err = File::Temp->new;
    my $pid = fork();
    defined $pid or die "fork: $!\n";
    if (!$pid) {
        chdir($cwd) or POSIX::_exit(125);
        open(STDOUT, '>&', $out) or POSIX::_exit(126);
        open(STDERR, '>&', $err) or POSIX::_exit(126);
        exec { $command->[0] } @{$command} or POSIX::_exit(127);
    }
    waitpid($pid, 0);
    my $status = ($? & 127) ? 'signal ' . ($? & 127) : $? >> 8;
    seek($out, 0, 0); seek($err, 0, 0);
    local $/;
    my $stdout = readline($out); my $stderr = readline($err);
    return ($status, defined $stdout ? $stdout : '', defined $stderr ? $stderr : '');
}

my %seen;
my ($total, $distinct, $bad, $with_link, $outside, $warn, $symlink_warnings) = (0, 0, 0, 0, 0, 0, 0);
my @runners = map { my $p = $_; ([ $p, [ $p, $PL ] ], [ "$p -CSD", [ $p, '-CSD', $PL ] ]) } @PERLS;
for my $call (@calls) {
    $total++;
    my $key = join("\0", $call->{cwd}, @{ $call->{args} });
    next if $seen{$key}++;
    $distinct++;
    my ($ps, $po, $pe) = run_command([ $PYTHON, $PY, @{ $call->{args} } ], $call->{cwd});
    $with_link++ if $po =~ /-rpath-link/;
    $outside++ if $po =~ /-rpath,\//;
    $warn++ if $pe =~ /Final location/;
    for my $runner (@runners) {
        my ($label, $command) = @{$runner};
        my ($s, $o, $e) = run_command([ @{$command}, @{ $call->{args} } ], $call->{cwd});
        # The wording of the messages differs; what a build log shows is compared: whether the warning about the
        # final directory appears, and whether a warning about a symbolic link or an error appears.
        my $same_messages = (($pe =~ /Final location/ ? 1 : 0) == ($e =~ /warning: final location/ ? 1 : 0));
        $symlink_warnings++ if $e =~ /warning: \$ORIGIN/;
        next if $s eq $ps && $o eq $po && $same_messages && $e !~ /error:/;
        $bad++;
        print "DIFFERENT under $label: cwd $call->{cwd}\n  args: @{ $call->{args} }\n  python: [$ps] $po$pe\n  perl  : [$s] $o$e\n" if $bad <= 5;
    }
}
printf "calls=%d distinct=%d with-rpath-link=%d with-outside-entry=%d final-warning=%d symbolic-link-warnings=%d interpreters=%d mismatches=%d\n",
    $total, $distinct, $with_link, $outside, $warn, $symlink_warnings, scalar(@PERLS), $bad;
print $bad ? "REPLAY DIFFERS\n" : "REPLAY IDENTICAL\n";
exit($bad ? 1 : 0);
