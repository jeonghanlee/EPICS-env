#!/usr/bin/env perl
# Compares makeRPath.py (the reference) with makeRPath.pl on identical command lines, working
# directories and environments. A case passes only when the Perl tool, run under each listed
# interpreter with and without -CSD (the PERL of the EPICS Base build), gives the same exit
# status and the same stdout bytes as the Python original; the text on stderr is compared as
# well when it is plain ASCII. The cases are curated (option forms, path algebra, encodings,
# environment, working directory) and generated from a fixed seed.
#
# Environment:
#   MAKERPATH_PY      the reference script (default: the makeRPath.py of the Base checkout)
#   MAKERPATH_PL      the script under test (default: the makeRPath.pl of the Base checkout after make patch)
#   MAKERPATH_PYTHON  the Python interpreter (default python3)
#   MAKERPATH_PERLS   blank-separated Perl interpreters to run the script under (default: $^X)
#   MAKERPATH_FUZZ    number of generated cases (default 1500)
#   MAKERPATH_SEED    seed of the generator (default 20261112)
#   MAKERPATH_HELP_TEXT  1 compares the help text too (the wording of argparse varies with the Python version)
#   MAKERPATH_HELP_BUNDLE  1 compares the help flag bundled with other letters (-hF); Python 3.13 and 3.6 differ there
#   MAKERPATH_SHOW    number of mismatches to print in full (default 8)

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
my $FUZZ   = $ENV{MAKERPATH_FUZZ} // 1500;
my $SEED   = $ENV{MAKERPATH_SEED} // 20261112;
my $SHOW   = $ENV{MAKERPATH_SHOW} // 8;
$_ = Cwd::abs_path($_) // $_ for ($PY, $PL);

my $TMP = File::Temp::tempdir('makerpath-XXXXXX', TMPDIR => 1, CLEANUP => 1);
$TMP = Cwd::abs_path($TMP);

# The temporary directory holds the output of every run; when it is full the reference fails with exit
# status 120 and the result says nothing about the script under test, so stop with a clear message.
{
    my $probe = "$TMP/.space";
    my $fh;
    my $ok = open($fh, '>', $probe) && print({$fh} 'x' x 1048576) && close($fh);
    unlink($probe);
    $ok or die "The temporary directory $TMP cannot take 1 MB: free space or set TMPDIR to another directory.\n";
}
for my $dir (qw(build/lib build/module/lib other/lib inst/lib root/lib root2/lib usr/bin/linux-x86_64
                usr/lib/linux-x86_64), 'sp ace/lib', "build/\xc3\xa9/lib") {
    File::Path::make_path("$TMP/$dir");
}
symlink("$TMP/build", "$TMP/link") or die "symlink: $!\n";
my @CWDS = ($TMP, "$TMP/build", "$TMP/build/lib", "$TMP/link/lib", '/', "$TMP/sp ace");

# Runs a command with the given environment changes and returns (status, stdout, stderr).
sub run_command {
    my ($command, $cwd, $env) = @_;
    my $out = File::Temp->new(DIR => $TMP);
    my $err = File::Temp->new(DIR => $TMP);
    my $pid = fork();
    defined $pid or die "fork: $!\n";
    if (!$pid) {
        chdir($cwd) or POSIX::_exit(125);
        open(STDIN, '<', '/dev/null') or POSIX::_exit(126);
        open(STDOUT, '>&', $out) or POSIX::_exit(126);
        open(STDERR, '>&', $err) or POSIX::_exit(126);
        delete $ENV{EPICS_DEBUG_RPATH};
        $ENV{LC_ALL} = 'C.UTF-8';
        delete $ENV{COLUMNS};
        for my $key (keys %{$env}) {
            if (defined $env->{$key}) { $ENV{$key} = $env->{$key} } else { delete $ENV{$key} }
        }
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

# ---- cases -----------------------------------------------------------------------------------

my @CASES;
sub add_case {
    my (%case) = @_;
    $case{cwd}  //= '/';
    $case{env}  //= {};
    $case{args} //= [];
    push @CASES, \%case;
    return;
}

my $B = "$TMP/build";
my @base = ('-F', "$B/lib", '-R', $B);

# Option forms: separate, attached, equals, long, abbreviated, repeated, misplaced, invalid.
add_case(name => 'opt-short-attached-F',   args => ["-F$B/lib", '-R', $B, "$B/module/lib"]);
add_case(name => 'opt-short-attached-R',   args => ['-F', "$B/lib", "-R$B", "$B/module/lib"]);
add_case(name => 'opt-short-attached-O',   args => ['-O@lp', '-F', "$B/lib", '-R', $B, "$B/module/lib"]);
add_case(name => 'opt-short-equals-F',     args => ["-F=$B/lib", '-R', $B, "$B/module/lib"]);
add_case(name => 'opt-short-equals-R',     args => ['-F', "$B/lib", "-R=$B", "$B/module/lib"]);
add_case(name => 'opt-short-equals-O',     args => ['-O=X', '-F', "$B/lib", '-R', $B, "$B/module/lib"]);
add_case(name => 'opt-lower-f',            args => ['-f', "$B/lib", '-R', $B, "$B/module/lib"]);
add_case(name => 'opt-lower-r',            args => ['-F', "$B/lib", '-r', $B, "$B/module/lib"]);
add_case(name => 'opt-lower-o',            args => ['-o', 'X', '-F', "$B/lib", '-R', $B, "$B/module/lib"]);
add_case(name => 'opt-upper-h',            args => ['-H']);
add_case(name => 'opt-long-abbrev-f',      args => ['--f', "$B/lib", '-R', $B, "$B/module/lib"]);
add_case(name => 'opt-long-abbrev-fi',     args => ['--fi=' . "$B/lib", '-R', $B, "$B/module/lib"]);
add_case(name => 'opt-long-abbrev-ro',     args => ['-F', "$B/lib", '--ro', $B, "$B/module/lib"]);
add_case(name => 'opt-long-abbrev-o',      args => ['--o', 'X', '-F', "$B/lib", '-R', $B, "$B/module/lib"]);
add_case(name => 'opt-long-space',         args => ['--final', "$B/lib", '--root', $B, "$B/module/lib"]);
add_case(name => 'opt-long-equals-empty',  args => ['--final=']);
add_case(name => 'opt-long-unknown',       args => ['--nope', "$B/lib"]);
add_case(name => 'opt-long-single-dash',   args => ['-final', "$B/lib"]);
add_case(name => 'opt-value-dash-x',       args => ['-O', '-x', '-F', "$B/lib", '-R', $B, "$B/module/lib"]);
add_case(name => 'opt-value-dash-1',       args => ['-O', '-1', '-F', "$B/lib", '-R', $B, "$B/module/lib"]);
add_case(name => 'opt-value-lone-dash',    args => ['-O', '-', '-F', "$B/lib", '-R', $B, "$B/module/lib"]);
add_case(name => 'opt-value-double-dash',  args => ['-O', '--', '-F', "$B/lib", '-R', $B, "$B/module/lib"]);
add_case(name => 'opt-value-eq-dash',      args => ['--origin=-x', '-F', "$B/lib", '-R', $B, "$B/module/lib"]);
add_case(name => 'opt-missing-value',      args => ['-F']);
add_case(name => 'opt-missing-value-long', args => ['--root']);
add_case(name => 'opt-repeat-F',           args => ['-F', '/zz', '-F', "$B/lib", '-R', $B, "$B/module/lib"]);
add_case(name => 'opt-repeat-R',           args => ['-F', "$B/lib", '-R', '/zz', '-R', $B, "$B/module/lib"]);
add_case(name => 'opt-after-path',         args => ["$B/module/lib", '-F', "$B/lib", '-R', $B]);
add_case(name => 'opt-between-paths',      args => ["$B/a", '-F', "$B/lib", "$B/b", '-R', $B]);
add_case(name => 'opt-around-paths',       args => ['-F', "$B/lib", "$B/a", "$B/b", '-R', $B]);
add_case(name => 'opt-lone-dash-path',     args => [@base, '-']);
add_case(name => 'opt-double-dash-end',    args => [@base, '--']);
add_case(name => 'opt-double-dash-paths',  args => [@base, '--', '-x', '--y', '-1']);
add_case(name => 'opt-double-dash-twice',  args => [@base, '--', 'a', '--', 'b']);
add_case(name => 'opt-double-dash-first',  args => ['--', @base]);
add_case(name => 'opt-negative-number',    args => [@base, '-1']);
add_case(name => 'opt-negative-float',     args => [@base, '-1.5']);
add_case(name => 'opt-unknown-short',      args => ['-Z', "$B/lib"]);
add_case(name => 'opt-unknown-after',      args => [@base, "$B/lib", '-Z']);
add_case(name => 'opt-bundled-FR',         args => ['-FR', "$B/lib", $B]);
add_case(name => 'opt-bundled-hF',         args => ['-hF']);
add_case(name => 'opt-help-short',         args => ['-h'],              help => 1);
add_case(name => 'opt-help-long',          args => ['--help'],          help => 1);
add_case(name => 'opt-help-abbrev',        args => ['--he'],            help => 1);
add_case(name => 'opt-help-with-paths',    args => ['-h', "$B/lib"],    help => 1);
add_case(name => 'opt-help-after-bad',     args => ['-Z', '-h'],        help => 1);
add_case(name => 'opt-help-bundle-F',      args => ['-hF', 'x']);
add_case(name => 'opt-help-bundle-hh',     args => ['-hh']);
add_case(name => 'opt-help-bundle-bad',    args => ['-hZ']);
add_case(name => 'opt-help-bundle-eq',     args => ['-h=x']);
add_case(name => 'opt-help-bundle-missing', args => ['-hR']);
add_case(name => 'opt-help-bundle-dash',   args => ['-hF', '-x']);
add_case(name => 'opt-help-eq',            args => ['--help=x']);
add_case(name => 'opt-empty-F',            args => ['-F', '', '-R', $B, "$B/lib"]);
add_case(name => 'opt-empty-R',            args => ['-F', "$B/lib", '-R', '', "$B/lib"]);
add_case(name => 'opt-empty-O',            args => ['-O', '', @base, "$B/module/lib"]);
add_case(name => 'opt-empty-path',         args => [@base, '']);
add_case(name => 'opt-no-args',            args => [], cwd => $B);

# Defaults and working directories.
add_case(name => 'default-final-cwd',          args => ['-R', $B, "$B/lib"], cwd => "$B/lib");
add_case(name => 'default-final-cwd-symlink',  args => ['-R', $B, "$B/lib"], cwd => "$TMP/link/lib");
add_case(name => 'default-final-cwd-root',     args => ['-R', '/', '/x'], cwd => '/');
add_case(name => 'relative-from-subdir',       args => ['-F', 'lib', '-R', '.', 'lib', 'module/lib'], cwd => $B);
add_case(name => 'relative-from-symlink',      args => ['-F', 'lib', '-R', '.', 'lib', '../other/lib'], cwd => "$TMP/link");
add_case(name => 'relative-dotdot-final',      args => ['-F', '../lib', '-R', '..', '../lib'], cwd => "$B/lib");
add_case(name => 'relative-above-root-cwd',    args => ['-F', '../../x', '-R', '/', '../../y'], cwd => '/');

# Lexical path algebra of posixpath.
add_case(name => 'slash2-path',          args => [@base, '//' . substr($B, 1) . '/module/lib']);
add_case(name => 'slash2-final',         args => ['-F', '//' . substr($B, 1) . '/lib', '-R', $B, "$B/module/lib"]);
add_case(name => 'slash2-root',          args => ['-F', "$B/lib", '-R', '//' . substr($B, 1), "$B/module/lib"]);
add_case(name => 'slash2-origin',        args => ['-O', '//x', @base, "$B/module/lib"]);
add_case(name => 'slash3-path',          args => [@base, '///' . substr($B, 1) . '/module/lib']);
add_case(name => 'slash4-path',          args => [@base, '////' . substr($B, 1) . '/module/lib']);
add_case(name => 'slash-inner',          args => [@base, "$B//module///lib"]);
add_case(name => 'slash2-only',          args => ['-F', '//', '-R', '//', '//']);
add_case(name => 'slash2-dotdot',        args => ['-F', '//a/b', '-R', '//a', '//a/b/../c']);
add_case(name => 'dotdot-above-root',    args => [@base, '/../../x']);
add_case(name => 'dotdot-final-root',    args => ['-F', '/..', '-R', '/', '/x']);
add_case(name => 'dotdot-prefix-name',   args => [@base, "$B/..hidden/lib"]);
add_case(name => 'dotdot-prefix-final',  args => ['-F', "$B/..x", '-R', $B, "$B/lib"]);
add_case(name => 'dotdot-in-root',       args => ['-F', "$B/lib", '-R', "$B/module/..", "$B/lib"]);
add_case(name => 'dot-only-path',        args => [@base, '.'], cwd => $B);
add_case(name => 'dotdot-only-path',     args => [@base, '..'], cwd => "$B/lib");
add_case(name => 'root-only-slash',      args => ['-F', '/', '-R', '/', '/']);
add_case(name => 'newline-in-path',      args => [@base, "$B/a\nb"]);
add_case(name => 'tab-in-path',          args => [@base, "$B/a\tb"]);
add_case(name => 'quote-in-path',        args => [@base, "$B/a'b", "$B/c\"d"]);
add_case(name => 'backslash-in-path',    args => [@base, "$B/a\\b"]);
add_case(name => 'space-trailing',       args => [@base, "$B/lib  "]);
add_case(name => 'colon-roots',          args => ['-F', "$B/lib", '-R', "$B:/x:/y::", "$B/x/lib", '/y/z']);
add_case(name => 'colon-leading-root',   args => ['-F', "$B/lib", '-R', ":$B", "$B/module/lib"]);
# An empty part of the root list is skipped; read as the working directory it would make a directory below
# the working directory but outside the real roots relative, which these lines tell apart.
add_case(name => 'empty-root-leading',   args => ['-F', "$B/lib", '-R', ":$B", "$TMP/other/lib"], cwd => $TMP);
add_case(name => 'empty-root-trailing',  args => ['-F', "$B/lib", '-R', "$B:", "$TMP/other/lib"], cwd => $TMP);
add_case(name => 'empty-root-middle',    args => ['-F', "$B/lib", '-R', "${B}::$TMP/inst", "$TMP/other/lib"], cwd => $TMP);
add_case(name => 'long-path',            args => [@base, "$B/" . ('a' x 5000)]);
add_case(name => 'many-paths',           args => [@base, map { "$B/m$_/lib" } 1 .. 300]);
add_case(name => 'dup-after-normalize',  args => ['-F', 'lib', '-R', $B, 'lib', './lib', 'a/../lib'], cwd => $B);
add_case(name => 'rpath-link-dup',       args => [@base, "$B/lib", "$B/lib/", "$B//lib"]);
add_case(name => 'origin-join-abs',      args => ['-O', '/abs/origin', @base, "$B/module/lib"]);
add_case(name => 'origin-join-empty',    args => ['-O', '', @base, "$B/module/lib"]);
add_case(name => 'origin-join-slash',    args => ['-O', '$ORIGIN/', @base, "$B/module/lib"]);
add_case(name => 'origin-join-slashes',  args => ['-O', '$ORIGIN//', @base, "$B/module/lib"]);
add_case(name => 'origin-join-dotdot',   args => ['-O', '../origin', @base, "$B/module/lib"]);
add_case(name => 'origin-join-outside',  args => ['-O', '$ORIGIN', @base, '/outside/lib']);

# Encodings: valid UTF-8, and bytes that are not UTF-8, which the original passes through
# only in a locale with the surrogateescape handler (LC_ALL=C).
my $E = "\xc3\xa9";
add_case(name => 'utf8-path',            args => [@base, "$B/$E/lib"]);
add_case(name => 'utf8-final',           args => ['-F', "$B/$E", '-R', $B, "$B/$E/lib"]);
add_case(name => 'utf8-root',            args => ['-F', "$B/$E/lib", '-R', "$B/$E", "$B/$E/module/lib"]);
add_case(name => 'utf8-outside',         args => [@base, "/opt/$E\xe4\xb8\xad/lib"]);
add_case(name => 'utf8-origin',          args => ['-O', $E, @base, "$B/module/lib"]);
add_case(name => 'utf8-cwd',             args => ['-R', $B, 'lib'], cwd => "$B/$E");
add_case(name => 'utf8-four-byte',       args => [@base, "$B/\xf0\x9f\x98\x80/lib"]);
add_case(name => 'utf8-combining',       args => [@base, "$B/e\xcc\x81/lib"]);
add_case(name => 'latin1-path-c-locale', args => [@base, "$B/\xe9/lib"],        env => { LC_ALL => 'C' });
add_case(name => 'invalid-utf8-c-locale', args => [@base, "/opt/\xff\xfe/lib"], env => { LC_ALL => 'C' });
add_case(name => 'invalid-origin-c-locale', args => ['-O', "\xe9", @base, "$B/module/lib"], env => { LC_ALL => 'C' });
add_case(name => 'utf8-c-locale',        args => [@base, "$B/$E/lib"],          env => { LC_ALL => 'C' });
add_case(name => 'utf8-posix-locale',    args => [@base, "$B/$E/lib"],          env => { LC_ALL => 'POSIX' });

# Environment.
add_case(name => 'debug-env',            args => [@base, "$B/module/lib"], env => { EPICS_DEBUG_RPATH => 'YES' }, debug => 1);
add_case(name => 'debug-env-lower',      args => [@base, "$B/module/lib"], env => { EPICS_DEBUG_RPATH => 'yes' });
add_case(name => 'debug-env-empty',      args => [@base, "$B/module/lib"], env => { EPICS_DEBUG_RPATH => '' });

# ---- generator -------------------------------------------------------------------------------

# A fixed generator (xorshift32) so a seed gives the same cases under every Perl.
my $state = ($SEED & 0xFFFFFFFF) || 1;
sub rnd {
    my ($n) = @_;
    $state ^= ($state << 13) & 0xFFFFFFFF;
    $state ^= $state >> 17;
    $state ^= ($state << 5) & 0xFFFFFFFF;
    return $state % $n;
}
sub pick { return $_[ rnd(scalar @_) ] }

my @COMPONENTS = ('lib', 'module', 'a', 'b', 'x', '..', '..', '.', 'sp ace', $E, '.hid', 'root', 'root2', 'lib', 'bin');
# Directory names that start with '..' without being the parent directory; they are generated in a family
# of their own, with plain options, because the reference mistakes them for the parent directory.
my @COMPONENTS_DOTDOT = ('lib', 'module', '..data', '..z', '..', '.hid', 'x', '..hidden', 'bin', '...');
my $DOTDOT_FAMILY = 0;

sub gen_path {
    my ($pool) = @_;
    my $path = '';
    my $kind = rnd(10);
    if ($kind < 7 && @{$pool}) {
        $path = pick(@{$pool});
    } else {
        my $lead = rnd(100);
        $path = $lead < 70 ? '/' : $lead < 77 ? '//' : $lead < 80 ? '///' : '';
    }
    for (1 .. rnd(5)) {
        my $component = pick($DOTDOT_FAMILY ? @COMPONENTS_DOTDOT : @COMPONENTS);
        $path .= ($path eq '' || $path =~ m{/\z}) ? $component : "/$component";
    }
    $path .= '/' if rnd(10) == 0;
    $path .= '/.' if rnd(25) == 0;
    return $path;
}

sub gen_option {
    my ($short, $long, $value) = @_;
    my $form = rnd(8);
    return ("-$short", $value) if $DOTDOT_FAMILY || $form == 0 || $form == 1 || $value eq '' || $value =~ /\A-/;
    return ("-$short$value") if $form == 2;
    return ("-$short=$value") if $form == 3;
    return ("--$long", $value) if $form == 4;
    return ("--$long=$value") if $form == 5;
    my $abbrev = substr($long, 0, 1 + rnd(length($long)));
    return $form == 6 ? ("--$abbrev", $value) : ("--$abbrev=$value");
}

sub gen_case {
    my ($index) = @_;
    my $cwd = pick(@CWDS);
    my @pool;
    my @roots;
    for (1 .. rnd(4)) {
        my $root = gen_path([ $cwd, "$TMP/build", '/', $TMP ]);
        push @roots, $root;
        push @pool, $root;
    }
    my $root_text = join(':', map { rnd(12) == 0 ? ":$_" : $_ } @roots);
    $root_text .= ':' if rnd(10) == 0;
    my @words;
    my $final;
    if (rnd(5) != 0) {
        $final = gen_path([ @roots, $cwd ]);
        push @pool, $final;
        push @words, [ gen_option('F', 'final', $final) ];
    }
    push @words, [ gen_option('R', 'root', $root_text) ] if @roots || rnd(4) == 0;
    push @words, [ gen_option('O', 'origin', pick('$ORIGIN', '', '$ORIGIN/', '@loader_path', '/abs', 'rel', '../x', '$ORIGIN//', "$E")) ]
        if rnd(4) == 0;
    push @words, [ gen_option('F', 'final', gen_path([])) ] if rnd(30) == 0;
    push @words, [ pick('-Z', '--nope', '-1', '-', '-final', '-hF', '-F') ] if rnd(25) == 0;
    my @paths;
    for (1 .. rnd(6)) {
        push @paths, gen_path([ @pool, @roots ]);
    }
    @paths = ('--', @paths) if @paths && rnd(15) == 0;
    my @args;
    my $where = rnd(20);
    if ($where < 16) {
        @args = ((map { @{$_} } @words), @paths);
    } elsif ($where < 18) {
        @args = (@paths, (map { @{$_} } @words));
    } else {
        my @options = map { @{$_} } @words;
        my $cut = @options ? rnd(@options + 1) : 0;
        @args = (@options[ 0 .. $cut - 1 ], @paths, @options[ $cut .. $#options ]);
    }
    return { name => sprintf('gen-%04d', $index), args => \@args, cwd => $cwd, env => {}, generated => 1 };
}

push @CASES, gen_case($_) for 1 .. $FUZZ;
{
    $DOTDOT_FAMILY = 1;
    my $family = int($FUZZ / 5);
    my $first = $FUZZ + 1;
    for my $index ($first .. $first + $family - 1) {
        my $case = gen_case($index);
        $case->{name} = sprintf('dotdot-%04d', $index);
        $case->{dotdot_family} = 1;
        push @CASES, $case;
    }
}


# ---- independent property: the printed entries lead to the dependencies ----------------------

# The command line as the tool reads it, for the cases whose options are plain separate words.
sub parse_plain {
    my ($cwd, @args) = @_;
    my ($final, $root, $origin) = ($cwd, '', '$ORIGIN');
    my @paths;
    while (@args) {
        my $word = shift @args;
        if ($word eq '-F') { $final = shift @args }
        elsif ($word eq '-R') { $root = shift @args }
        elsif ($word eq '-O') { $origin = shift @args }
        elsif ($word eq '--') { push @paths, @args; last }
        else { push @paths, $word }
    }
    return ($final, $root, $origin, \@paths);
}

sub norm {
    my ($path) = @_;
    my $lead = $path =~ m{\A//(?!/)} ? '//' : $path =~ m{\A/} ? '/' : '';
    my @out;
    for my $c (split m{/}, $path) {
        next if $c eq '' || $c eq '.';
        if ($c eq '..') { pop @out if @out; next }
        push @out, $c;
    }
    return $lead . join('/', @out);
}
sub absolute {
    my ($path, $cwd) = @_;
    return norm($path) if $path =~ m{\A/};
    return norm($cwd =~ m{/\z} ? "$cwd$path" : "$cwd/$path");
}
sub components { return grep { length } split(m{/}, $_[0]) }
sub same_path { return join('/', components($_[0])) eq join('/', components($_[1])) }
# The path relative to a root, or undef when it is not below it; leading slashes do not count, as in posixpath.relpath.
sub under {
    my ($path, $root) = @_;
    my @p = components($path);
    my @r = components($root);
    return undef if @p < @r;
    for my $i (0 .. $#r) { return undef if $p[$i] ne $r[$i] }
    my @rest = @p[ scalar(@r) .. $#p ];
    return @rest ? join('/', @rest) : '.';
}

# Returns a list of violations of the contract that does not depend on the reference: each entry
# resolves, from the final directory, to the dependency it was printed for, and each dependency has an
# entry.
sub property_applies {
    my ($case) = @_;
    return 0 if grep { /\A-/ && !/\A-[FRO]\z/ } @{ $case->{args} };
    return 1;
}

sub property_violations {
    my ($case, $stdout) = @_;
    return () if grep { /\A-/ && !/\A-[FRO]\z/ } @{ $case->{args} };
    my $cwd = Cwd::abs_path($case->{cwd});
    my ($final, $root, $origin, $paths) = parse_plain($cwd, @{ $case->{args} });
    return () if grep { !defined } ($final, $root, $origin);
    # Not checked: a path the build cannot pass through make (white space).
    return () if grep { /\s/ } ($cwd, $final, $root, @{$paths});
    return () if $origin ne '$ORIGIN';
    my $fdir = absolute($final, $cwd);
    my @roots = map { absolute($_, $cwd) } grep { length } split(/:/, $root, -1);
    my ($froot, $frel);
    for my $r (@roots) { my $rel = under($fdir, $r); if (defined $rel) { ($froot, $frel) = ($r, $rel); last } }
    @roots = () unless defined $froot;
    my %entry = map { $_ => 1 } split ' ', $stdout;
    my @bad;
    for my $path (map { absolute($_, $cwd) } @{$paths}) {
        my $found = 0;
        for my $r (@roots) {
            my $rrel = under($path, $r);
            next unless defined $rrel;
            my $want = $rrel eq '.' ? $froot : "$froot/$rrel";
            for my $e (keys %entry) {
                next unless $e =~ /\A-Wl,-rpath,\$ORIGIN\/(.*)\z/s;
                $found = 1 if same_path(norm($fdir . '/' . $1), $want);
            }
            push @bad, "entry for $path does not resolve from $fdir" unless $found;
            push @bad, "no -rpath-link for $path" unless $entry{"-Wl,-rpath-link,$path"};
            $found = 1;
            last;
        }
        next if $found;
        push @bad, "no absolute entry for $path" unless $entry{"-Wl,-rpath,$path"};
    }
    return @bad;
}

# ---- comparison ------------------------------------------------------------------------------

sub printable {
    my ($text) = @_;
    $text = substr($text, 0, 200) . '...' if length($text) > 200;
    $text =~ s{([^\x20-\x7e])}{sprintf('\\x%02x', ord($1))}ge;
    return $text;
}

my ($checked, $failed, $shown) = (0, 0, 0);
sub write_file_text { my ($path, $text) = @_; open(my $fh, '>', $path) or die "$path: $!\n"; print {$fh} $text; close($fh) or die "$path: $!\n"; }
my %coverage;
my ($dotdot_improved, $dotdot_same, $dotdot_unchecked) = (0, 0, 0);
my $version_dependent = 0;
my %failed_by_name;
my @runners = map { my $perl = $_; ([ "$perl", [ $perl, $PL ] ], [ "$perl -CSD", [ $perl, '-CSD', $PL ] ]) } @PERLS;

for my $case (@CASES) {
    my ($py_status, $py_out, $py_err) = run_command([ $PYTHON, $PY, @{ $case->{args} } ], $case->{cwd}, $case->{env});
    if ($case->{generated}) {
        $coverage{'usage error (status 2)'}++ if $py_status eq '2';
        $coverage{'status 0'}++ if $py_status eq '0';
        $coverage{'entry under a root (-rpath-link)'}++ if $py_out =~ /-rpath-link/;
        $coverage{'relative entry via $ORIGIN'}++ if $py_out =~ /-rpath,[^ ]*\.\./ || $py_out =~ /-rpath,\$ORIGIN\//;
        $coverage{'entry outside every root'}++ if $py_out =~ /-rpath,\// ;
        $coverage{'final not under any root (warning)'}++ if $py_err =~ /Final location/;
        $coverage{'no paths printed'}++ if $py_status eq '0' && $py_out eq "\n";
        $coverage{'several entries'}++ if $py_out =~ /-rpath,.*-rpath,/;
    }
    for my $runner (@runners) {
        my ($label, $command) = @{$runner};
        my ($status, $out, $err) = run_command([ @{$command}, @{ $case->{args} } ], $case->{cwd}, $case->{env});
        $err =~ s/^makeRPath: warning: \$ORIGIN[^\n]*\n//mg;   # the warning about a symbolic link has no counterpart in the reference
        $checked++;
        my @problems;
        if ($status eq '0' && $py_status eq '0') {
            push @problems, map { "property: $_" } property_violations($case, $out);
        }
        # argparse versions differ on a help flag bundled with other letters (-hF, -hZ): the
        # result is counted and not compared.
        if (!$ENV{MAKERPATH_HELP_BUNDLE} && grep { /\A-h./ } @{ $case->{args} }) {
            $version_dependent++;
            next;
        }
        push @problems, "exit status: python $py_status, perl $status" if $status ne $py_status;
        (my $normalized = $out) =~ s/makeRPath\.pl/makeRPath.py/g;
        my $dotdot_name = grep { m{(?:\A|/)\.\.[^/\s]} } @{ $case->{args} };
        $dotdot_name = 1 if $case->{dotdot_family};
        if ($dotdot_name) {
            # The reference takes a directory named '..x' for the parent directory, so its entries and its
            # warning can differ from the script under test, which must satisfy the property instead.
            if ($normalized ne $py_out) { $dotdot_improved++ } else { $dotdot_same++ }
            $dotdot_unchecked++ unless property_applies($case);
        } else {
            if (!($case->{help} && !$ENV{MAKERPATH_HELP_TEXT}) && $normalized ne $py_out) {
                push @problems, 'stdout differs';
            }
            # The messages follow the reference in what they report: a warning that the final directory is
            # outside every root appears in both or in neither, and a usage error names itself on stderr.
            if (!$case->{help} && $status eq $py_status) {
                my $py_warns = $py_err =~ /Final location/ ? 1 : 0;
                my $warns    = $err =~ /warning: final location/ ? 1 : 0;
                push @problems, 'the warning about the final directory differs' if $py_warns != $warns;
                if ($py_status eq '2') {
                    push @problems, 'a usage error lacks its error line or the command line' unless $err =~ /^\S+: error: /m && $err =~ /^\S+: command line: /m;
                }
            }
        }
        next unless @problems;
        $failed++;
        $failed_by_name{ $case->{name} }++;
        next if $shown >= $SHOW;
        $shown++;
        print "MISMATCH $case->{name} under $label: @problems\n";
        print '  args  : ', printable(join(' ', map { "[$_]" } @{ $case->{args} })), "\n";
        print "  cwd   : $case->{cwd}\n";
        print "  python: status $py_status stdout [", printable($py_out), '] stderr [', printable($py_err), "]\n";
        print "  perl  : status $status stdout [", printable($out), '] stderr [', printable($err), "]\n";
    }
}

# What a builder reads in the log: the text of the messages and the exit status, through the make
# statements the build uses to call the script.
{
    my $make_dir = File::Temp::tempdir('make-XXXXXX', DIR => $TMP);
    for my $runner (@runners) {
        my ($label, $command) = @{$runner};
        my $m = join(' ', map { "'$_'" } @{$command});
        for my $scenario (
            [ 'an error ends the build and names the arguments', "--nope -F $TMP/build/lib", 'error: unrecognized arguments: --nope', 'command line: -O \$ORIGIN --nope -F ', 'failed.  Stop.' ],
            [ 'a final directory outside the roots is reported and the build goes on', "-F /elsewhere/lib -R $TMP/build $TMP/build/lib", 'warning: final location /elsewhere/lib is not under any of the roots', 'every entry is an absolute path and the result does not move with the tree', 'ok: -Wl,-rpath,', undef ],
        ) {
            my ($name, $arguments, @expect) = @{$scenario};
            write_file_text("$make_dir/Makefile", "MAKERPATH = $m\nX = \$(shell \$(MAKERPATH) -O '\\\$\$ORIGIN' $arguments) \$(if \$(filter-out 0,\$(.SHELLSTATUS)), \$(error \$(MAKERPATH) failed))\nall: ; \@echo ok: \$(X)\n");
            my ($status, $out, $err) = run_command([ 'make', '-s', '-C', $make_dir ], '/', {});
            my $text = "$out$err";
            my $failing = $name =~ /\Aan error/;
            my @missing = grep { defined $_ && index($text, $_) < 0 } @expect;
            $checked++;
            if (@missing || ($failing ? $status eq '0' : $status ne '0')) {
                $failed++;
                print "MISMATCH make log under $label: $name (status $status, missing: @missing)\n  log: ", printable($text), "\n";
            }
        }
    }
}

# The debug line: written to stderr, first, only when EPICS_DEBUG_RPATH is exactly YES, in the form of the
# reference (the list of the words of the command line).
for my $runner ([ 'python', [ $PYTHON, $PY ] ], @runners) {
    my ($label, $command) = @{$runner};
    for my $value ('YES', 'yes', '') {
        my ($status, undef, $err) = run_command([ @{$command}, @base, "$TMP/build/module/lib" ], '/', { EPICS_DEBUG_RPATH => $value });
        my $shown = $err =~ /\A\[.*'-F'/s ? 1 : 0;
        $checked++;
        if ($status ne '0' || $shown != ($value eq 'YES' ? 1 : 0)) {
            $failed++;
            print "MISMATCH debug line under $label: EPICS_DEBUG_RPATH=[$value] status $status stderr [", printable($err), "]\n";
        }
    }
}

# An error inside the tool, not in the command line: the working directory has been removed. Both end
# with status 1; the script under test names the error and repeats the command line.
for my $runner ([ 'python', [ $PYTHON, $PY ] ], @runners) {
    my ($label, $command) = @{$runner};
    my $gone = File::Temp::tempdir('gone-XXXXXX', DIR => $TMP);
    my ($status, $out, $err) = run_command([ 'sh', '-c', 'cd "$0" && rmdir "$0" && exec "$@"', $gone, @{$command}, '-F', 'lib', 'x' ], '/', {});
    $checked++;
    my $named = $label eq 'python' || ($err =~ /^\S+: error: /m && $err =~ /^\S+: command line: -F lib x$/m);
    if ($status ne '1' || $out ne '' || !$named) {
        $failed++;
        print "MISMATCH error inside the tool under $label: status $status stdout [", printable($out), "] stderr [", printable($err), "]\n";
    }
}

# A write error on stdout must end with a non-zero exit status, so a truncated list is never taken for a
# complete one (the reference exits with 120 there).
for my $runner ([ 'python', [ $PYTHON, $PY ] ], @runners) {
    my ($label, $command) = @{$runner};
    my ($status, undef, $err) = run_command([ 'sh', '-c', 'exec "$@" > /dev/full', 'sh', @{$command}, @base, "$TMP/build/module/lib" ], '/', {});
    $checked++;
    if ($status eq '0') {
        $failed++;
        print "MISMATCH write error under $label: exit status 0 with stdout on a full device\n";
    }
}

printf "cases=%d runs=%d fail=%d (curated=%d generated=%d seed=%d interpreters=%d)\n",
    scalar(@CASES), $checked, $failed, scalar(@CASES) - $FUZZ, $FUZZ, $SEED, scalar(@PERLS);
print "runs with a directory named '..x': $dotdot_same equal to the reference, $dotdot_improved different because the reference takes the name for the parent directory (the property check decides), $dotdot_unchecked of them without a property check\n" if $dotdot_same || $dotdot_improved;
print "runs not compared (help flag bundled with other letters, argparse version dependent): $version_dependent\n" if $version_dependent;
print "generated cases by outcome of the original: ", join('; ', map { "$_ = $coverage{$_}" } sort keys %coverage), "\n" if %coverage;
print "failing cases: ", join(', ', sort keys %failed_by_name), "\n" if %failed_by_name;
print $failed ? "SOME CASES FAIL\n" : "ALL CASES PASS\n";
exit($failed ? 1 : 0);
