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
# Exercises tools/tree-manifest.pl as a subprocess against real filesystem
# changes: a copy with each recorded property changed, refused input, special
# files, an unreadable directory, and the exact bytes written for a fixed tree.
# TREE_MANIFEST_TOOL names another copy of the tool to test.

use strict;
use warnings;

use Cwd ();
use File::Basename ();
use File::Temp ();
use JSON::PP ();
use POSIX ();
use Test::More;

use File::Path ();

# Temporary files are created below work/scratch of the repository (EPICS_ENV_SCRATCH names another
# directory), and each run removes them when it ends. Child commands inherit TMPDIR.
my $SCRATCH_BASE = $ENV{EPICS_ENV_SCRATCH} // File::Basename::dirname(File::Basename::dirname(Cwd::abs_path($0))) . '/work/scratch';
File::Path::make_path($SCRATCH_BASE);
-d $SCRATCH_BASE && -w _ or die "$SCRATCH_BASE: not a writable directory\n";
$ENV{TMPDIR} = $SCRATCH_BASE;

my $TOOL = $ENV{TREE_MANIFEST_TOOL}
    // File::Basename::dirname(Cwd::abs_path($0)) . '/tree-manifest.pl';
my $JSON = JSON::PP->new->canonical;

# Runs the tool as the user would and returns its exit status, stdout and stderr.
sub run_tool {
    my (@args) = @_;
    my $err = File::Temp->new;
    my $pid = open(my $out, '-|');
    defined $pid or die "fork: $!\n";
    if (!$pid) {
        open(STDERR, '>&', $err) or POSIX::_exit(126);
        exec { $^X } $^X, $TOOL, @args or POSIX::_exit(127);
    }
    my $stdout = do { local $/; <$out> };
    close($out);
    my $status = ($? & 127) ? 'signal ' . ($? & 127) : $? >> 8;
    seek($err, 0, 0);
    my $stderr = do { local $/; <$err> };
    return ($status, defined $stdout ? $stdout : '', defined $stderr ? $stderr : '');
}

sub write_file {
    my ($path, $content) = @_;
    open(my $fh, '>:raw', $path) or die "$path: $!\n";
    print {$fh} $content;
    close($fh) or die "$path: $!\n";
    return;
}

sub successful_manifest {
    my ($root, $name) = @_;
    my ($status, $stdout, $stderr) = run_tool($root);
    is($status, 0, "$name: exit status") or diag($stderr);
    return $JSON->decode($stdout);
}

sub encoded {
    my ($manifest) = @_;
    return $JSON->encode($manifest);
}

my $workspace = File::Temp->newdir('tree-manifest-XXXXXX', TMPDIR => 1, CLEANUP => 1);
my $parent    = "$workspace";

# One tree with every recorded kind: an empty directory, a hidden file, a
# symlink to the file and a broken symlink.
sub build_tree {
    my ($root) = @_;
    mkdir($root) or die "$root: $!\n";
    mkdir("$root/empty") or die "$root/empty: $!\n";
    chmod(0755, "$root/empty");
    write_file("$root/.hidden", "before\n");
    chmod(0644, "$root/.hidden");
    symlink('.hidden', "$root/link") or die "link: $!\n";
    symlink('absent', "$root/broken") or die "broken: $!\n";
    return;
}

# Copy and each recorded property.
{
    my $root = "$parent/source tree";
    build_tree($root);
    my $before = successful_manifest($root, 'source tree');
    my $copy   = "$parent/copied tree";
    system { 'cp' } 'cp', '-a', '--', $root, $copy;
    is($? >> 8, 0, 'cp -a copies the tree with symlinks');
    is(encoded(successful_manifest($copy, 'copied tree')), encoded($before), 'a copy has the same manifest');
    my %entries = map { $_->{path} => $_ } @{$before};
    is($entries{empty}{type}, 'directory', 'empty directory is recorded as a directory');
    is($entries{broken}{target}, 'absent', 'a broken symlink keeps its target');

    my @changes = (
        [ 'file content'      => sub { write_file("$copy/.hidden", "after!\n") } ],
        [ 'file mode'         => sub { chmod(0600, "$copy/.hidden") or die "chmod: $!\n" } ],
        [ 'directory mode'    => sub { chmod(0700, "$copy/empty") or die "chmod: $!\n" } ],
        [ 'rename'            => sub { rename("$copy/empty", "$copy/renamed") or die "rename: $!\n" } ],
        [ 'added file'        => sub { write_file("$copy/new", 'new') } ],
        [ 'removed symlink'   => sub { unlink("$copy/link") or die "unlink: $!\n" } ],
        [ 'retargeted symlink' => sub { symlink('renamed', "$copy/link") or die "symlink: $!\n" } ],
        [ 'symlink removed'   => sub { unlink("$copy/broken") or die "unlink: $!\n" } ],
        [ 'symlink to file'   => sub { write_file("$copy/broken", 'absent') } ],
    );
    my $previous = encoded($before);
    for my $change (@changes) {
        my ($label, $apply) = @{$change};
        $apply->();
        my $current = encoded(successful_manifest($copy, $label));
        isnt($current, $previous, "manifest differs after: $label");
        $previous = $current;
    }
    is(encoded(successful_manifest($root, 'source tree after changes')), encoded($before),
       'the source tree manifest is unchanged by the copy edits');
}

# Invalid input produces no manifest and a diagnostic.
{
    my $root = "$parent/invalid tree";
    build_tree($root);
    my %cases = (
        'no arguments'        => [ [], 2 ],
        'missing path'        => [ ["$root/missing"], 1 ],
        'regular file'        => [ ["$root/.hidden"], 1 ],
        'two arguments'       => [ [ $root, $root ], 2 ],
    );
    for my $name (sort keys %cases) {
        my ($args, $expected) = @{ $cases{$name} };
        my ($status, $stdout, $stderr) = run_tool(@{$args});
        is($status, $expected, "$name: exit status");
        is($stdout, '', "$name: no manifest on stdout");
        ok(length $stderr, "$name: a diagnostic on stderr");
    }
    my ($status, $stdout) = run_tool('--help');
    is($status, 0, '--help exits 0');
    like($stdout, qr/tree-manifest\.pl/, '--help names the tool');
}

# A special file is refused.
{
    my $root = "$parent/special tree";
    build_tree($root);
    POSIX::mkfifo("$root/fifo", 0600) or die "mkfifo: $!\n";
    my ($status, $stdout, $stderr) = run_tool($root);
    is($status, 1, 'special file: exit status');
    is($stdout, '', 'special file: no manifest on stdout');
    like($stderr, qr/Unsupported file type/, 'special file: the diagnostic names the cause');
}

# An unreadable directory is not skipped silently.
SKIP: {
    skip 'root bypasses directory permissions', 4 if $> == 0;
    my $root = "$parent/unreadable tree";
    build_tree($root);
    chmod(0, "$root/empty") or die "chmod: $!\n";
    my ($status, $stdout, $stderr) = run_tool($root);
    chmod(0755, "$root/empty");
    is($status, 1, 'unreadable directory: exit status');
    is($stdout, '', 'unreadable directory: no manifest on stdout');
    like($stderr, qr/Permission denied/, 'unreadable directory: the diagnostic names the cause');
    pass('unreadable directory restored');
}

# Exact bytes of a fixed tree: two-space indentation, 0o modes, sorted paths,
# escaped names, and the SHA-256 of the file content.
{
    my $root = "$parent/exact tree";
    mkdir($root) or die "$root: $!\n";
    mkdir("$root/d") or die "$root/d: $!\n";
    chmod(0755, "$root/d");
    write_file("$root/d/f", "x\n");
    chmod(0644, "$root/d/f");
    write_file("$root/caf\xc3\xa9", '');
    chmod(0600, "$root/caf\xc3\xa9");
    write_file("$root/del\x7fchar", '');
    chmod(0644, "$root/del\x7fchar");
    write_file("$root/q\"b", '');
    chmod(0644, "$root/q\"b");
    symlink('d/f', "$root/s") or die "symlink: $!\n";
    my ($status, $stdout) = run_tool($root);
    is($status, 0, 'exact bytes: exit status');
    my $mode_link = sprintf('0o%o', (lstat("$root/s"))[2] & 07777);
    my $expected = <<"JSON";
[
  {
    "path": "caf\\u00e9",
    "mode": "0o600",
    "type": "file",
    "size": 0,
    "sha256": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
  },
  {
    "path": "d",
    "mode": "0o755",
    "type": "directory"
  },
  {
    "path": "d/f",
    "mode": "0o644",
    "type": "file",
    "size": 2,
    "sha256": "73cb3858a687a8494ca3323053016282f3dad39d42cf62ca4e79dda2aac7d9ac"
  },
  {
    "path": "del\\u007fchar",
    "mode": "0o644",
    "type": "file",
    "size": 0,
    "sha256": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
  },
  {
    "path": "q\\"b",
    "mode": "0o644",
    "type": "file",
    "size": 0,
    "sha256": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
  },
  {
    "path": "s",
    "mode": "$mode_link",
    "type": "symlink",
    "target": "d/f"
  }
]
JSON
    is($stdout, $expected, 'exact bytes: the manifest text');
}

done_testing();
