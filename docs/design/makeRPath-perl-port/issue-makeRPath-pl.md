# makeRPath: Perl port from PR #589 regressed `$ORIGIN` rpath generation - analysis, fix, and tests

## Summary

PR #589 ("Remove Python build dependency when `LINKER_USE_RPATH=ORIGIN`", commit `f4c474e`) converted `src/tools/makeRPath.py` to `makeRPath.pl`, and was later reverted in full by `a3d8531` ("Revert PR #589"). The revert commit does not record a reason.

On inspection the Perl port carried three behavioral regressions against the Python original. The most significant one ties the emitted `$ORIGIN` rpath to the *current working directory*, which works against the goal of `LINKER_USE_RPATH=ORIGIN` (a relocatable build tree) and may well have led to the revert.

The Python-to-Perl direction is a natural fit for `src/tools`. `makeRPath` is the only Python script among the Perl build tools there, so porting it both restores consistency with the rest of the directory and removes the Python dependency from the normal (non-doc) build path - the stated goal of PR #589. The unversioned `python` command is fragile (depending on the distribution it may be absent or resolve to Python 2); this can be steered with `PYTHON` in CONFIG_SITE, but narrowing the build's interpreter dependencies toward Perl alone is the more sustainable path. The port adds no new Perl dependency: it uses only the core module `Cwd` and the defined-or operator `//`, which is within EPICS's stated minimum (Perl 5.10.1) and already used in `src/tools` by `makeTestfile.pl` (which likewise declares `use 5.10.1` for it). The blocker in #589 was the regression, not the language choice.

So this issue includes a **corrected port inline for review** and describes its tests, not just a bug report. If the approach looks right I'll open it as a PR.

## Reproduction

Given a relocatable tree:

```
build/lib
build/module/lib
other/lib        # outside the root
```

and the call

```
makeRPath -F build/lib -R build build/lib build/module/lib other/lib
```

**Python (`makeRPath.py`, current):**

```
-Wl,-rpath-link,/.../build/lib -Wl,-rpath,$ORIGIN/. \
-Wl,-rpath-link,/.../build/module/lib -Wl,-rpath,$ORIGIN/../module/lib \
-Wl,-rpath,/.../other/lib
```

**Perl (`makeRPath.pl` from PR #589):**

```
-Wl,-rpath-link,/.../build/lib \
-Wl,-rpath,$ORIGIN/../../../../<cwd-path>/lib \
-Wl,-rpath-link,/.../build/module/lib \
-Wl,-rpath,$ORIGIN/../../../../<cwd-path>/module/lib
```

The Perl `$ORIGIN` paths embed the working directory the build ran from, and the trailing rpath for the out-of-tree `other/lib` is missing entirely.

## Regressions

### A. `$ORIGIN` path computed against the wrong base (cwd leak)

`makeRPath.py` computes the target relative to the *final* location, with both expressed relative to the enclosing root:

```python
# rrel = target relative to root, frel = final relative to root
path = os.path.relpath(rrel, frel)
```

The Perl port used the absolute `$final` as the base instead of the root-relative `$frel`:

```perl
my $rel_path = File::Spec->abs2rel($rrel, $final);
```

Because `$rrel` is a *relative* string, `abs2rel` resolves it against the current working directory, so the result encodes the cwd. The resulting rpath is not relocatable.

### B. Missing `-rpath` for paths outside every root

In Python the final `-rpath` entry is appended unconditionally, once per input path, *outside* the root-matching loop:

```python
for path in args.path:
    path = os.path.abspath(path)
    for root in roots:
        ...
        break
    output['-Wl,-rpath,' + os.path.join(args.origin, path)] = True
```

The Perl port emitted the `-rpath` entry only *inside* the per-root loop, so an input path under no root (e.g. a system library directory) produced no `-rpath` at all.

### C. `Cwd::abs_path` rejects a not-yet-existing `--final`

The Perl port used `Cwd::abs_path`, which requires the path to exist on disk. The `--final` install location frequently does not exist at link time, so this can return `undef`. The Python `os.path.abspath` is purely lexical.

## The fix

The corrected port mirrors the Python original instead of approximating it with `File::Spec`: it parses the command line by the rules of `argparse` for this tool (attached values such as `-F/path`, `--name=value`, abbreviations of the long names, `--`, case-sensitive short options, and values that start with `-` are errors) and computes paths with the functions of Python's `posixpath` (`normpath`, `abspath`, `relpath`, `join`). The three regressions follow from that:

- **A** - the `$ORIGIN`-relative path is `relpath(rrel, frel)`, both sides root-relative, so the working directory cancels.
- **B** - the `-rpath` entry is emitted once per input, outside the root loop, through a `join` that behaves like `os.path.join` (an absolute argument replaces `$ORIGIN`; an empty base or a trailing slash is handled like Python).
- **C** - paths are made absolute lexically, with no `stat`, and `normpath` keeps a leading `//` as `posixpath` does, so a `--final` location that does not exist yet is accepted.

It differs from the original where the original breaks the purpose of the script, which is to decide the search path of shared libraries:

- It writes bytes unchanged whatever `-C` options `PERL` carries. The `PERL` of Base is `perl -CSD`, which encodes the output as UTF-8 a second time, so a build tree under a path with a non-ASCII character got a corrupted run path.
- It exits with status 1 when writing the result fails, also when stdout is closed; the original exits with 120 on a full device and with 0 on a closed stdout.
- It passes bytes that are not UTF-8 through; Python 3 stops with exit status 1 in a UTF-8 locale.
- A directory directly below a root whose name starts with `..`, such as `..data`, gets a relative entry. The original takes any relative path that starts with `..` for the parent directory and prints an absolute entry, which no longer reaches its directory after the tree is moved.
- It warns on stderr when a symbolic link makes a `$ORIGIN` entry reach another directory than the one printed for. The loader resolves `$ORIGIN` to the physical directory of the file, but the entry is computed from the path names alone, so a link to a directory of another depth gives a program that does not load. stdout is unchanged.
- Its messages say what follows: the warning that the final directory is outside every root says that every entry is absolute and the result does not move with the tree, and each error is followed by the command line of the call.

<details>
<summary>Full corrected <code>makeRPath.pl</code></summary>

```perl
#!/usr/bin/env perl
#*************************************************************************
# SPDX-License-Identifier: EPICS
# EPICS BASE is distributed subject to a Software License Agreement found
# in file LICENSE that is included with this distribution.
#*************************************************************************

use strict;
use warnings;
use 5.10.1;   # This script uses the defined-or operator //

use Cwd ();

# Computes -rpath entries for the given paths. It is the Perl counterpart of
# makeRPath.py and keeps its contract: the options of its argparse command
# line, the lexical path algebra of Python's posixpath (normpath, abspath,
# relpath, join), and the stdout text and exit status that the build captures.
#
# Example:
#   target to be installed as: /build/bin/blah
#   post-install will copy as: /install/bin/blah
#
# Need to link against:
#   /install/lib/libA.so
#   /build/lib/libB.so
#   /other/lib/libC.so
#
# Want final result to be:
#   -rpath $ORIGIN/../lib -rpath /other/lib \
#   -rpath-link /build/lib -rpath-link /install/lib

use constant EXIT_USAGE => 2;
use constant EXIT_ERROR => 1;

# stdout and stderr carry the bytes of the path names unchanged, whatever
# input and output layers the interpreter command line selects (-C, as in
# PERL = perl -CSD).
binmode(STDOUT);
binmode(STDERR);
utf8::encode($_) for grep { utf8::is_utf8($_) } @ARGV;

my $PROG = $0;
$PROG =~ s{.*/}{};

# The command line as the build gave it, for the messages: a build log names the failing call only by
# the command, so every error repeats the arguments.
my $COMMAND_LINE = join(' ', @ARGV);
$COMMAND_LINE = substr($COMMAND_LINE, 0, 400) . ' ...' if length($COMMAND_LINE) > 400;

# The options of the command line: long name, short name, takes a value, key.
my @OPTIONS = (
    { long => 'help',   short => 'h', value => 0, key => 'help' },
    { long => 'final',  short => 'F', value => 1, key => 'final' },
    { long => 'root',   short => 'R', value => 1, key => 'root' },
    { long => 'origin', short => 'O', value => 1, key => 'origin' },
);

my $USAGE = "usage: $PROG [-h] [-F FINAL] [-R ROOT] [-O ORIGIN] [path ...]\n";

# Python repr() of a string, for the diagnostic text. Printable ASCII and
# bytes of multi-byte characters pass through; control characters are escaped.
sub py_repr {
    my ($s) = @_;
    my $quote = ($s =~ /'/ && $s !~ /"/) ? '"' : "'";
    my %named = ("\\" => '\\\\', "\n" => '\n', "\r" => '\r', "\t" => '\t');
    $s =~ s{([\\\n\r\t\x00-\x1f\x7f]|\Q$quote\E)}{
        exists $named{$1} ? $named{$1} : ($1 eq $quote ? "\\$quote" : sprintf('\\x%02x', ord($1)))
    }ge;
    return $quote . $s . $quote;
}

sub usage_error {
    my ($message) = @_;
    print STDERR $USAGE, "$PROG: error: $message\n", "$PROG: command line: $COMMAND_LINE\n";
    exit EXIT_USAGE;
}

# A command-line word that argparse takes for an option flag: it starts with
# '-', is not a lone '-', and is not a negative number (no option here looks
# like one).
sub looks_like_option {
    my ($word) = @_;
    return 0 if length($word) < 2 || substr($word, 0, 1) ne '-';
    return 0 if $word =~ /\A-\d+\z|\A-\d*\.\d+\z/;
    return 1;
}

# Finds the option a word names: the exact long or short name, a unique prefix
# of a long name, or a short name with its value attached (-Fvalue, -F=value).
# Returns (option, explicit value or undef, value given after '='), or (undef) when no
# option matches.
sub match_option {
    my ($word) = @_;
    if ($word =~ /\A--([^=]*)(?:=(.*))?\z/s) {
        my ($name, $explicit) = ($1, $2);
        my @found = grep { index($_->{long}, $name) == 0 } @OPTIONS;
        my @exact = grep { $_->{long} eq $name } @OPTIONS;
        @found = @exact if @exact == 1;
        usage_error("ambiguous option: --$name could match " . join(', ', map { "--$_->{long}" } @found))
            if @found > 1;
        return @found == 1 ? ($found[0], $explicit) : (undef, undef);
    }
    if ($word =~ /\A-([A-Za-z])(.*)\z/s) {
        my ($letter, $rest) = ($1, $2);
        my ($option) = grep { $_->{short} eq $letter } @OPTIONS;
        return (undef, undef) unless $option;
        return ($option, undef) if $rest eq '';
        my $attached = $rest =~ s/\A=// ? 1 : 0;
        return ($option, $rest, $attached);
    }
    return (undef, undef);
}

# Parses the command line the way argparse does for this tool: options and
# their values in any order before, between, or after one group of paths, '--'
# ends the options, and a path that follows an option after the first path
# group is an unrecognized argument.
sub parse_command_line {
    my (@words) = @_;
    my %opt = (final => undef, root => '', origin => '$ORIGIN');
    my (@paths, @extra);
    my $path_state = 'open';
    my $only_paths = 0;
    my $pending_help = 0;
    while (@words) {
        my $word = shift @words;
        if (!$only_paths && $word eq '--') {
            $only_paths = 1;
            next;
        }
        if (!$only_paths && looks_like_option($word)) {
            my ($option, $explicit, $attached) = match_option($word);
            if (!$option) {
                push @extra, $word;
                next;
            }
            $path_state = 'closed' if $path_state eq 'paths';
            if (!$option->{value}) {
                # -h takes no value; a short flag may be followed by more short
                # options in the same word (-hF value), and the help is shown
                # once the whole word has been read without error.
                if (defined $explicit && $explicit ne '') {
                    usage_error("argument -$option->{short}/--$option->{long}: ignored explicit argument '$explicit'")
                        if $word =~ /\A--/ || $attached;
                    print_help() unless grep { $_->{short} eq substr($explicit, 0, 1) } @OPTIONS;
                    $pending_help = 1;
                    unshift @words, "-$explicit";
                    next;
                }
                print_help();
            }
            my $value = $explicit;
            if (!defined $value) {
                my $next = shift @words;
                usage_error("argument -$option->{short}/--$option->{long}: expected one argument")
                    if !defined $next || ($next eq '--') || looks_like_option($next);
                $value = $next;
            }
            $opt{ $option->{key} } = $value;
            print_help() if $pending_help;
            next;
        }
        if ($path_state eq 'closed') {
            push @extra, $word;
        } else {
            $path_state = 'paths';
            push @paths, $word;
        }
    }
    usage_error('unrecognized arguments: ' . join(' ', @extra)) if @extra;
    return (\%opt, \@paths);
}

sub print_help {
    print $USAGE, "\n",
        "Compute and output -rpath entries for each of the given paths. Paths under\n",
        "--root will be computed as relative to --final .\n\n",
        "positional arguments:\n  path\n\noptions:\n",
        "  -h, --help           show this help message and exit\n",
        "  -F, --final FINAL    Final install location for ELF file\n",
        "  -R, --root ROOT      Root(s) of relocatable tree. Separate with :\n",
        "  -O, --origin ORIGIN\n\n",
        "eg. A library to be placed in /build/lib and linked against libraries in\n",
        "'/build/lib', '/build/module/lib', and '/other/lib' would pass: \"$PROG\n",
        "-F /build/lib -R /build /build/lib /build/module/lib /other/lib\" which prints\n",
        "\"-Wl,-rpath,\$ORIGIN/. -Wl,-rpath,\$ORIGIN/../module/lib -Wl,-rpath,/other/lib\"\n";
    exit 0;
}

# posixpath.join(a, b)
sub py_join {
    my ($a, $b) = @_;
    return $b if substr($b, 0, 1) eq '/';
    return $a . $b if $a eq '' || substr($a, -1) eq '/';
    return "$a/$b";
}

# posixpath.normpath(path): collapses '.', '' and '..' lexically and keeps a
# leading '//' (exactly two slashes) as POSIX allows.
sub py_normpath {
    my ($path) = @_;
    return '.' if $path eq '';
    my $initial = 0;
    $initial = 1 if substr($path, 0, 1) eq '/';
    $initial = 2 if $path =~ m{\A//(?!/)};
    my @comps;
    for my $comp (split m{/}, $path, -1) {
        next if $comp eq '' || $comp eq '.';
        if ($comp ne '..' || (!$initial && !@comps) || (@comps && $comps[-1] eq '..')) {
            push @comps, $comp;
        } elsif (@comps) {
            pop @comps;
        }
    }
    my $result = join('/', @comps);
    $result = ('/' x $initial) . $result if $initial;
    return length($result) ? $result : '.';
}

# posixpath.abspath(path): relative to the current directory, no filesystem
# lookup of the path itself.
sub py_abspath {
    my ($path) = @_;
    if (substr($path, 0, 1) ne '/') {
        my $cwd = Cwd::getcwd();
        defined $cwd or die "getcwd: $!\n";
        utf8::encode($cwd) if utf8::is_utf8($cwd);
        $path = py_join($cwd, $path);
    }
    return py_normpath($path);
}

# posixpath.relpath(path, start)
sub py_relpath {
    my ($path, $start) = @_;
    length($path) or die "no path specified\n";
    my @start_list = grep { length } split(m{/}, py_abspath($start), -1);
    my @path_list  = grep { length } split(m{/}, py_abspath($path), -1);
    my $common = 0;
    my $limit = @start_list < @path_list ? scalar(@start_list) : scalar(@path_list);
    $common++ while $common < $limit && $start_list[$common] eq $path_list[$common];
    my @rel = (('..') x (@start_list - $common), @path_list[ $common .. $#path_list ]);
    return '.' unless @rel;
    return join('/', @rel);
}

# The physical form of an absolute path: symbolic links are resolved in the part that exists, and the
# rest, which a later install creates, is kept as written.
sub physical_path {
    my ($path) = @_;
    my $rest = '';
    my $head = $path;
    while ($head ne '/' && !-e $head) {
        $head =~ s{/([^/]*)\z}{};
        $rest = "/$1$rest";
        $head = '/' if $head eq '';
    }
    my $real = Cwd::abs_path($head);
    return $path unless defined $real;
    return py_normpath($real . $rest);
}

# The text of $ORIGIN-relative entries is computed on the path names alone, but the dynamic loader
# resolves $ORIGIN to the physical directory of the file and walks '..' through the file system. When a
# symbolic link in either path changes the depth, the entry reaches another directory. Warn on stderr
# when the entry, followed from the physical final directory, does not reach the dependency directory.
sub warn_if_entry_misses {
    my ($final, $dependency, $relative) = @_;
    return if grep { /\n/ } ($final, $dependency, $relative);   # not a name the file system test accepts
    my $wanted = physical_path($dependency);
    my $start  = physical_path($final);
    my $reached = Cwd::abs_path("$start/$relative");
    return if defined $reached && $reached eq $wanted;
    return if !defined $reached && !-e $wanted;
    print STDERR "makeRPath: warning: \$ORIGIN/$relative from $final reaches " .
        (defined $reached ? $reached : 'no directory') . ", not $dependency; a symbolic link in either path changes the depth\n";
    return;
}

# True when a relative path leaves its base: it is '..' or starts with '../'. A directory whose name
# merely starts with '..', such as '..data', is inside the base.
sub leaves_base {
    my ($relative) = @_;
    return $relative eq '..' || substr($relative, 0, 3) eq '../';
}

sub main {
    my @argv = @_;
    warn '[' . join(', ', map { py_repr($_) } ($0, @argv)) . ']'
        if ($ENV{EPICS_DEBUG_RPATH} // '') eq 'YES';
    my ($opt, $paths) = parse_command_line(@argv);
    my $cwd = Cwd::getcwd();
    defined $cwd or die "getcwd: $!\n";
    utf8::encode($cwd) if utf8::is_utf8($cwd);
    my $final  = defined $opt->{final} ? $opt->{final} : $cwd;
    my $origin = $opt->{origin};

    my $fdir  = py_abspath($final);
    my @roots = map { py_abspath($_) } grep { length } split(/:/, $opt->{root}, -1);

    # Find the root which contains the final location.
    my ($froot, $frel);
    for my $root (@roots) {
        my $relative = py_relpath($fdir, $root);
        if (!leaves_base($relative)) {
            ($froot, $frel) = ($root, $relative);
            last;
        }
    }
    if (!defined $froot) {
        print STDERR "makeRPath: warning: final location $fdir is not under " .
            (@roots ? 'any of the roots [' . join(', ', map { py_repr($_) } @roots) . ']' : 'a root (none is given)') .
            "; every entry is an absolute path and the result does not move with the tree\n";
        @roots = ();   # skip $ORIGIN handling below
    }

    my (@output, %seen);
    my $emit = sub {
        my ($entry) = @_;
        push @output, $entry unless $seen{$entry}++;
    };
    for my $path (@{$paths}) {
        $path = py_abspath($path);
        for my $root (@roots) {
            my $rrel = py_relpath($path, $root);
            next if leaves_base($rrel);

            # Some older binutils don't handle $ORIGIN correctly when locating
            # dependencies of libraries, so also provide the absolute path for
            # internal use by 'ld' only.
            $emit->("-Wl,-rpath-link,$path");

            # frel is the final location relative to the enclosing root and
            # rrel is the target relative to the same root.
            my $original = $path;
            $path = py_relpath($rrel, $frel);
            warn_if_entry_misses($fdir, $original, $path);
            last;
        }
        $emit->('-Wl,-rpath,' . py_join($origin, $path));
    }
    print join(' ', @output), "\n" or die "write error: $!\n";
    close(STDOUT) or die "write error: $!\n";
    return 0;
}

my $status;
eval {
    $status = main(@ARGV);
    1;
} or do {
    my $error = $@;
    print STDERR "$PROG: error: $error", "$PROG: command line: $COMMAND_LINE\n";
    $status = EXIT_ERROR;
};
exit $status;

__END__

=head1 NAME

makeRPath.pl - Compute and output -rpath entries for given paths

=head1 SYNOPSIS

makeRPath.pl [-h] [-F FINAL] [-R ROOT] [-O ORIGIN] [path ...]

=head1 DESCRIPTION

Computes and outputs -rpath entries for each of the given paths.
Paths under C<--root> are computed as relative to C<--final>. The command
line, the path computation, and the output follow C<makeRPath.py>.

=head1 OPTIONS

    -h, --help      Display help and exit
    -F, --final     Final install location for ELF file (default: the current directory)
    -R, --root      Root(s) of relocatable tree, separated by ':'
    -O, --origin    Origin path (default: '$ORIGIN')

=head1 EXAMPLE

A library to be placed in C</build/lib> and linked against libraries in
C</build/lib>, C</build/module/lib>, and C</other/lib> would pass

  makeRPath.pl -F /build/lib -R /build /build/lib /build/module/lib /other/lib

which prints

  -Wl,-rpath-link,/build/lib -Wl,-rpath,$ORIGIN/. -Wl,-rpath-link,/build/module/lib -Wl,-rpath,$ORIGIN/../module/lib -Wl,-rpath,/other/lib

=cut
```

</details>

## Regression test

Three tests run the original and the port on the same input, and the port under every Perl available, with and without `-CSD`:

- A **comparison** runs chosen and generated command lines (a fixed seed gives the same lines under every Perl) and requires the same exit status and stdout bytes, apart from the differences above. It also checks, without the original, that every printed entry leads from the final directory to the dependency it was printed for, that a write error exits with a non-zero status, and that the build log shows the error with the command line or the warning with its consequence when the script is called by the `make` statements of the build.
- A **link test** links two shared libraries and a program with the printed flags in six layouts, including a dependency outside the root, symbolic links to a module directory of the same and of another depth, and a directory named `..data`, and has the dynamic loader resolve the program without `LD_LIBRARY_PATH` in place, by its build name, and after the whole tree is moved.
- A **replay** runs the `makeRPath` calls recorded from a Base build through both scripts.

Results with the port: 115 chosen and 3000 generated command lines, and 600 more with names that start with `..`, show no difference to the original apart from the listed ones, under Perl 5.10.1, 5.26.3, and 5.40.1, on Debian 13 and Rocky Linux 8.10. The link test passes in all six layouts. Base R7.0.10 built with the port and with a failing `python` first on `PATH` installs ELF files whose `RUNPATH` and `NEEDED` entries equal those of a build with `makeRPath.py` (24 files on Debian 13, 40 on Rocky Linux 8.10), and the 139 calls of that build give the same text. Thirty of 31 scratch mutations of the port are caught by the tests; the one that is not changes code that cannot run.

## Notes

The corrected port is included inline so the approach can be reviewed here before any merge; the three tests are not inline because of their size and would go with a PR, which also enables line-level review and CI. Points worth a maintainer's call:

- The differences from the original listed under "The fix" go beyond a faithful port. Each has a test; if you prefer a byte-for-byte port, they can be removed one by one.
- The `-O` origin edge cases (empty, trailing slash) never arise from the build call site (always `-O '$ORIGIN'`), but `os.path.join` semantics are matched for completeness; say if you would rather treat those as out of scope.
- The help text equals that of Python 3.13 and the usage errors follow `argparse`; the wording of the other messages is the port's own.
