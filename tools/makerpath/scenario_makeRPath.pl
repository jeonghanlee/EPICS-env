#!/usr/bin/env perl
# Checks makeRPath.pl by input and output only. It is a pure function of its command line and working
# directory, so every check runs it once on an input and compares the printed text with an expected text.
#
# 1. Scenarios: the kinds of input that the build gives it, with the expected text derived by hand from
#    the rules of the Base build (configure/RULES_BUILD, configure/os/CONFIG.Common.UnixCommon and
#    configure/os/CONFIG.Common.linuxCommon): the final directory is where the file is installed (the build
#    directory for a test product), the root is LINKER_ORIGIN_ROOT, the directories are the library
#    directory of the module and those of its dependencies, and the origin is the text \$ORIGIN.
# 2. Installed tree: for every ELF file with a RUNPATH of an installed tree built with makeRPath.py, the
#    input is rebuilt from the place of the file and from its RUNPATH, and the printed run path must be
#    that RUNPATH again.
#
# Usage: scenario_makeRPath.pl [--tree <installed tree>]
# Environment: MAKERPATH_PL (the script under test, default: the makeRPath.pl of the Base checkout),
#   MAKERPATH_PERLS (blank-separated Perl interpreters, default $^X), MAKERPATH_PY (optional: the reference,
#   run on the scenarios as well and reported when it differs from the expected text).

use strict;
use warnings;
use 5.10.1;

use Cwd ();
use File::Basename ();
use File::Path ();
use File::Temp ();
use Getopt::Long ();
use POSIX ();

my $HERE   = File::Basename::dirname(Cwd::abs_path($0));
my $PL     = $ENV{MAKERPATH_PL} // "$HERE/../../epics-base-src/src/tools/makeRPath.pl";
my $PY     = $ENV{MAKERPATH_PY};
my $PYTHON = $ENV{MAKERPATH_PYTHON} // 'python3';
my @PERLS  = split ' ', ($ENV{MAKERPATH_PERLS} // $^X);
my $tree;
Getopt::Long::GetOptions('tree=s' => \$tree) or die "usage: scenario_makeRPath.pl [--tree <installed tree>]\n";
$PL = Cwd::abs_path($PL) // $PL;
$PY = Cwd::abs_path($PY) // $PY if defined $PY;

my $SCRATCH_BASE = $ENV{EPICS_ENV_SCRATCH} // File::Basename::dirname(File::Basename::dirname($HERE)) . '/work/scratch';
File::Path::make_path($SCRATCH_BASE);
-d $SCRATCH_BASE && -w _ or die "$SCRATCH_BASE: not a writable directory\n";
$ENV{TMPDIR} = $SCRATCH_BASE;
my $TMP = Cwd::abs_path(File::Temp::tempdir('makerpath-scenario-XXXXXX', TMPDIR => 1, CLEANUP => 1));

sub run_command {
    my ($command, $cwd) = @_;
    my $out = File::Temp->new(DIR => $TMP);
    my $err = File::Temp->new(DIR => $TMP);
    my $pid = fork();
    defined $pid or die "fork: $!\n";
    if (!$pid) {
        chdir($cwd) or POSIX::_exit(125);
        open(STDIN, '<', '/dev/null') or POSIX::_exit(126);
        open(STDOUT, '>&', $out) or POSIX::_exit(126);
        open(STDERR, '>&', $err) or POSIX::_exit(126);
        exec { $command->[0] } @{$command} or POSIX::_exit(127);
    }
    waitpid($pid, 0);
    my $status = ($? & 127) ? 'signal ' . ($? & 127) : $? >> 8;
    my ($stdout, $stderr);
    for my $pair ([ $out, \$stdout ], [ $err, \$stderr ]) {
        my ($handle, $target) = @{$pair};
        seek($handle, 0, 0);
        binmode($handle);
        local $/;
        ${$target} = readline($handle);
        ${$target} = '' unless defined ${$target};
    }
    return ($status, $stdout, $stderr);
}

# The digest of a file by sha256sum, which every target has; the test loads no module for it.
sub sha256 {
    my ($path) = @_;
    open(my $pipe, '-|', 'sha256sum', $path) or return 'unavailable';
    my $line = <$pipe>;
    close($pipe);
    return defined $line && $line =~ /\A([0-9a-f]{64})/ ? substr($1, 0, 16) : 'unavailable';
}
printf "script under test %s (sha256 %s); test %s (sha256 %s)\n", $PL, sha256($PL), Cwd::abs_path($0), sha256($0);

my ($checks, $failed, $skipped, $incomplete) = (0, 0, 0, 0);
sub check {
    my ($ok, $name, $detail) = @_;
    $checks++;
    printf "[ %s ] %s\n", $ok ? 'PASS' : 'FAIL', $name;
    return if $ok;
    $failed++;
    print "         $_\n" for split /\n/, $detail // '';
    return;
}

my @RUNNERS = map { my $p = $_; ([ $p, [ $p, $PL ] ], [ "$p -CSD", [ $p, '-CSD', $PL ] ]) } @PERLS;

# ---- 1. scenarios -----------------------------------------------------------------------------

# The tree of an installation, as the build names it: the version directory of the distribution holds
# base, modules (one directory per module and version) and vendor.
my $R = '/home/user/epics/1.5.0/debian-13/7.0.10';
my $A = 'linux-x86_64';
my $O = '\\$ORIGIN';                      # the origin as the build passes it: a backslash and $ORIGIN
my $BASE_LIB = "$R/base/lib/$A";

# name, final directory, directories, expected stdout, expected warning, cwd, roots, origin
my @SCENARIOS = (
    {
        name => 'a library of Base links against its own directory',
        final => $BASE_LIB, dirs => [$BASE_LIB],
        expect => "-Wl,-rpath-link,$BASE_LIB -Wl,-rpath,$O/.",
    },
    {
        name => 'a program of Base finds the library directory two levels up',
        final => "$R/base/bin/$A", dirs => [$BASE_LIB],
        expect => "-Wl,-rpath-link,$BASE_LIB -Wl,-rpath,$O/../../lib/$A",
    },
    {
        name => 'a module library finds Base four levels up and itself in place',
        final => "$R/modules/asyn-4.46.0/lib/$A", dirs => [ $BASE_LIB, "$R/modules/asyn-4.46.0/lib/$A" ],
        expect => "-Wl,-rpath-link,$BASE_LIB -Wl,-rpath,$O/../../../../base/lib/$A " .
                  "-Wl,-rpath-link,$R/modules/asyn-4.46.0/lib/$A -Wl,-rpath,$O/.",
    },
    {
        name => 'a module program finds Base, a sibling module, and its own library',
        final => "$R/modules/motor-7.3/bin/$A",
        dirs => [ $BASE_LIB, "$R/modules/asyn-4.46.0/lib/$A", "$R/modules/motor-7.3/lib/$A" ],
        expect => "-Wl,-rpath-link,$BASE_LIB -Wl,-rpath,$O/../../../../base/lib/$A " .
                  "-Wl,-rpath-link,$R/modules/asyn-4.46.0/lib/$A -Wl,-rpath,$O/../../../asyn-4.46.0/lib/$A " .
                  "-Wl,-rpath-link,$R/modules/motor-7.3/lib/$A -Wl,-rpath,$O/../../lib/$A",
    },
    {
        name => 'a vendor library inside the root is relative',
        final => "$R/modules/measComp-1.0/lib/$A", dirs => [ $BASE_LIB, "$R/vendor/uldaq/lib" ],
        expect => "-Wl,-rpath-link,$BASE_LIB -Wl,-rpath,$O/../../../../base/lib/$A " .
                  "-Wl,-rpath-link,$R/vendor/uldaq/lib -Wl,-rpath,$O/../../../../vendor/uldaq/lib",
    },
    {
        name => 'a system directory outside the root is absolute and has no link-time entry',
        final => "$R/modules/x-1.0/lib/$A", dirs => [ $BASE_LIB, '/usr/lib/x86_64-linux-gnu' ],
        expect => "-Wl,-rpath-link,$BASE_LIB -Wl,-rpath,$O/../../../../base/lib/$A -Wl,-rpath,/usr/lib/x86_64-linux-gnu",
    },
    {
        name => 'a test product runs in its build directory, outside the root: absolute entries and a warning',
        final => '.', cwd => 'build', dirs => [$BASE_LIB],
        expect => "-Wl,-rpath,$BASE_LIB", warning => qr/final location .* is not under any of the roots/,
    },
    {
        # A symbolic link in the prefix of the tree, made for the scenario: the script reads no file, so the
        # prefix stays as written and is not resolved to the directory behind the link.
        name => 'a tree named through a symbolic link prefix keeps the prefix as written',
        prefix => 'linked',
        final => '@PREFIX@/modules/asyn-4.46.0/lib/linux-x86_64', root => '@PREFIX@',
        dirs => [ '@PREFIX@/base/lib/linux-x86_64', '@PREFIX@/modules/asyn-4.46.0/lib/linux-x86_64' ],
        expect => '-Wl,-rpath-link,@PREFIX@/base/lib/linux-x86_64 -Wl,-rpath,' . $O . '/../../../../base/lib/linux-x86_64 ' .
                  '-Wl,-rpath-link,@PREFIX@/modules/asyn-4.46.0/lib/linux-x86_64 -Wl,-rpath,' . $O . '/.',
    },
    {
        name => 'an IOC installed outside the root gets absolute entries and a warning',
        final => "/opt/iocs/app/bin/$A", dirs => [ $BASE_LIB, "$R/modules/asyn-4.46.0/lib/$A", "/opt/iocs/app/lib/$A" ],
        expect => "-Wl,-rpath,$BASE_LIB -Wl,-rpath,$R/modules/asyn-4.46.0/lib/$A -Wl,-rpath,/opt/iocs/app/lib/$A",
        warning => qr/final location \/opt\/iocs\/app\/bin\/linux-x86_64 is not under any of the roots/,
    },
    {
        name => 'the build tree and the install tree as roots give one relative entry for a library in either (the example of the comment of makeRPath.py)',
        final => '/install/bin', root => '/build:/install', dirs => [ '/install/lib', '/build/lib', '/other/lib' ],
        expect => "-Wl,-rpath-link,/install/lib -Wl,-rpath,$O/../lib -Wl,-rpath-link,/build/lib -Wl,-rpath,/other/lib",
    },
    {
        name => 'the same with the final directory in the build tree',
        final => '/build/bin', root => '/build:/install', dirs => [ '/install/lib', '/build/lib' ],
        expect => "-Wl,-rpath-link,/install/lib -Wl,-rpath,$O/../lib -Wl,-rpath-link,/build/lib",
    },
    {
        name => 'a directory named with leading dots directly below the root is relative',
        final => "$R/modules/x-1.0/lib/$A", dirs => [ $BASE_LIB, "$R/..data/lib" ],
        expect => "-Wl,-rpath-link,$BASE_LIB -Wl,-rpath,$O/../../../../base/lib/$A " .
                  "-Wl,-rpath-link,$R/..data/lib -Wl,-rpath,$O/../../../../..data/lib",
    },
    {
        name => 'a cross target keeps its own architecture directory',
        final => "$R/modules/asyn-4.46.0/lib/linux-arm", dirs => [ "$R/base/lib/linux-arm", "$R/modules/asyn-4.46.0/lib/linux-arm" ],
        expect => "-Wl,-rpath-link,$R/base/lib/linux-arm -Wl,-rpath,$O/../../../../base/lib/linux-arm " .
                  "-Wl,-rpath-link,$R/modules/asyn-4.46.0/lib/linux-arm -Wl,-rpath,$O/.",
    },
    {
        name => 'a directory named twice gives one entry',
        final => "$R/modules/asyn-4.46.0/lib/$A", dirs => [ $BASE_LIB, $BASE_LIB, "$R/modules/asyn-4.46.0/lib/$A" ],
        expect => "-Wl,-rpath-link,$BASE_LIB -Wl,-rpath,$O/../../../../base/lib/$A " .
                  "-Wl,-rpath-link,$R/modules/asyn-4.46.0/lib/$A -Wl,-rpath,$O/.",
    },
);

for my $scenario (@SCENARIOS) {
    my $cwd = '/';
    if (defined $scenario->{cwd}) {
        $cwd = "$TMP/$scenario->{cwd}";
        File::Path::make_path($cwd);
    }
    if (defined $scenario->{prefix}) {
        # The directories exist behind a link; the text of the command line and of the expectation names the link.
        my $real = "$TMP/$scenario->{prefix}-real/1.5.0";
        File::Path::make_path("$real/modules/asyn-4.46.0/lib/linux-x86_64", "$real/base/lib/linux-x86_64");
        symlink("$TMP/$scenario->{prefix}-real", "$TMP/$scenario->{prefix}") or die "symlink: $!\n";
        my $prefix = "$TMP/$scenario->{prefix}/1.5.0";
        my %copy = %{$scenario};
        for my $key (qw(final root expect)) { (my $text = $copy{$key}) =~ s/\@PREFIX\@/$prefix/g; $copy{$key} = $text }
        $copy{dirs} = [ map { (my $text = $_) =~ s/\@PREFIX\@/$prefix/g; $text } @{ $scenario->{dirs} } ];
        $scenario = \%copy;
    }
    my @args = ('-O', $O, '-F', $scenario->{final}, '-R', $scenario->{root} // $R, @{ $scenario->{dirs} });
    my @all = @RUNNERS;
    push @all, [ 'python', [ $PYTHON, $PY ] ] if defined $PY;
    for my $runner (@all) {
        my ($label, $command) = @{$runner};
        my ($status, $stdout, $stderr) = run_command([ @{$command}, @args ], $cwd);
        chomp $stdout;
        my $text = "stdout [$stdout]\nexpected [$scenario->{expect}]\nstatus $status stderr [$stderr]";
        if ($label eq 'python') {
            # The reference is reported, not judged: it shares the expected text where it is right.
            print "         note: the reference prints [$stdout]\n" if $stdout ne $scenario->{expect};
            next;
        }
        check($status eq '0' && $stdout eq $scenario->{expect}, "$scenario->{name} ($label)", $text);
        if (defined $scenario->{warning}) {
            check($stderr =~ $scenario->{warning} ? 1 : 0, "$scenario->{name}: the warning says why ($label)", $text);
        } else {
            check($stderr eq '' ? 1 : 0, "$scenario->{name}: no message ($label)", $text);
        }
    }
}

# ---- 2. installed tree ------------------------------------------------------------------------

if (!defined $tree) {
    $skipped++;
    print "[ SKIP ] installed tree: no tree given (use --tree <installed tree built with makeRPath.py>); the run path of its ELF files is not checked\n";
} elsif (!defined Cwd::abs_path($tree) || !-d $tree) {
    $incomplete++;
    print "[ INCOMPLETE ] installed tree: $tree is not a directory\n";
} elsif (!grep { -x "$_/readelf" } split /:/, $ENV{PATH} // '') {
    $incomplete++;
    print "[ INCOMPLETE ] installed tree: readelf is not on PATH\n";
} else {
    my $root = Cwd::abs_path($tree);
    my @elf;
    my @stack = ($root);
    while (defined(my $dir = pop @stack)) {
        opendir(my $dh, $dir) or next;
        for my $name (sort readdir($dh)) {
            next if $name eq '.' || $name eq '..';
            my $path = "$dir/$name";
            next if -l $path;
            if (-d _) { push @stack, $path; next }
            -f _ or next;
            open(my $fh, '<:raw', $path) or next;
            my $magic = '';
            read($fh, $magic, 4);
            close($fh);
            push @elf, $path if $magic eq "\x7fELF";
        }
        closedir($dh);
    }
    my ($tested, $skipped, $mismatch) = (0, 0, 0);
    for my $file (sort @elf) {
        my $text = '';
        {
            open(my $pipe, '-|', 'readelf', '-d', $file) or next;
            local $/;
            $text = <$pipe>;
            close($pipe);
        }
        my ($runpath) = $text =~ /\((?:RUNPATH|RPATH)\)\s+Library (?:runpath|rpath): \[(.*?)\]/;
        if (!defined $runpath) { $skipped++; next }
        my $final = File::Basename::dirname($file);
        my @recorded = split /:/, $runpath;
        my @dirs;
        for my $entry (@recorded) {
            if ($entry =~ m{\A\$ORIGIN(?:/(.*))?\z}) {
                my $relative = defined $1 ? $1 : '.';
                my @parts;
                for my $part (split m{/}, "$final/$relative") {
                    next if $part eq '' || $part eq '.';
                    if ($part eq '..') { pop @parts; next }
                    push @parts, $part;
                }
                push @dirs, '/' . join('/', @parts);
            } else {
                push @dirs, $entry;
            }
        }
        $tested++;
        for my $runner (@RUNNERS) {
            my ($label, $command) = @{$runner};
            my ($status, $stdout, $stderr) = run_command([ @{$command}, '-O', $O, '-F', $final, '-R', $root, @dirs ], '/');
            my @printed = map { /\A-Wl,-rpath,(.*)\z/s ? do { my $e = $1; $e =~ s/\A\\\$ORIGIN/\$ORIGIN/; $e } : () } split ' ', $stdout;
            my $same = join(':', @printed) eq join(':', @recorded);
            if ($status ne '0' || !$same) {
                $mismatch++;
                my $short = substr($file, length($root));
                check(0, "the run path of $short is reproduced ($label)", "recorded [$runpath]\nprinted  [" . join(':', @printed) . "]\nstatus $status stderr [$stderr]");
            }
        }
    }
    check($tested > 0 && $mismatch == 0, "the run path of each of $tested ELF files of the installed tree is reproduced under every Perl ($skipped files have no run path)",
        "tree $root");
}

printf "checks=%d fail=%d skipped=%d incomplete=%d\n", $checks, $failed, $skipped, $incomplete;
exit($failed ? 1 : $incomplete ? 3 : 0);
