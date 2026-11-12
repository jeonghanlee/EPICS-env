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
# Exercises the shipped trash helper tools/test-trash.bash and the scripts that
# call it on real temporary files: versions of one file, directories, fifos,
# symlinks, refused paths, a failing destination, the loader test wrapper, the
# copy and run helpers, the guest round trip, and the exit trap of the caPutLog
# verification. Each case keeps its own directory and the output of every bash
# call under one evidence directory that is not removed.

use strict;
use warnings;

use Cwd ();
use Fcntl qw(:mode);
use File::Basename ();
use File::Find ();
use File::Path ();
use File::Temp ();
use POSIX ();
use Test::More;

my $REPO     = File::Basename::dirname(File::Basename::dirname(Cwd::abs_path($0)));
my $EVIDENCE = File::Temp::tempdir('epics-test-trash-XXXXXX', TMPDIR => 1);
my $HELPER   = "$REPO/tools/test-trash.bash";
diag("Evidence retained in $EVIDENCE");

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

# Starts a case: its own directory below the evidence directory.
sub new_case {
    my ($name) = @_;
    my $root = "$EVIDENCE/$name";
    mkdir($root) or die "$root: $!\n";
    return { root => $root, trash => "$root/trash", calls => 0 };
}

# Runs bash with the arguments in the case directory, keeps the output of the
# call as call-N.out and call-N.err, and returns the status, stdout and stderr.
sub run_bash {
    my ($case, $args, $env, $cwd) = @_;
    $case->{calls}++;
    my $base = "$case->{root}/call-$case->{calls}";
    my $pid  = fork();
    defined $pid or die "fork: $!\n";
    if (!$pid) {
        chdir(defined $cwd ? $cwd : $case->{root}) or POSIX::_exit(126);
        open(STDOUT, '>', "$base.out") or POSIX::_exit(126);
        open(STDERR, '>', "$base.err") or POSIX::_exit(126);
        $ENV{$_} = $env->{$_} for keys %{ $env || {} };
        exec { 'bash' } 'bash', @{$args} or POSIX::_exit(127);
    }
    waitpid($pid, 0);
    my $status = ($? & 127) ? 'signal ' . ($? & 127) : $? >> 8;
    return ($status, slurp("$base.out"), slurp("$base.err"));
}

sub move {
    my ($case, $paths, $trash) = @_;
    return run_bash($case, [
        '-c', 'source "$1"; shift; test_move_to_trash "$@"',
        'trash-test', $HELPER, (defined $trash ? $trash : $case->{trash}), @{$paths},
    ]);
}

# Returns the preserved entries of a trash directory, sorted by their path.
sub entries {
    my ($trash) = @_;
    opendir(my $dh, $trash) or return ();
    my @found = map { "$trash/$_/entry" } sort grep { $_ ne '.' && $_ ne '..' && lstat("$trash/$_/entry") } readdir($dh);
    closedir($dh);
    return @found;
}

sub is_dir_entry { my ($p) = @_; my @s = lstat($p); return @s && S_ISDIR($s[2]) }
sub is_fifo_entry { my ($p) = @_; my @s = lstat($p); return @s && S_ISFIFO($s[2]) }
sub is_file_entry { my ($p) = @_; my @s = lstat($p); return @s && S_ISREG($s[2]) }

# Case 1: versions of one path are preserved without overwriting.
{
    my $case = new_case('test_file_versions_are_preserved_without_overwrite');
    my $path = "$case->{root}/result with spaces.log";
    my @contents = ("first\0result", 'second result', 'third result');
    for my $content (@contents) {
        spew($path, $content);
        my ($status, $stdout, $stderr) = move($case, [$path]);
        is($status, 0, 'versions: move exits 0') or diag($stderr);
        is($stdout, '', 'versions: move prints nothing');
        ok(!-e $path, 'versions: the source is gone');
    }
    my @entries = entries($case->{trash});
    is_deeply([ sort map { slurp($_) } @entries ], [ sort @contents ], 'versions: every content is preserved');
    for my $entry (@entries) {
        my $dir = File::Basename::dirname($entry);
        like(File::Basename::basename($dir), qr/\A\d{8}T\d{6}Z\.[A-Za-z0-9]+\z/, 'versions: entry directory name');
        is(slurp("$dir/source-path"), "$path\n", 'versions: source-path records the original path');
    }
}

# Case 2: a directory and a fifo are preserved.
{
    my $case = new_case('test_directory_and_fifo_are_preserved');
    my $directory = "$case->{root}/tree";
    mkdir($directory) or die "$directory: $!\n";
    spew("$directory/data", 'saved tree');
    my $fifo = "$case->{root}/input.fifo";
    POSIX::mkfifo($fifo, 0600) or die "mkfifo: $!\n";
    my ($status, undef, $stderr) = move($case, [ $directory, $fifo ]);
    is($status, 0, 'directory and fifo: move exits 0') or diag($stderr);
    ok(!-e $directory, 'directory and fifo: the directory is gone');
    ok(!-e $fifo, 'directory and fifo: the fifo is gone');
    my @entries = entries($case->{trash});
    ok((grep { is_dir_entry($_) && -f "$_/data" && slurp("$_/data") eq 'saved tree' } @entries) ? 1 : 0,
       'directory and fifo: the directory content is preserved');
    ok((grep { is_fifo_entry($_) } @entries) ? 1 : 0, 'directory and fifo: the fifo is preserved');
}

# Case 3: symlinks move and their targets stay.
{
    my $case = new_case('test_symlinks_move_without_moving_their_targets');
    my $target = "$case->{root}/target";
    spew($target, 'target stays');
    my ($link, $broken) = ("$case->{root}/link", "$case->{root}/broken");
    symlink($target, $link) or die "symlink: $!\n";
    symlink("$case->{root}/absent", $broken) or die "symlink: $!\n";
    my ($status, undef, $stderr) = move($case, [ $link, $broken ]);
    is($status, 0, 'symlinks: move exits 0') or diag($stderr);
    ok(!-l $link, 'symlinks: the link is gone');
    ok(!-l $broken, 'symlinks: the broken link is gone');
    is(slurp($target), 'target stays', 'symlinks: the target stays');
    is_deeply([ sort map { readlink($_) } entries($case->{trash}) ], [ sort($target, "$case->{root}/absent") ],
              'symlinks: the preserved links keep their targets');
}

# Case 4: a missing path is a no-op.
{
    my $case = new_case('test_missing_path_is_a_noop');
    my ($status, undef, $stderr) = move($case, ["$case->{root}/absent"]);
    is($status, 0, 'missing path: move exits 0') or diag($stderr);
    ok(!-e $case->{trash}, 'missing path: no trash directory is created');
}

# Case 5: unsafe paths and a nested trash are refused.
{
    my $case = new_case('test_unsafe_paths_and_nested_trash_are_refused');
    my $source = "$case->{root}/source";
    mkdir($source) or die "$source: $!\n";
    spew("$source/evidence", 'keep');
    for my $path ('', '/', '.', '..') {
        my ($status) = move($case, [$path]);
        isnt($status, 0, "unsafe path '$path' is refused");
    }
    my ($status) = move($case, [$source], "$source/trash");
    isnt($status, 0, 'nested trash is refused');
    is(slurp("$source/evidence"), 'keep', 'nested trash: the evidence stays');
    ok(!-e "$source/trash", 'nested trash: no trash directory is created');
    my $alias = "$case->{root}/alias";
    symlink($source, $alias) or die "symlink: $!\n";
    ($status) = move($case, [$source], "$alias/trash");
    isnt($status, 0, 'a trash behind a symlink into the source is refused');
}

# Case 6: a destination failure keeps the source.
{
    my $case = new_case('test_destination_failure_keeps_source');
    spew($case->{trash}, 'not a directory');
    my $source = "$case->{root}/evidence";
    spew($source, 'keep');
    my ($status) = move($case, [$source]);
    isnt($status, 0, 'destination failure: move fails');
    is(slurp($source), 'keep', 'destination failure: the source stays');
    is(slurp($case->{trash}), 'not a directory', 'destination failure: the blocker is unchanged');
}

# Case 7: the loader test wrapper stops after a preservation failure.
{
    my $case = new_case('test_loader_wrapper_stops_after_preservation_failure');
    my $out = "$case->{root}/out";
    mkdir($out) or die "$out: $!\n";
    spew("$out/trash", 'blocked');
    my $source = "$case->{root}/evidence";
    spew($source, 'keep');
    my $marker = "$case->{root}/continued";
    my ($status) = run_bash($case, [
        '-c', 'source "$1"; IOCSH_TEST_OUT="$2"; iocsh_test_trash "$3"; printf continued > "$4"',
        'wrapper-test', "$REPO/examples/iocsh/tests/common.bash", $out, $source, $marker,
    ]);
    is($status, 2, 'loader wrapper: exit status 2');
    ok(!-e $marker, 'loader wrapper: the caller does not continue');
    is(slurp($source), 'keep', 'loader wrapper: the source stays');
}

# Case 8: the copy helper preserves the previous copy and keeps stdout clean.
{
    my $case = new_case('test_copy_tree_preserves_previous_copy_and_stdout');
    my $out  = "$case->{root}/out";
    my $dest = "$out/copies/with space";
    File::Path::make_path($dest);
    spew("$dest/previous", 'prior copy');
    my ($status, $stdout, $stderr) = run_bash($case, [
        '-c', 'source "$1"; IOCSH_TEST_OUT="$2"; IOCSH_TEST_TREE="$3"; iocsh_test_copy_tree "$4"',
        'copy-test', "$REPO/examples/iocsh/tests/common.bash", $out, "$REPO/commonIocsh", $dest,
    ]);
    is($status, 0, 'copy tree: exit status') or diag($stderr);
    is($stdout, "$dest/commonIocsh", 'copy tree: stdout is the copy path only');
    my @entries = entries("$out/trash");
    is(slurp("$entries[0]/previous"), 'prior copy', 'copy tree: the previous copy is preserved');
    my @sources;
    File::Find::find({ no_chdir => 1, wanted => sub { push @sources, $File::Find::name if -f $_ && /\.iocsh\z/ } },
                     "$REPO/commonIocsh");
    ok(scalar @sources > 0, 'copy tree: the source tree holds .iocsh files');
    for my $source (sort @sources) {
        (my $relative = $source) =~ s{\A\Q$REPO/commonIocsh/\E}{};
        is(slurp("$dest/commonIocsh/$relative"), slurp($source), "copy tree: $relative is identical");
    }
}

# Case 9: the runner archives logs and copies before it fails.
{
    my $case = new_case('test_runner_archives_logs_and_copies_before_failure');
    my $out  = "$case->{root}/out";
    File::Path::make_path("$out/copies");
    spew("$out/copies/evidence", 'prior copy');
    spew("$out/no-such-test.log", 'prior log');
    my ($status, $stdout, $stderr) = run_bash($case, [ "$REPO/examples/iocsh/tests/run_all.bash", 'no-such-test' ], {
        IOCSH_TEST_OUT => $out, IOCSH_TEST_REPO => $REPO, IOCSH_TEST_TREE => "$case->{root}/absent-tree",
    });
    is($status, 1, 'runner: exit status 1') or diag($stderr);
    like($stderr, qr/no such script/, 'runner: stderr names the cause');
    like($stdout, qr/run done/, 'runner: stdout reports the run end');
    ok(!-e "$out/copies", 'runner: the copies directory is archived');
    my @entries = entries("$out/trash");
    ok((grep { is_dir_entry($_) && -f "$_/evidence" && slurp("$_/evidence") eq 'prior copy' } @entries) ? 1 : 0,
       'runner: the previous copies are preserved');
    ok((grep { is_file_entry($_) && slurp($_) eq 'prior log' } @entries) ? 1 : 0, 'runner: the previous log is preserved');
}

# Case 10: the guest round trip archives its clone before a real checkout failure.
{
    my $case = new_case('test_roundtrip_archives_clone_before_real_checkout_failure');
    my $old  = "$case->{root}/EPICS-env-roundtrip";
    mkdir($old) or die "$old: $!\n";
    spew("$old/evidence", 'prior roundtrip');
    my ($status, undef, $stderr) = run_bash($case, [
        "$REPO/tools/module-check/guest-roundtrip.bash", 'no-such-test-trash-commit', '', $case->{root},
    ], { EPICS_ENV_REPO => $REPO });
    is($status, 1, 'round trip: exit status 1') or diag($stderr);
    ok(-d "$old/.git", 'round trip: a fresh clone replaces the archived directory') or diag($stderr);
    like($stderr, qr/no-such-test-trash-commit/, 'round trip: stderr names the missing revision');
    my @entries = entries($case->{trash});
    is(slurp("$entries[0]/evidence"), 'prior roundtrip', 'round trip: the previous clone is preserved');
}

# Case 11: the caPutLog verification keeps a failed workspace in the trash.
{
    my $case = new_case('test_common_iocsh_exit_trap_preserves_failed_workspace');
    my ($status, $stdout, $stderr) = run_bash($case, [ "$REPO/examples/commonIocsh/tests/verify_caputlog.sh" ], {
        ARCH => 'test-trash-no-binary', DIST_TOP => "$case->{root}/no-tree",
        TC32SIM => "$case->{root}/no-ioc", COMMONIOCSH_TEST_TRASH => $case->{trash},
        KEEP_WORKSPACE => '0', TMPDIR => $case->{root},
    });
    is($status, 1, 'exit trap: exit status 1') or diag($stderr);
    like($stdout, qr/IOC shell not found/, 'exit trap: stdout names the cause');
    my @entries = entries($case->{trash});
    is(scalar @entries, 1, 'exit trap: one workspace is preserved');
    ok(is_dir_entry($entries[0]), 'exit trap: the preserved workspace is a directory');
    my $original = slurp(File::Basename::dirname($entries[0]) . '/source-path');
    $original =~ s/\s+\z//;
    ok(!-e $original, 'exit trap: the original workspace is gone');
}

# Case 12: a trash directory that exists but takes no new entry fails the move and keeps the source.
SKIP: {
    skip 'permission checks do not apply to root', 4 if $> == 0;
    my $case = new_case('test_unwritable_trash_keeps_source');
    mkdir($case->{trash}) or die "$case->{trash}: $!\n";
    chmod(0555, $case->{trash}) or die "chmod: $!\n";
    my $source = "$case->{root}/evidence";
    spew($source, 'keep');
    my ($status, undef, $stderr) = move($case, [$source]);
    chmod(0755, $case->{trash});
    isnt($status, 0, 'unwritable trash: move fails');
    is(slurp($source), 'keep', 'unwritable trash: the source stays');
    is(scalar(my @made = entries($case->{trash})), 0, 'unwritable trash: no entry is created');
    ok(length $stderr, 'unwritable trash: a diagnostic on stderr');
}

# Case 13: the names . and .. are refused by name, with a trash outside the source, so the
# nested-trash rule cannot be the reason.
{
    my $case    = new_case('test_dot_names_are_refused_by_name');
    my $sandbox = "$case->{root}/sandbox";
    my $inner   = "$sandbox/inner";
    mkdir($sandbox) or die "$sandbox: $!\n";
    mkdir($inner) or die "$inner: $!\n";
    spew("$sandbox/keep", 'keep');
    my $trash = "$case->{root}/trash-outside";
    for my $path ('.', '..') {
        my ($status, undef, $stderr) = run_bash($case, [
            '-c', 'source "$1"; shift; test_move_to_trash "$@"', 'trash-test', $HELPER, $trash, $path,
        ], undef, $inner);
        isnt($status, 0, "'$path' is refused with a trash outside the source");
        like($stderr, qr/refusing unsafe path/, "'$path' is refused by name, not by the nested-trash rule");
        ok((-d $inner && -f "$sandbox/keep") ? 1 : 0, "'$path': the directories stay");
        ok(!-e $trash, "'$path': no trash directory is created");
    }
}

done_testing();
