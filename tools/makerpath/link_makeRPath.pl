#!/usr/bin/env perl
# Links real shared libraries and an executable with the flags that makeRPath prints, as the EPICS
# build does (-L, -l, the -rpath entries, new dtags), installs them in a layout, and has the dynamic
# loader resolve them without LD_LIBRARY_PATH: in place, through a symbolic link to the tree, and
# after the whole tree is moved elsewhere. Each layout runs with makeRPath.py (the reference) and with
# makeRPath.pl under every listed interpreter, with and without -CSD; the flags, the link status, and
# the loader outcome must be the same, and each layout has an expected outcome of its own.
#
# Environment: MAKERPATH_PY, MAKERPATH_PL, MAKERPATH_PYTHON, MAKERPATH_PERLS as in compare_makeRPath.pl;
# CC (default gcc).

use strict;
use warnings;
use 5.10.1;

use Cwd ();
use File::Basename ();
use File::Path ();
use File::Temp ();
use POSIX ();


# Temporary files are created below work/scratch of the repository (EPICS_ENV_SCRATCH names another
# directory), and each run removes them when it ends. Child commands inherit TMPDIR.
my $SCRATCH_BASE = $ENV{EPICS_ENV_SCRATCH} // File::Basename::dirname(File::Basename::dirname(File::Basename::dirname(Cwd::abs_path($0)))) . '/work/scratch';
File::Path::make_path($SCRATCH_BASE);
-d $SCRATCH_BASE && -w _ or die "$SCRATCH_BASE: not a writable directory\n";
$ENV{TMPDIR} = $SCRATCH_BASE;

my $HERE   = File::Basename::dirname(Cwd::abs_path($0));
my $PY     = $ENV{MAKERPATH_PY} // "$HERE/../../epics-base-src/src/tools/makeRPath.py";
my $PL     = $ENV{MAKERPATH_PL} // "$HERE/../../epics-base-src/src/tools/makeRPath.pl";
my $PYTHON = $ENV{MAKERPATH_PYTHON} // 'python3';
my @PERLS  = split ' ', ($ENV{MAKERPATH_PERLS} // $^X);
my $CC     = $ENV{CC} // 'gcc';
$_ = Cwd::abs_path($_) // $_ for ($PY, $PL);

my $TMP = Cwd::abs_path(File::Temp::tempdir('makerpath-link-XXXXXX', TMPDIR => 1, CLEANUP => 1));

# The temporary directory holds the output of every run; when it is full the reference fails with exit
# status 120 and the result says nothing about the script under test, so stop with a clear message.
{
    my $probe = "$TMP/.space";
    my $fh;
    my $ok = open($fh, '>', $probe) && print({$fh} 'x' x 1048576) && close($fh);
    unlink($probe);
    $ok or die "The temporary directory $TMP cannot take 1 MB: free space or set TMPDIR to another directory.\n";
}

sub run_command {
    my ($command, %options) = @_;
    my $out = File::Temp->new(DIR => $TMP);
    my $err = $options{separate} ? File::Temp->new(DIR => $TMP) : $out;
    my $pid = fork();
    defined $pid or die "fork: $!\n";
    if (!$pid) {
        chdir($options{cwd}) or POSIX::_exit(125) if $options{cwd};
        open(STDIN, '<', '/dev/null') or POSIX::_exit(126);
        open(STDOUT, '>&', $out) or POSIX::_exit(126);
        open(STDERR, '>&', $err) or POSIX::_exit(126);
        delete $ENV{LD_LIBRARY_PATH};
        exec { $command->[0] } @{$command} or POSIX::_exit(127);
    }
    waitpid($pid, 0);
    my $status = ($? & 127) ? 'signal ' . ($? & 127) : $? >> 8;
    seek($out, 0, 0);
    local $/;
    my $text = readline($out);
    $text = '' unless defined $text;
    return ($status, $text) unless $options{separate};
    seek($err, 0, 0);
    my $error = readline($err);
    return ($status, $text, defined $error ? $error : '');
}

sub write_file {
    my ($path, $text) = @_;
    open(my $fh, '>', $path) or die "$path: $!\n";
    print {$fh} $text or die "$path: $!\n";
    close($fh) or die "$path: $!\n";
}

# The three objects: libA (a), libB (b, needs libA), and the program (needs both).
my $SRC = "$TMP/src";
mkdir($SRC) or die "$SRC: $!\n";
write_file("$SRC/a.c", "int a(void) { return 1; }\n");
write_file("$SRC/b.c", "int a(void);\nint b(void) { return a() + 10; }\n");
write_file("$SRC/main.c", "#include <stdio.h>\nint b(void);\nint main(void) { printf(\"%d\\n\", b() + 100); return 0; }\n");
for my $name (qw(a b main)) {
    my ($status, $text) = run_command([ $CC, '-fPIC', '-c', '-o', "$SRC/$name.o", "$SRC/$name.c" ]);
    $status == 0 or die "compile $name failed: $text\n";
}

# A layout: where the files are installed (physical directories), how the build names them (logical
# directories, as the build passes them to makeRPath), the roots, and the checks that follow.
#   dirs    : physical directories created under the layout root, keyed by role
#   links   : symbolic links created before installing: [ link path, target ] relative to the layout root
#   logical : the build's name of each role directory
my @LAYOUTS = (
    {
        name => 'plain', expect_run => 1, expect_moved => 1,
        physical => { A => 'base/lib/linux-x86_64', B => 'modules/m1/lib/linux-x86_64', X => 'modules/m2/bin/linux-x86_64' },
        links => [], roots => ['.'],
    },
    {
        name => 'dependency-outside-root', expect_run => 1, expect_moved => 1, outside => 'A',
        physical => { A => '../outside/lib/linux-x86_64', B => 'modules/m1/lib/linux-x86_64', X => 'modules/m2/bin/linux-x86_64' },
        links => [], roots => ['.'],
    },
    {
        name => 'tree-named-through-a-link', expect_run => 1, expect_moved => 1, through_link => 1,
        physical => { A => 'base/lib/linux-x86_64', B => 'modules/m1/lib/linux-x86_64', X => 'modules/m2/bin/linux-x86_64' },
        links => [], roots => ['.'],
    },
    {
        name => 'version-link-same-depth', expect_run => 1, expect_moved => 1,
        physical => { A => 'base/lib/linux-x86_64', B => 'modules/m1-1.0/lib/linux-x86_64', X => 'modules/m2-1.0/bin/linux-x86_64' },
        logical  => { B => 'modules/m1/lib/linux-x86_64', X => 'modules/m2/bin/linux-x86_64' },
        links => [ [ 'modules/m1', 'm1-1.0' ], [ 'modules/m2', 'm2-1.0' ] ], roots => ['.'],
    },
    {
        name => 'directory-named-with-leading-dots', expect_run => 1, expect_moved => 0, perl_moved => 1, improves => 1,
        physical => { A => 'base/lib/linux-x86_64', B => '..data/lib/linux-x86_64', X => 'modules/m2/bin/linux-x86_64' },
        links => [], roots => ['.'],
    },
    {
        name => 'version-link-different-depth', expect_run => 0, expect_moved => 0, expect_warning => 1,
        physical => { A => 'base/lib/linux-x86_64', B => 'modules/m1/lib/linux-x86_64', X => 'versions/deep/m2-1.0/bin/linux-x86_64' },
        logical  => { X => 'modules/m2/bin/linux-x86_64' },
        links => [ [ 'modules/m2', '../versions/deep/m2-1.0' ] ], roots => ['.'],
    },
);

# Builds one layout with the given makeRPath command and returns a description of the outcome.
sub run_layout {
    my ($layout, $command) = @_;
    my $base = "$TMP/work-$layout->{name}";
    File::Path::remove_tree($base);
    my $root = "$base/root";
    my $outside = "$base/outside";
    File::Path::make_path($root, "$base/outside");
    my %physical = %{ $layout->{physical} };
    for my $role (sort keys %physical) {
        File::Path::make_path("$root/$physical{$role}");
    }
    # Links are made after their targets exist.
    for my $link (@{ $layout->{links} }) {
        my ($path, $target) = @{$link};
        File::Path::make_path(File::Basename::dirname("$root/$path"));
        if (-d "$root/$path" && !-l "$root/$path") {
            rmdir("$root/$path") or die "rmdir $root/$path: $!\n";
        }
        symlink($target, "$root/$path") or die "symlink $root/$path: $!\n";
    }
    my $named_root = $root;
    if ($layout->{through_link}) {
        $named_root = "$base/treelink";
        symlink($root, $named_root) or die "symlink $named_root: $!\n";
    }
    my %logical = map { $_ => ($layout->{logical}{$_} // $physical{$_}) } keys %physical;
    my %dir;
    for my $role (keys %logical) {
        $dir{$role} = $logical{$role} =~ m{\A\.\./} ? "$root/$logical{$role}" : "$named_root/$logical{$role}";
        $dir{$role} = Cwd::abs_path("$base/root/$logical{$role}") if $logical{$role} =~ m{\A\.\./};
    }
    my @roots = map { $_ eq '.' ? $named_root : "$named_root/$_" } @{ $layout->{roots} };
    my $roots = join(':', @roots);

    my @report;
    my $warned = 0;
    my $flags = sub {
        my ($final, @deps) = @_;
        my ($status, $text, $error) = run_command([ @{$command}, '-O', '$ORIGIN', '-F', $final, '-R', $roots, @deps ], separate => 1);
        $status == 0 or die "makeRPath failed: $text$error\n";
        $error =~ s/^makeRPath\.pl: warning:/makeRPath: warning:/mg;
        my @warnings = grep { /warning:/ } split /\n/, $error;
        $warned++ if @warnings;
        chomp $text;
        (my $shown = $text) =~ s/\Q$base\E/<base>/g;
        push @report, "flags: $shown";
        return split(' ', $text);
    };
    my $link = sub {
        my ($label, @cmd) = @_;
        my ($status, $text) = run_command(\@cmd);
        push @report, "link $label: " . ($status == 0 ? 'ok' : "failed $status");
        $status == 0 or die "link $label failed: $text\n";
    };
    my $ok = eval {
        $link->('libA', $CC, '-shared', '-o', "$dir{A}/libA.so", "$SRC/a.o");
        $link->('libB', $CC, '-shared', '-o', "$dir{B}/libB.so", "$SRC/b.o", "-L$dir{A}", '-lA',
            $flags->($dir{B}, $dir{A}), '-Wl,--enable-new-dtags');
        $link->('program', $CC, '-o', "$dir{X}/prog", "$SRC/main.o", "-L$dir{B}", "-L$dir{A}", '-lB', '-lA',
            $flags->($dir{X}, $dir{B}, $dir{A}), '-Wl,--enable-new-dtags');
        1;
    };
    if (!$ok) {
        push @report, "build error: $@";
        return @report;
    }
    my $run = sub {
        my ($label, $program) = @_;
        my ($status, $text) = run_command([$program]);
        $text =~ s/\Q$base\E/<base>/g;
        chomp $text;
        push @report, "run $label: " . ($status == 0 ? $text : "failed $status");
        return $status == 0 && $text eq '111';
    };
    # Run where it was installed, by its physical path.
    my $physical_program = "$root/$physical{X}/prog";
    my $ran = $run->('installed', $physical_program);
    my $ran_logical = $run->('by its build name', "$dir{X}/prog");
    # Move the whole tree to another place, so that no entry can still reach the old place, and run it there.
    my $moved = 0;
    if (rename($root, "$base/moved")) {
        $moved = $run->('moved tree', "$base/moved/$physical{X}/prog");
    } else {
        push @report, "move failed: $!";
    }
    return (@report, $ran ? 'result: loads' : 'result: does not load', $moved ? 'moved: loads' : 'moved: does not load',
        $ran_logical ? 'by name: loads' : 'by name: does not load', $warned ? 'warning: yes' : 'warning: none');
}

my @impls = ([ 'python', [ $PYTHON, $PY ] ]);
push @impls, [ "perl $_", [ $_, $PL ] ], [ "perl -CSD $_", [ $_, '-CSD', $PL ] ] for @PERLS;

my ($checks, $failed) = (0, 0);
sub check {
    my ($ok, $name, $detail) = @_;
    $checks++;
    printf "[ %s ] %s\n", $ok ? 'PASS' : 'FAIL', $name;
    if (!$ok) {
        $failed++;
        print "         $_\n" for split /\n/, $detail // '';
    }
}

for my $layout (@LAYOUTS) {
    my ($reference_label, $reference_command) = @{ $impls[0] };
    my @reference = run_layout($layout, $reference_command);
    my %got = map { $_ => 1 } @reference;
    my $loads  = $got{'result: loads'} ? 1 : 0;
    my $moves  = $got{'moved: loads'} ? 1 : 0;
    check($loads == $layout->{expect_run}, "$layout->{name}: the loader " . ($layout->{expect_run} ? 'resolves' : 'does not resolve') . ' the installed program',
        join("\n", @reference));
    check($moves == $layout->{expect_moved}, "$layout->{name}: the copied tree " . ($layout->{expect_moved} ? 'still resolves' : 'does not resolve'),
        join("\n", @reference));
    my @expected = grep { !/\Awarning:/ } @reference;
    for my $impl (@impls[ 1 .. $#impls ]) {
        my ($label, $command) = @{$impl};
        my @result = run_layout($layout, $command);
        my @compared = grep { !/\Awarning:/ } @result;
        my @wanted = @expected;
        if ($layout->{improves}) {
            # The reference prints absolute entries here; only the part before the move is compared, and the
            # moved tree must load with the script under test.
            my $drop = qr/\Aflags:|\Arun moved tree|\Amoved:/;
            @compared = grep { $_ !~ $drop } @compared;
            @wanted = grep { $_ !~ $drop } @wanted;
            check((grep { $_ eq 'moved: loads' } @result) ? 1 : 0, "$layout->{name}: $label loads the program after the tree is moved, which the reference does not", join("\n", @result));
        }
        my $same = join("\n", @compared) eq join("\n", @wanted);
        check($same, "$layout->{name}: $label gives the flags, link status, and loader outcome of $reference_label",
            "python:\n" . join("\n", map { "  $_" } @wanted) . "\n$label:\n" . join("\n", map { "  $_" } @compared));
        my $warned = (grep { $_ eq 'warning: yes' } @result) ? 1 : 0;
        check($warned == ($layout->{expect_warning} // 0), "$layout->{name}: $label " . ($layout->{expect_warning} ? 'warns that an entry misses its directory' : 'prints no warning'),
            join("\n", @result));
    }
}
printf "checks=%d fail=%d\n", $checks, $failed;
exit($failed ? 1 : 0);
