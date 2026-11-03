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
# Print the cycle plan block of one module as the release record drafts it,
# from the facts of the repository: see the POD at the end of the file.

use strict;
use warnings;
use Cwd qw(abs_path);
use File::Basename qw(basename dirname);
use File::Glob qw(bsd_glob);
use Getopt::Long qw(GetOptionsFromArray);
use Pod::Usage qw(pod2usage);

# The checkout is the parent of the tools directory of this script.
my $CHECKOUT = abs_path(dirname(abs_path($0)) . '/../..');
my $RELEASE_FILE = 'configure/RELEASE';
my $RULES_SRC_FILE = 'configure/RULES_SRC';
my $DEPS_FILE = 'configure/CONFIG_MODS_DEPS';
my $RECORD_GLOB = 'docs/milestone-*.md';
my $MAIN_BRANCH = 'master';
my $TOOLS_COMMIT = 'afb7b3c';

# Reads a whole file as text; dies with the path on failure.
sub read_file {
    my ($path) = @_;
    open(my $fh, '<', $path) or die "cannot read $path: $!\n";
    local $/ = undef;
    my $text = <$fh>;
    close($fh);
    return $text;
}

# Runs a command without a shell in the checkout and returns its output lines
# without line endings; dies when the command fails.
sub command_lines {
    my (@command) = @_;
    my @lines;
    my $pid = open(my $out, '-|');
    defined $pid or die "cannot fork for $command[0]: $!\n";
    if ($pid == 0) {
        chdir($CHECKOUT) or die "cannot chdir to $CHECKOUT: $!\n";
        exec { $command[0] } @command or die "cannot run $command[0]: $!\n";
    }
    while (my $line = <$out>) {
        chomp $line;
        push @lines, $line;
    }
    close($out);
    my $signal = $? & 127;
    my $status = $? >> 8;
    die "$command[0] ended by signal $signal\n" if $signal;
    die "$command[0] exited with status $status\n" if $status;
    return @lines;
}

# Prints one make variable of the checkout.
sub make_var {
    my ($name) = @_;
    my @lines = command_lines('make', '-s', "print-$name");
    return defined $lines[0] ? $lines[0] : '';
}

# The pins of configure/RELEASE: module name and tag by key.
sub read_release {
    my ($text) = @_;
    my (%name, %tag);
    for my $line (split /\n/, $text) {
        $name{$1} = $2 if $line =~ /^SRC_NAME_([A-Z0-9_]+):=(\S+)/;
        $tag{$1} = $2 if $line =~ /^SRC_TAG_([A-Z0-9_]+):=(\S+)/;
    }
    return (\%name, \%tag);
}

# The apply targets of a module from the patch: line of RULES_SRC, in order.
sub apply_targets {
    my ($module) = @_;
    my ($patch_line) = grep { /^patch:/ } split /\n/, read_file("$CHECKOUT/$RULES_SRC_FILE");
    defined $patch_line or die "no patch: line in $RULES_SRC_FILE\n";
    return grep { /^patch\.\Q$module\E\.[A-Za-z0-9.-]*apply$/ } split ' ', $patch_line;
}

# The modules whose _DEPS line lists build.<module>, in file order.
sub dependents_of {
    my ($module) = @_;
    my @dependents;
    for my $line (split /\n/, read_file("$CHECKOUT/$DEPS_FILE")) {
        next unless $line =~ /^(\S+)_DEPS:=(.*)$/;
        my ($name, $deps) = ($1, $2);
        push @dependents, $name if grep { $_ eq "build.$module" } split ' ', $deps;
    }
    return @dependents;
}

# A module whose top Makefile passes realuninstall to an iocs directory the
# build does not enter (BUILD_IOCS not YES) cannot take make distclean.
sub unsafe_distclean {
    my ($module) = @_;
    my $makefile = "$CHECKOUT/$module-src/Makefile";
    return 0 unless -f $makefile;
    return 0 unless read_file($makefile) =~ /realuninstall/;
    for my $path ($makefile, sort { $a cmp $b } bsd_glob("$CHECKOUT/$module-src/configure/CONFIG_SITE*")) {
        next unless -f $path;
        return 0 if read_file($path) =~ /BUILD_IOCS\s*=\s*YES/;
    }
    return 1;
}

# The pin and outcome columns of the Modules table row of the module.
sub record_row {
    my ($record, $module) = @_;
    for my $line (split /\n/, read_file($record)) {
        next unless $line =~ /^\| \d+ \| \Q$module\E \| ([^|]+) \| ([^|]+) \| [^|]+ \| [^|]+ \|$/;
        my ($pin, $outcome) = ($1, $2);
        $pin =~ s/^\s+|\s+$//g;
        $outcome =~ s/^\s+|\s+$//g;
        return ($pin, $outcome);
    }
    die "no row of $module in the Modules table of $record\n";
}

# The commit of this release that set the pin, and the version its parent
# held, or an empty list when the pin did not move after the branch point or
# the commit added the module (its parent holds no version of it).
sub pin_move {
    my ($key, $tag) = @_;
    my ($base) = command_lines('git', 'merge-base', 'HEAD', $MAIN_BRANCH);
    my @commits = command_lines('git', 'log', '--format=%h', "-S$tag", "$base..HEAD", '--', $RELEASE_FILE);
    return () unless @commits;
    my $commit = $commits[-1];
    my ($old) = map { /^SRC_VER_\Q$key\E:=(\S+)/ ? ($1) : () }
        command_lines('git', 'show', "$commit^:$RELEASE_FILE");
    return () unless defined $old;
    return ($commit, $old);
}

# The suite scripts of a module cycle: the three module scripts and the
# fixture that loads the module (module-bump-procedure.md, The checks, item 3).
sub module_scripts {
    my ($module) = @_;
    my @scripts = qw(verify_install_metadata verify_dependency_graph verify_minimal_example);
    my %fixture = (
        autosave => ['verify_fixture_tc32sim'], caPutLog => ['verify_fixture_tc32sim'],
        linStat => ['verify_fixture_tc32sim'], retools => ['verify_fixture_tc32sim'],
        StreamDevice => ['verify_fixture_tc32sim', 'verify_fixture_ioc_demo'],
        opcua => ['verify_fixture_opcua'],
    );
    push @scripts, @{ $fixture{$module} } if $fixture{$module};
    return @scripts;
}

# The library stems of the module from the inventory file, by the installed
# name of the module (seq for sequencer).
sub library_stems {
    my ($inventory, $installed) = @_;
    for my $line (split /\n/, read_file($inventory)) {
        next unless $line =~ /^\Q$installed\E:(.*)$/;
        return split ' ', $1;
    }
    return ();
}

sub code_list {
    my (@items) = @_;
    return join(', ', map { "`$_`" } @items);
}

# The plan block, from the Issue line to the last Results row.
sub plan_block {
    my ($f) = @_;
    my $m = $f->{module};
    my $key = $f->{key};
    my $inst = $f->{installed};
    my @deps = @{ $f->{dependents} };
    my @stems = @{ $f->{libs} };
    # A module without an apply target leaves no Patching line, whatever
    # patch files its version has.
    my $n = @{ $f->{targets} } ? @{ $f->{files} } + @{ $f->{fixed} } : 0;
    my @lines;

    push @lines, 'Issue: opened at the plan step (sub-step 1 of step 6).', '';
    push @lines, 'Plan status: draft', 'Plan acceptance: none', 'Implementation authorization: none',
        'Review findings and rulings: none', '';
    push @lines, 'The cycle runs the sub-steps of step 6 of `docs/procedures/release-procedure.md`';
    push @lines, "on the baseline tree of the two test machines, with the tools at `$TOOLS_COMMIT` or";
    push @lines, 'later and the checks of `docs/procedures/module-bump-procedure.md`, The checks.';
    push @lines, 'The facts of this module:', '';

    if ($f->{moved}) {
        push @lines, "1. The pin is `$f->{pin}` (version $f->{ver}) already, moved from `$f->{old}` by commit "
            . "`$f->{pin_commit}` ($f->{outcome}), so no pin edit is made and the commit of the "
            . "accepted plan is the candidate; the files that `$f->{pin_commit}` rewrote are searched "
            . "for `$f->{old}` at the end of the checks, and none may remain.";
    } else {
        push @lines, "1. The pin is `$f->{pin}` (version $f->{ver}) and does not move ($f->{outcome}), so no pin edit "
            . 'is made and the commit of the accepted plan is the candidate; no file is searched for '
            . 'an old version.';
    }

    my $update = "`guest-update.bash $m $key <candidate> ~/sandbox/EPICS-env`";
    if ($f->{macos_only}) {
        push @lines, "2. The one apply target, `$f->{targets}[0]`, applies `$f->{macos_only}` on macOS only, so "
            . "$update runs it and the log shows no `Patching` line on Linux.";
    } elsif (@{ $f->{targets} }) {
        my $extra = @{ $f->{files} } ? ' with the files ' . code_list(@{ $f->{files} }) : '';
        push @lines, '2. The apply targets ' . code_list(@{ $f->{targets} }) . "$extra are run by $update "
            . "before the build; the log shows $n `Patching $m-src` line" . ($n != 1 ? 's' : '') . '.';
    } else {
        push @lines, "2. The module has no apply target in the `patch:` list, so $update runs none and "
            . 'the log shows no `Patching` line.';
    }

    my $line3;
    if (@deps) {
        $line3 = "3. The dependents, the modules whose `_DEPS` line lists `build.$m`, are " . join(', ', @deps)
            . '; each is rebuilt on each machine after the update by one command, '
            . '`cd ~/sandbox/EPICS-env && make distclean.<d> && make conf.<d> && make build.<d>` '
            . '(label `rebuild-<d>`, whose `rc=0` covers the three)';
        if (@{ $f->{unsafe_deps} }) {
            $line3 .= ', except ' . join(', ', @{ $f->{unsafe_deps} })
                . ', whose `distclean` is unsafe by The checks, item 1, and which is rebuilt '
                . 'from a new source tree instead (move `<d>-src` aside, `make <D_KEY>`, the apply '
                . 'targets of `<d>` if any, `make conf.<d>`, `make build.<d>`)';
        }
        $line3 .= '.';
    } else {
        $line3 = "3. No module lists `build.$m` in its `_DEPS` line, so no dependent is rebuilt.";
    }
    if ($f->{unsafe}) {
        $line3 .= " The top Makefile of $m passes `realuninstall` to an `iocs` directory it does not build, "
            . "so `make distclean.$m` is never run on it; `guest-update.bash` removes the source "
            . 'tree and rebuilds from the clone, which is the safe form.';
    }
    push @lines, $line3;

    my $by = @stems
        ? 'by the library name' . (@stems > 1 ? 's' : '') . ' ' . code_list(map { "lib$_" } @stems) . ' and the module name'
        : 'by the module name only, because the module installs no shared library';
    my $good = @deps
        ? 'the search is good when every module it names is among the dependents (' . join(', ', @deps)
            . '), which are the build-order consumers; a module outside that list is a finding for the maintainer.'
        : 'the search is good when it names no module, since no module lists this one in its `_DEPS` line; '
            . 'a module it names is a finding for the maintainer.';
    my @scripts = module_scripts($m);
    my $scripts = code_list(@scripts);
    push @lines, "4. The checks on the candidate: `guest-roundtrip.bash <candidate> $m ~/sandbox` on the "
        . "Debian 13 machine, `guest-suite.bash ~/sandbox/EPICS-env ~/sandbox/iocsh-tests/$m "
        . "~/sandbox/alsu-site-modules \"<scripts>\"` on both with the scripts $scripts (the module "
        . 'scripts of The checks, item 3), `make check.deps` and `make check.env` on both, and '
        . "the search for the reverse dependencies of $m in the installed tree over "
        . "`\$(make -s print-INSTALL_LOCATION_EPICS)/modules` $by, as Stage 3 sets out, with the result "
        . "in `work/$m-bump/reverse-deps.md`; $good The 38 count of the suite is read on each machine with "
        . "`grep -a \"modules inspected\\|modules agree\" ~/sandbox/iocsh-tests/$m/verify_install_metadata.log` "
        . "(label `metadata-lines`). The checks are run by `tools/module-check/cycle.bash $m $key <candidate> "
        . '~/sandbox/alsu-site-modules`, which runs every command through `tools/module-check/guest-run.bash` with '
        . "`work/$m-bump/` as its log directory, with the labels of The checks (`checkout`, `build`, "
        . '`patch-round-trip`, `consumers`, `metadata-lines`, `installed-tree-deps`, `installed-tree-env`, '
        . '`reverse-deps`' . (@deps ? ', and `rebuild-<d>`' : '') . '), stops at the first log that does not end '
        . 'with `rc=0`, and prints one line per row of the Results table.';
    push @lines, '5. A check that is not good stops the cycle at that check with its log kept; the';
    push @lines, '   maintainer classifies the failure and decides, as the rule of a failed Stage 6';
    push @lines, '   sets out.';
    push @lines, '', 'Results:', '';
    push @lines, '| Check | Observed at | Test machine | Result | Evidence |';
    push @lines, '| --- | --- | --- | --- | --- |';

    my $patching = ($n == 0 || $f->{macos_only})
        ? 'no `Patching` line'
        : "$n `Patching $m-src` line" . ($n != 1 ? 's' : '') . ' before the build';
    my $soname = @stems
        ? ', the ' . join(' and ', map { "`lib$_`" } @stems) . ' SONAME' . (@stems > 1 ? 's' : '')
        : '';
    my $both = 'Debian 13, Rocky Linux 8.10';
    push @lines, "| `build`: $patching, `link: modules/$inst -> ./$inst-$f->{ver}`$soname, "
        . "`UPDATE-DONE $m <candidate>` | not run | $both | pending | none |";
    push @lines, '| `rebuild-<d>`: `rc=0` for ' . join(', ', @deps) . " | not run | $both | pending | none |" if @deps;
    my $count = $f->{macos_only} ? 0 : $n;
    push @lines, "| `patch-round-trip`: `init rc=0`, `patch rc=0`, `Patching $m-src lines: $count`, "
        . '`revert rc=0`, `status lines in all trees: 0` | not run | Debian 13 | pending | none |';
    push @lines, '| `consumers` with the site checkout: `minimal IOC exit=0`, `iocRun lines: 1`, `FAIL lines: 0`, '
        . "`run_all rc=0` over $scripts, `records listed: 322`; `metadata-lines`: `OK 38 modules inspected`, "
        . "`OK 38 modules agree with the effective configuration` | not run | $both | pending | none |";
    my $names = @deps ? 'names no module outside ' . join(', ', @deps) : 'names no module';
    push @lines, '| `installed-tree-deps` and `installed-tree-env` end with `rc=0`; `reverse-deps` '
        . "$names | not run | $both | pending | none |";
    push @lines, "| No `$f->{old}` left in the files that `$f->{pin_commit}` rewrote | not run | local host | pending | none |"
        if $f->{moved};
    return join("\n", @lines) . "\n";
}

sub main {
    my (@args) = @_;
    my ($inventory, $record, $help);
    GetOptionsFromArray(\@args, 'libs=s' => \$inventory, 'record=s' => \$record, 'help' => \$help)
        or pod2usage(-exitval => 2, -verbose => 0);
    pod2usage(-exitval => 0, -verbose => 1) if $help;
    @args == 1 or pod2usage(-exitval => 2, -verbose => 0, -message => 'one module name is required');
    defined $inventory or pod2usage(-exitval => 2, -verbose => 0, -message => '--libs <inventory> is required');
    my $module = $args[0];

    if (!defined $record) {
        my @records = sort { $a cmp $b } bsd_glob("$CHECKOUT/$RECORD_GLOB");
        @records == 1 or die "expected one $RECORD_GLOB, found " . scalar(@records) . "; use --record\n";
        $record = $records[0];
    }

    my ($name, $tag) = read_release(read_file("$CHECKOUT/$RELEASE_FILE"));
    my ($key) = grep { $name->{$_} eq $module } sort { $a cmp $b } keys %{$name};
    defined $key or die "no SRC_NAME_<KEY>:=$module in $RELEASE_FILE\n";
    my $ver = make_var("SRC_VER_$key");
    $ver ne '' or die "make print-SRC_VER_$key printed nothing\n";
    my $installed = basename(make_var("INSTALL_LOCATION_$key"));
    $installed =~ s/-\Q$ver\E$//;

    my @targets = apply_targets($module);
    my @files = map { basename($_) } sort { $a cmp $b } bsd_glob("$CHECKOUT/patch/$ver-*.p0.patch");
    my @fixed = grep { !/\.commit\./ } @targets;
    my @dependents = dependents_of($module);
    my ($row_pin, $outcome) = record_row($record, $module);
    my ($pin_commit, $old) = pin_move($key, $tag->{$key});
    # mca-libnet applies on macOS only, so its target leaves no Patching line
    # on Linux; the plan says so instead of counting the target.
    my $macos_only = ($module eq 'mca' && @targets == 1) ? 'mca-libnet' : '';

    my $facts = {
        module => $module, key => $key, pin => $tag->{$key}, ver => $ver, installed => $installed,
        outcome => $outcome, moved => defined $pin_commit ? 1 : 0,
        pin_commit => defined $pin_commit ? $pin_commit : '', old => defined $old ? $old : '',
        targets => \@targets, files => \@files, fixed => \@fixed, macos_only => $macos_only,
        dependents => \@dependents, unsafe => unsafe_distclean($module),
        unsafe_deps => [ grep { unsafe_distclean($_) } @dependents ],
        libs => [ library_stems($inventory, $installed) ],
    };
    print plan_block($facts);
    return 0;
}

my $status;
eval {
    $status = main(@ARGV);
    defined $status or die "internal error: main returned no exit status\n";
    1;
} or do {
    my $error = $@;
    print STDERR "plan-facts.pl: $error";
    $status = 2;
};
exit $status;

__END__

=head1 NAME

plan-facts.pl - print the cycle plan block of a module from the repository facts

=head1 SYNOPSIS

plan-facts.pl --libs <inventory> [--record <file>] <module>

=head1 OPTIONS

=over

=item B<--libs> <inventory>

File of C<< <installed name>: <stem> ... >> lines, one per installed module,
read from the installed tree of a test machine (the C<libs-inventory> label
of the first cycle); the stems of the module name its shared libraries.

=item B<--record> <file>

The release record whose Modules table gives the outcome text; default the
one C<docs/milestone-*.md> of the checkout.

=item B<--help>

Print this text and exit 0.

=back

=head1 DESCRIPTION

Prints, from the C<Issue:> line to the last Results row, the plan block of
the module as the release record drafts it: the pin and version from
C<configure/RELEASE> and C<make print-SRC_VER_E<lt>KEYE<gt>>; whether the
pin moved after the branch point of the release (the oldest commit of
C<git log -S'E<lt>pinE<gt>' E<lt>merge-baseE<gt>..HEAD -- configure/RELEASE>)
and the version its parent held; the outcome text of the Modules table; the
apply targets of the C<patch:> line of C<configure/RULES_SRC> and the patch
files at the pin; the dependents from C<configure/CONFIG_MODS_DEPS> and the
ones whose C<distclean> is unsafe, read from the sources beside the checkout;
and the library stems from the inventory. Runs on the local host in a
checkout that holds the module sources.

Exit status: 0 the block was printed; 2 a usage error, a missing input, or a
module without a row in the record.

=cut
