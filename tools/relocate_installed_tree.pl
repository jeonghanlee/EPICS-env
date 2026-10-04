#!/usr/bin/env perl
# Prepares and relocates the managed text metadata of a native EPICS tree.
#
# Installation writers run through --write, which keeps verified snapshots of
# the installed metadata across the upstream make and finalizes the inventory.
# An installed copy inspects a tree with --check and refreshes it after a move
# with --apply. Requires Perl 5.26 or later with JSON::PP; SHA-256 uses
# Digest::SHA when installed and the coreutils sha256sum command otherwise.

use strict;
use warnings;

use B ();
use Cwd qw(abs_path);
use Fcntl qw(:DEFAULT :flock);
use File::Basename qw(basename dirname);
use File::Glob qw(bsd_glob);
use File::Path qw(make_path);
use File::Spec;
use File::Temp qw(tempfile);
use Getopt::Long qw(GetOptionsFromArray);
use IO::Handle;
use JSON::PP;
use POSIX ();
use Pod::Usage;

my $FORMAT_VERSION   = 1;
my $INVENTORY_NAME   = '.epics-env-paths.json';
my $OPERATION_NAME   = '.epics-env-operation.json';
my $BACKUP_DIRECTORY = '.epics-env-backups';
my $INSTALLED_NAME   = 'relocateEpicsEnv.pl';
my $SESSION_VARIABLE = 'EPICS_ENV_METADATA_SESSION';
my $LOCK_VARIABLE    = 'EPICS_ENV_METADATA_LOCK';
my $RANDOM_SOURCE    = '/dev/urandom';
my $HASH_COMMAND     = 'sha256sum';
my $EXEC_FAILURE     = 127;
my $PARSER_TIMEOUT   = 60;
my $ARCH_TIMEOUT     = 30;
my $MAX_SYMLINKS     = 40;
my @MANAGED_KINDS    = qw(release make pkgconfig shell service);
my @STATE_FILES      = ('base/configure/CONFIG_SITE.local');
my @METADATA_PATTERNS = (
    'base/configure/CONFIG_SITE.local*', 'base/lib/pkgconfig/epics-base*.pc',
    'base/bin/*/S99caRepeater', 'base/bin/*/S99logServer', 'base/bin/*/caRepeater.service',
    'modules/*/configure/RELEASE*', 'vendor/lib/libuldaq.la', 'vendor/lib/pkgconfig/open62541.pc',
);

my $ASSIGNMENT  = qr/^(\s*)([A-Za-z_][A-Za-z_0-9-]*)(\s*[?:]?=\s*)(.*?)(\s*#.*)?$/;
my $INCLUDE     = qr/^\s*(-?include)\s+(.+?)\s*(?:#.*)?$/;
my $EXEC_START  = qr/^(\s*)(ExecStart)(\s*=\s*)(.*?)(\s*#.*)?$/;
my $LIBS        = qr/^(\s*)(Libs)(:\s*)(.*?)(\s*#.*)?$/;
my $MACRO       = qr/\$\(([A-Za-z_][A-Za-z_0-9-]*)\)/;
my $UNSAFE_TREE = qr/[\s\x00-\x1f#\$'";`\\*?\[\]{}()<>|&:%=!]/;
my $PERL_RELEASE = <<'END_PERL';
use JSON::PP; require "EPICS/Release.pm";
my ($top,$arch)=@ARGV; my %m=(TOP=>$top); my @a;
readReleaseFiles("$top/configure/RELEASE",\%m,\@a,$arch);
expandRelease(\%m); print JSON::PP->new->canonical->encode({macros=>\%m,order=>\@a});
END_PERL

my $HAVE_DIGEST_SHA = eval { require Digest::SHA; 1 };
my $JSON_WRITER     = JSON::PP->new->canonical->pretty->indent_length(2);
my $JSON_COMPARE    = JSON::PP->new->canonical->allow_nonref;

# ---------------------------------------------------------------------------
# Ordered string maps keep insertion order, which decides the order of
# assignments appended to a rewritten file.

sub om_new {
    my (@pairs) = @_;
    my $map = { keys => [], value => {} };
    while (@pairs) {
        my $key = shift @pairs;
        om_set($map, $key, shift @pairs);
    }
    return $map;
}

sub om_set {
    my ($map, $key, $value) = @_;
    push @{ $map->{keys} }, $key unless exists $map->{value}{$key};
    $map->{value}{$key} = $value;
    return;
}

sub om_has {
    my ($map, $key) = @_;
    return exists $map->{value}{$key};
}

sub om_get {
    my ($map, $key) = @_;
    return $map->{value}{$key};
}

sub om_keys {
    my ($map) = @_;
    return @{ $map->{keys} };
}

sub om_copy {
    my ($map) = @_;
    return om_new(map { ($_, $map->{value}{$_}) } om_keys($map));
}

sub om_update {
    my ($map, $other) = @_;
    om_set($map, $_, om_get($other, $_)) for om_keys($other);
    return;
}

sub om_to_hash {
    my ($map) = @_;
    return { %{ $map->{value} } };
}

sub om_from_hash {
    my ($hash) = @_;
    return om_new(map { ($_, $hash->{$_}) } sort keys %$hash);
}

# ---------------------------------------------------------------------------
# Text, path, and JSON helpers.

sub trim {
    my ($text) = @_;
    $text =~ s/\A\s+//;
    $text =~ s/\s+\z//;
    return $text;
}

# Splits bytes into lines that keep their own endings; only LF ends a line.
sub split_lines {
    my ($data) = @_;
    return split /(?<=\n)/, $data;
}

# Lines without their LF or CRLF ending.
sub text_lines {
    my ($data) = @_;
    return map { s/\r?\n\z//r } split_lines($data);
}

sub path_parts {
    my ($path) = @_;
    return grep { $_ ne '' && $_ ne '.' } split m{/}, $path;
}

# Lexical form of a path the way pathlib prints it: no empty or "." parts and
# no trailing slash.
sub normalized_path {
    my ($path) = @_;
    my $absolute = $path =~ m{\A/};
    my $joined = join('/', path_parts($path));
    return $absolute ? "/$joined" : ($joined eq '' ? '.' : $joined);
}

# Lexical normalization of an absolute or relative path, as os.path.normpath.
sub normpath {
    my ($path) = @_;
    my $initial = $path =~ m{\A/} ? 1 : 0;
    $initial = 2 if $path =~ m{\A//} && $path !~ m{\A///};
    my @new;
    for my $part (split m{/}, $path) {
        next if $part eq '' || $part eq '.';
        if ($part ne '..' || (!$initial && !@new) || (@new && $new[-1] eq '..')) {
            push @new, $part;
        } elsif (@new) {
            pop @new;
        }
    }
    my $result = ('/' x $initial) . join('/', @new);
    return $result eq '' ? '.' : $result;
}

# Resolves symlinks of the existing part of an absolute path and appends the
# rest lexically, as a non-strict pathlib resolve.
sub resolve_path {
    my ($path) = @_;
    my @todo = path_parts($path);
    my @done;
    my $links = 0;
    while (@todo) {
        my $part = shift @todo;
        if ($part eq '..') {
            pop @done;
            next;
        }
        my $candidate = '/' . join('/', @done, $part);
        if (-l $candidate) {
            die "$candidate: too many levels of symbolic links\n" if ++$links > $MAX_SYMLINKS;
            my $target = readlink($candidate);
            defined $target or die "$candidate: $!\n";
            @done = () if $target =~ m{\A/};
            unshift @todo, path_parts($target);
            next;
        }
        push @done, $part;
    }
    return '/' . join('/', @done);
}

sub is_within {
    my ($tree, $path) = @_;
    return $path eq $tree || index($path, "$tree/") == 0;
}

sub glob_escape {
    my ($text) = @_;
    $text =~ s/([\\\[\]{}*?~])/\\$1/g;
    return $text;
}

# Files matching a pattern under a literal directory, in sorted order.
sub glob_files {
    my ($directory, $pattern) = @_;
    return sort grep { -f } bsd_glob(glob_escape($directory) . "/$pattern");
}

sub json_bytes {
    my ($value) = @_;
    return $JSON_WRITER->encode($value);
}

sub same_json {
    my ($left, $right) = @_;
    return $JSON_COMPARE->encode($left) eq $JSON_COMPARE->encode($right);
}

sub sv_flags {
    my ($value) = @_;
    return B::svref_2object(\$value)->FLAGS;
}

sub is_json_string {
    my ($value) = @_;
    return 0 if !defined $value || ref $value;
    my $flags = sv_flags($value);
    return ($flags & B::SVp_POK()) && !($flags & (B::SVp_IOK() | B::SVp_NOK())) ? 1 : 0;
}

sub is_json_integer {
    my ($value, $expected) = @_;
    return 0 if !defined $value || ref $value;
    my $flags = sv_flags($value);
    return 0 if !($flags & (B::SVp_IOK() | B::SVp_NOK())) || ($flags & B::SVp_POK());
    return $value == $expected ? 1 : 0;
}

sub same_text {
    my ($left, $right) = @_;
    return !defined $left && !defined $right
        || defined $left && defined $right && $left eq $right;
}

sub same_mode {
    my ($left, $right) = @_;
    return !defined $left && !defined $right
        || defined $left && defined $right && !ref $left && !ref $right && $left == $right;
}

sub file_mode {
    my ($path) = @_;
    my @status = stat $path;
    @status or die "$path: $!\n";
    return $status[2] & 07777;
}

# ---------------------------------------------------------------------------
# Files, state, and child processes.

sub read_bytes {
    my ($path) = @_;
    open(my $fh, '<:raw', $path) or die "$path: $!\n";
    my $data = do { local $/; <$fh> };
    close($fh) or die "$path: $!\n";
    return defined $data ? $data : '';
}

sub read_file {
    my ($path) = @_;
    die "$path: required file is missing\n" if !-f $path;
    return (read_bytes($path), file_mode($path));
}

sub sync_directory {
    my ($dir) = @_;
    sysopen(my $dh, $dir, O_RDONLY | O_DIRECTORY) or die "$dir: $!\n";
    IO::Handle::sync($dh) or die "$dir: sync: $!\n";
    close($dh) or die "$dir: $!\n";
    return;
}

sub atomic_write {
    my ($path, $data, $mode) = @_;
    my $dir = dirname($path);
    my ($fh, $tmp) = tempfile('.' . basename($path) . '.XXXXXX', DIR => $dir);
    my $done = eval {
        binmode($fh) or die "$tmp: $!\n";
        print {$fh} $data or die "$tmp: $!\n";
        $fh->flush or die "$tmp: $!\n";
        chmod($mode, $fh) or die "$tmp: $!\n";
        $fh->sync or die "$tmp: $!\n";
        close($fh) or die "$tmp: $!\n";
        rename($tmp, $path) or die "$path: $!\n";
        sync_directory($dir);
        1;
    };
    if (!$done) {
        my $error = $@;
        # Best-effort cleanup while another error is already being raised.
        unlink $tmp;
        die $error;
    }
    return;
}

sub make_parent {
    my ($path) = @_;
    my $dir = dirname($path);
    return if -d $dir;
    make_path($dir, { error => \my $errors });
    die "$dir: cannot create directory\n" if @$errors || !-d $dir;
    return;
}

sub keep_across_exec {
    my ($fh) = @_;
    my $flags = fcntl($fh, F_GETFD, 0);
    defined $flags or die "fcntl F_GETFD: $!\n";
    fcntl($fh, F_SETFD, $flags & ~FD_CLOEXEC) or die "fcntl F_SETFD: $!\n";
    return fileno($fh);
}

sub exec_or_exit {
    my (@command) = @_;
    {
        no warnings 'exec';
        exec { $command[0] } @command;
    }
    POSIX::_exit($EXEC_FAILURE);
}

sub wait_child {
    my ($pid) = @_;
    my $waited;
    do { $waited = waitpid($pid, 0) } while ($waited == -1 && $! == POSIX::EINTR());
    return $?;
}

# Runs a command without a shell and returns its exit status. An exception
# raised by a signal handler terminates and reaps the child first.
sub run_command {
    my (@command) = @_;
    my $pid = fork();
    defined $pid or die "$command[0]: fork: $!\n";
    exec_or_exit(@command) if !$pid;
    my $done = eval { wait_child($pid); 1 };
    if (!$done) {
        my $error = $@;
        kill('TERM', $pid);
        wait_child($pid);
        die $error;
    }
    die "$command[0]: terminated by signal " . ($? & 127) . "\n" if $? & 127;
    return $? >> 8;
}

# Runs a command without a shell under a time limit and returns its exit
# status, stdout, and stderr.
sub capture_command {
    my ($timeout, @command) = @_;
    my $err = File::Temp->new;
    my $pid = open(my $out, '-|');
    defined $pid or die "$command[0]: fork: $!\n";
    if (!$pid) {
        open(STDERR, '>&', $err) or POSIX::_exit($EXEC_FAILURE);
        exec_or_exit(@command);
    }
    my $text;
    my $done = eval {
        local $SIG{ALRM} = sub { die "$command[0]: timed out after $timeout seconds\n" };
        alarm $timeout;
        $text = do { local $/; <$out> };
        alarm 0;
        1;
    };
    alarm 0;
    if (!$done) {
        my $error = $@;
        kill('TERM', $pid);
        close($out);
        die $error;
    }
    close($out);
    my $status = $?;
    seek($err, 0, 0) or die "$err: $!\n";
    my $stderr = do { local $/; <$err> };
    die "$command[0]: terminated by signal " . ($status & 127) . "\n" if $status & 127;
    return ($status >> 8, defined $text ? $text : '', defined $stderr ? $stderr : '');
}

sub sha256_command {
    my ($path) = @_;
    my ($status, $text) = capture_command($PARSER_TIMEOUT, $HASH_COMMAND, '--', $path);
    die "$HASH_COMMAND: exit $status\n" if $status;
    my ($hex) = $text =~ /^\\?([0-9a-f]{64})\s/ or die "$HASH_COMMAND: bad output\n";
    return $hex;
}

sub digest {
    my ($data) = @_;
    return Digest::SHA::sha256_hex($data) if $HAVE_DIGEST_SHA;
    my $temporary = File::Temp->new;
    binmode($temporary) or die "$temporary: $!\n";
    print {$temporary} $data or die "$temporary: $!\n";
    $temporary->flush or die "$temporary: $!\n";
    return sha256_command($temporary->filename);
}

sub random_hex {
    open(my $fh, '<:raw', $RANDOM_SOURCE) or die "$RANDOM_SOURCE: $!\n";
    my $read = read($fh, my $bytes, 16);
    close($fh);
    die "$RANDOM_SOURCE: short read\n" unless defined $read && $read == 16;
    return unpack('H*', $bytes);
}

sub load_json {
    my ($path) = @_;
    my $value = eval { JSON::PP->new->decode(read_bytes($path)) };
    if (!defined $value) {
        my $error = $@ ne '' ? $@ : "empty JSON document\n";
        $error =~ s/\s+\z//;
        die "$path: $error\n";
    }
    return $value;
}

sub state_path {
    my ($tree, $name) = @_;
    my $path = "$tree/$name";
    die "$name: state files must not be symlinks\n" if -l $path;
    return $path;
}

sub read_operation {
    my ($tree) = @_;
    my $path = state_path($tree, $OPERATION_NAME);
    return undef if !-e $path;
    my $operation = load_json($path);
    eval { validate_operation($operation); 1 } or die "$OPERATION_NAME: $@";
    return $operation;
}

# Resolves a tree-relative locator and rejects one that leaves the tree.
sub locate {
    my ($tree, $relative, $missing) = @_;
    my @parts = path_parts($relative);
    if ($relative =~ m{\A/} || !@parts || grep { $_ eq '..' } @parts) {
        die "$relative: unsafe relative file locator\n";
    }
    my $resolved = resolve_path(join('/', $tree, @parts));
    die "$relative: symlink or file locator escapes the tree\n" if !is_within($tree, $resolved);
    die "$relative: required file is missing\n" if !$missing && !-f $resolved;
    return $resolved;
}

sub relative_path {
    my ($tree, $path) = @_;
    my $resolved = resolve_path(File::Spec->rel2abs($path));
    return '.' if $resolved eq $tree;
    return substr($resolved, length($tree) + 1) if index($resolved, "$tree/") == 0;
    die "$path: file is outside the selected tree\n";
}

# ---------------------------------------------------------------------------
# Metadata parsing and rewriting.

sub expand {
    my ($value, $macros) = @_;
    for (0 .. scalar(keys %$macros)) {
        my $updated = $value =~ s/$MACRO/exists $macros->{$1} ? $macros->{$1} : "\$($1)"/ger;
        return $value if $updated eq $value;
        $value = $updated;
    }
    die "Circular RELEASE macro: $value\n";
}

# Discovers the RELEASE files a module reads, following its includes;
# executable parser checks remain separate.
sub release_files {
    my ($top, $arch) = @_;
    my %macros = (TOP => $top, EPICS_HOST_ARCH => $arch);
    my (@visited, %seen, %active);
    my $visit;
    $visit = sub {
        my ($path) = @_;
        $path = resolve_path($path);
        die "$path: recursive RELEASE include\n" if $active{$path};
        $active{$path} = 1;
        push @visited, $path unless $seen{$path}++;
        for my $line (text_lines(read_bytes($path))) {
            my ($before) = split /#/, $line, 2;
            my $stripped = trim(defined $before ? $before : '');
            next if $stripped eq '';
            if ($line =~ $INCLUDE) {
                my ($directive, $operand) = ($1, $2);
                my $name = expand($operand, \%macros);
                die "$path: unresolved include $name\n" if index($name, '$') >= 0;
                my $target = $name =~ m{\A/} ? normalized_path($name) : normalized_path("$top/$name");
                if (-f $target) {
                    $visit->($target);
                } elsif ($directive eq 'include') {
                    die "$path: required include is missing: $target\n";
                }
                next;
            }
            if ($stripped =~ /\Aundefine /) {
                delete $macros{ (split ' ', $stripped, 2)[1] };
                next;
            }
            my @group = $line =~ $ASSIGNMENT;
            die "$path: unsupported RELEASE syntax: $stripped\n" if !@group;
            my ($key, $operator, $value) = ($group[1], trim($group[2]), trim($group[3]));
            next if $operator eq '?=' && exists $macros{$key};
            $key = 'TOP' if $key =~ /\AINSTALL_LOCATION/;
            $macros{$key} = $operator eq ':=' ? expand($value, \%macros) : $value;
        }
        delete $active{$path};
        return;
    };
    my $release = "$top/configure/RELEASE";
    for my $suffix ('', ".$arch", ".$arch.Common", ".Common.$arch", ".$arch.$arch") {
        $visit->("$release$suffix") if -f "$release$suffix";
    }
    undef $visit;
    return @visited;
}

sub parsed_release {
    my ($tree, $top, $arch) = @_;
    local $ENV{EPICS_HOST_ARCH} = $arch;
    my ($status, $stdout, $stderr) = capture_command($PARSER_TIMEOUT,
        $^X, "-I$tree/base/lib/perl", '-e', $PERL_RELEASE, $top, $arch);
    die "$top: real EPICS parser failed: " . trim($stderr) . "\n" if $status;
    my $parsed = eval { JSON::PP->new->decode($stdout) };
    if (ref $parsed ne 'HASH' || ref $parsed->{macros} ne 'HASH' || ref $parsed->{order} ne 'ARRAY') {
        die "$top: invalid EPICS parser output\n";
    }
    return $parsed;
}

sub host_arch {
    my ($tree) = @_;
    my ($status, $stdout) = capture_command($ARCH_TIMEOUT, $^X, "$tree/base/lib/perl/EpicsHostArch.pl");
    my $arch = trim($stdout);
    if ($status || $arch !~ /\Alinux-[A-Za-z0-9_-]+\z/) {
        die "A native Linux EPICS host architecture is required\n";
    }
    return $arch;
}

# Returns the five assignment groups of a line for a metadata kind, or none.
sub assignment_groups {
    my ($kind, $line) = @_;
    my $pattern = $kind eq 'service' ? $EXEC_START
        : $kind eq 'pkgconfig' && $line =~ /\ALibs:/ ? $LIBS
        : $ASSIGNMENT;
    my @group = $line =~ $pattern;
    return @group;
}

sub file_fields {
    my ($data, $kind, $label) = @_;
    my $fields = om_new();
    my $include_index = 0;
    for my $line (text_lines($data)) {
        if ($kind eq 'release' && $line =~ $INCLUDE) {
            my $operand = $2;
            om_set($fields, 'include:' . $include_index++, trim($operand));
            next;
        }
        my @group = assignment_groups($kind, $line);
        next if !@group;
        if (om_has($fields, $group[1])) {
            die((defined $label ? "$label: " : '') . "$group[1]: duplicate assignment is ambiguous\n");
        }
        om_set($fields, $group[1], trim($group[3]));
    }
    return $fields;
}

sub backup_name {
    my ($path) = @_;
    my $name = basename($path);
    return $name =~ /~\z/ || $name =~ /\.(?:orig|rej|bak|backup)(?:\.|\z)/ ? 1 : 0;
}

# Rewrites the named assignments and includes of a file in place, keeping
# every other byte; with append, assignments the file lacks are appended.
sub render_fields {
    my ($data, $kind, $fields, $append) = @_;
    my $existing = file_fields($data, $kind);
    my @missing = grep { !om_has($existing, $_) } om_keys($fields);
    if (@missing && !$append) {
        die 'Required managed assignments are missing: ' . join(', ', sort @missing) . "\n";
    }
    my @lines;
    my $include_index = 0;
    for my $line (split_lines($data)) {
        my ($body, $ending) = $line =~ /\A(.*?)(\r\n|\n|)\z/s;
        if ($kind eq 'release' && $body =~ $INCLUDE) {
            my ($start, $end) = ($-[2], $+[2]);
            my $key = 'include:' . $include_index++;
            substr($body, $start, $end - $start) = om_get($fields, $key) if om_has($fields, $key);
            push @lines, $body . $ending;
            next;
        }
        my @group = assignment_groups($kind, $body);
        if (@group && om_has($fields, $group[1])) {
            $body = join('', @group[0 .. 2], om_get($fields, $group[1]), defined $group[4] ? $group[4] : '');
        }
        push @lines, $body . $ending;
    }
    if (@missing) {
        die "A managed include is missing; reconciliation is ambiguous\n" if grep { /\Ainclude:/ } @missing;
        $lines[-1] .= "\n" if @lines && $lines[-1] !~ /\n\z/;
        my %is_missing = map { ($_ => 1) } @missing;
        push @lines, map { "$_=" . om_get($fields, $_) . "\n" } grep { $is_missing{$_} } om_keys($fields);
    }
    return join('', @lines);
}

sub validate_tree_name {
    my ($tree) = @_;
    if ($tree !~ m{\A/} || $tree =~ $UNSAFE_TREE) {
        die "Tree paths must be absolute and contain no whitespace or make/shell metacharacters\n";
    }
    return;
}

sub rebase {
    my ($value, $old_root, $new_root) = @_;
    $value =~ s{(?:(?<![A-Za-z0-9_./-])|(?<=-L)|(?<=-I))\Q$old_root\E(?=/|$)}{$new_root}g;
    return $value;
}

sub managed_paths {
    my ($value, $root) = @_;
    my @found = $value =~ m{(?:(?<![A-Za-z0-9_./-])|(?<=-L)|(?<=-I))\Q$root\E(?=/|$)(?:/[^\s,'"]*)?}g;
    return @found;
}

sub same_paths {
    my ($left, $right) = @_;
    return join("\0", @$left) eq join("\0", @$right);
}

sub flexible_field {
    my ($kind, $key) = @_;
    return ($kind eq 'pkgconfig' && $key eq 'Libs') || ($kind eq 'service' && $key eq 'ExecStart') ? 1 : 0;
}

sub native_os {
    my %values;
    for my $line (text_lines(read_bytes('/etc/os-release'))) {
        my ($key, $separator, $value) = $line =~ /\A([^=]*)(=?)(.*)\z/s;
        next if $separator eq '' || ($key ne 'ID' && $key ne 'VERSION_ID');
        $value = trim($value);
        $value =~ s/\A"+|"+\z//g;
        $value =~ s/\A'+|'+\z//g;
        $values{$key} = $value;
    }
    die "Native operating system identity is unavailable\n" if !exists $values{ID} || !exists $values{VERSION_ID};
    return { ID => $values{ID}, VERSION_ID => $values{VERSION_ID} };
}

# ---------------------------------------------------------------------------
# Inventory, operation record, and verification.

sub validate_inventory {
    my ($tree, $inventory) = @_;
    if (ref $inventory ne 'HASH' || !is_json_integer($inventory->{format_version}, $FORMAT_VERSION)
            || ref $inventory->{files} ne 'ARRAY') {
        die "$INVENTORY_NAME: unsupported inventory format\n";
    }
    if (!is_json_string($inventory->{root}) || $inventory->{root} !~ m{\A/}) {
        die "$INVENTORY_NAME: invalid recorded root\n";
    }
    state_path($tree, $INVENTORY_NAME);
    my %seen;
    for my $entry (@{ $inventory->{files} }) {
        if (ref $entry ne 'HASH' || grep({ !exists $entry->{$_} } qw(path kind fields))
                || !is_json_string($entry->{path}) || !is_json_string($entry->{kind})) {
            die "$INVENTORY_NAME: invalid managed file declaration\n";
        }
        my $path = locate($tree, $entry->{path});
        die "$entry->{path}: duplicate managed file\n" if $seen{$path}++;
        if (!grep { $_ eq $entry->{kind} } @MANAGED_KINDS) {
            die "$entry->{path}: unsupported managed file type\n";
        }
        if (ref $entry->{fields} ne 'HASH' || !%{ $entry->{fields} }) {
            die "$entry->{path}: empty managed field declaration\n";
        }
        if (grep { !is_json_string($_) } values %{ $entry->{fields} }) {
            die "$entry->{path}: invalid managed field value\n";
        }
    }
    if (!@{ $inventory->{files} } || ref $inventory->{modules} ne 'ARRAY' || !@{ $inventory->{modules} }
            || grep { !is_json_string($_) } @{ $inventory->{modules} }) {
        die "$INVENTORY_NAME: selected installed metadata is missing\n";
    }
    return;
}

sub report_external {
    my ($inventory) = @_;
    my $root = $inventory->{root};
    my %external;
    for my $entry (@{ $inventory->{files} }) {
        for my $value (values %{ $entry->{fields} }) {
            $external{$value} = 1 if $value =~ m{\A/} && $value ne $root && index($value, "$root/") != 0;
        }
    }
    for my $value (sort keys %external) {
        printf "External dependency preserved (%s): %s\n", (-d $value ? 'available' : 'unavailable'), $value;
    }
    return;
}

sub validate_release_tree {
    my ($tree, $inventory) = @_;
    my $arch = $inventory->{architecture};
    my %declarations = map { ($_->{path} => $_) } grep { $_->{kind} eq 'release' } @{ $inventory->{files} };
    for my $destination (@{ $inventory->{modules} }) {
        my $top = dirname(dirname(locate($tree, "$destination/configure/RELEASE")));
        my $parsed = parsed_release($tree, $top, $arch);
        if (!same_text($parsed->{macros}{EPICS_BASE}, "$tree/base")) {
            die "$destination: installed RELEASE resolves a foreign base\n";
        }
        for my $path (release_files($top, $arch)) {
            my $relative = relative_path($tree, $path);
            my $entry = $declarations{$relative};
            my $actual = file_fields(read_bytes($path), 'release', $relative);
            my @managed = grep {
                index(om_get($actual, $_), "$tree/") == 0 || $_ eq 'EPICS_BASE'
            } om_keys($actual);
            if (@managed && (!$entry || grep { !exists $entry->{fields}{$_} } @managed)) {
                die "$relative: dependency declaration is absent from inventory\n";
            }
        }
        my $checker = "$tree/base/bin/$arch/convertRelease.pl";
        my ($status, $stdout, $stderr) = capture_command($PARSER_TIMEOUT,
            $^X, $checker, '-a', $arch, '-T', $top, 'checkRelease');
        die "$destination: EPICS consistency check failed: " . trim($stdout . $stderr) . "\n" if $status;
    }
    return;
}

sub validate_operation {
    my ($operation) = @_;
    if (ref $operation ne 'HASH' || !is_json_integer($operation->{format_version}, $FORMAT_VERSION)) {
        die "Unsupported unfinished operation format; retain the operation record\n";
    }
    my $kind = $operation->{kind};
    if (!defined $kind || ref $kind || ($kind ne 'install' && $kind ne 'refresh')
            || ref $operation->{files} ne 'ARRAY') {
        die "Invalid unfinished operation; retain the operation record\n";
    }
    for my $record (@{ $operation->{files} }) {
        if (ref $record ne 'HASH' || grep { !exists $record->{$_} } qw(path before mode backup)) {
            die "Invalid recovery file record; retain the operation record\n";
        }
        if ($kind eq 'refresh' && grep { !exists $record->{$_} } qw(after after_mode)) {
            die "$record->{path}: incomplete recovery hashes or modes\n";
        }
    }
    return;
}

sub refresh_plan {
    my ($tree, $inventory) = @_;
    validate_inventory($tree, $inventory);
    if (!same_json($inventory->{os}, native_os()) || !same_text($inventory->{architecture}, host_arch($tree))) {
        die "Relocation requires the original OS version and host architecture\n";
    }
    my $root = $inventory->{root};
    my @changes;
    for my $entry (@{ $inventory->{files} }) {
        my $path = locate($tree, $entry->{path});
        my ($before, $mode) = read_file($path);
        my $actual = file_fields($before, $entry->{kind}, $entry->{path});
        my $fields = om_new();
        for my $key (sort keys %{ $entry->{fields} }) {
            my $expected = $entry->{fields}{$key};
            my $value = om_get($actual, $key);
            my $matches = same_text($value, $expected);
            if (defined $value && flexible_field($entry->{kind}, $key)) {
                my @expected_paths = managed_paths($expected, $root);
                $matches = @expected_paths && same_paths([managed_paths($value, $root)], \@expected_paths);
            }
            die "$entry->{path}: managed assignment $key differs from inventory\n" if !$matches;
            om_set($fields, $key, rebase($value, $root, $tree));
        }
        my $after = render_fields($before, $entry->{kind}, $fields);
        if ($after ne $before) {
            my $parent = dirname($path);
            die "$entry->{path}: metadata replacement directory is read-only\n" if !(-W $parent && -X $parent);
            push @changes, [$entry->{path}, $after, $mode];
        }
    }
    my $updated = JSON::PP->new->decode($JSON_COMPARE->encode($inventory));
    $updated->{root} = $tree;
    for my $entry (@{ $updated->{files} }) {
        $entry->{fields}{$_} = rebase($entry->{fields}{$_}, $root, $tree) for keys %{ $entry->{fields} };
    }
    if (!same_json($updated, $inventory) && !(-W $tree && -X $tree)) {
        die "$INVENTORY_NAME: inventory replacement directory is read-only\n";
    }
    return (\@changes, $updated);
}

sub backup_files {
    my ($tree, @paths) = @_;
    my $directory = locate($tree, "$BACKUP_DIRECTORY/" . random_hex(), 1);
    my %unique = map { ($_ => 1) } @paths;
    my @records;
    for my $relative (sort keys %unique) {
        my $path = locate($tree, $relative, 1);
        my $record = { path => $relative, before => undef, mode => undef, backup => undef };
        if (-e $path) {
            my ($data, $mode) = read_file($path);
            my $backup = "$directory/$relative";
            make_parent($backup);
            atomic_write($backup, $data, $mode);
            my ($verified, $backup_mode) = read_file($backup);
            die "$relative: backup verification failed\n" if $verified ne $data || $backup_mode != $mode;
            $record->{before} = digest($data);
            $record->{mode}   = $mode;
            $record->{backup} = relative_path($tree, $backup);
        }
        push @records, $record;
    }
    return @records;
}

sub verified_backup {
    my ($tree, $record) = @_;
    return undef if !defined $record->{before};
    my $backup = locate($tree, $record->{backup});
    if (index(normalized_path($record->{backup}), "$BACKUP_DIRECTORY/") != 0) {
        die "$record->{path}: unsafe backup locator\n";
    }
    my ($data, $mode) = read_file($backup);
    if (digest($data) ne $record->{before} || !same_mode($mode, $record->{mode})) {
        die "$record->{path}: backup contents or mode changed\n";
    }
    return $data;
}

sub restore {
    my ($tree, $records, $strict) = @_;
    my @prepared;
    for my $record (@$records) {
        my $path = locate($tree, $record->{path}, 1);
        my $data = verified_backup($tree, $record);
        if ($strict) {
            my $exists  = -e $path;
            my $current = $exists ? digest(read_bytes($path)) : undef;
            my $mode    = $exists ? file_mode($path) : undef;
            my $as_before = same_text($current, $record->{before}) && same_mode($mode, $record->{mode});
            my $as_after  = same_text($current, $record->{after}) && same_mode($mode, $record->{after_mode});
            if (!$as_before && !$as_after) {
                die "$record->{path}: contents or mode changed outside the unfinished operation\n";
            }
        }
        push @prepared, [$path, $data, $record];
    }
    for my $item (reverse @prepared) {
        my ($path, $data, $record) = @$item;
        if (!defined $data) {
            if (-e $path) {
                unlink($path) or die "$path: $!\n";
                sync_directory(dirname($path));
            }
            next;
        }
        next if -f $path && read_bytes($path) eq $data && same_mode(file_mode($path), $record->{mode});
        make_parent($path);
        atomic_write($path, $data, $record->{mode});
        my ($actual, $mode) = read_file($path);
        die "$record->{path}: restoration verification failed\n" if $actual ne $data || !same_mode($mode, $record->{mode});
    }
    return;
}

sub save_operation {
    my ($tree, $operation) = @_;
    atomic_write(state_path($tree, $OPERATION_NAME), json_bytes($operation), 0600);
    return;
}

sub finish_operation {
    my ($tree) = @_;
    my $path = state_path($tree, $OPERATION_NAME);
    unlink($path) or die "$path: $!\n";
    sync_directory($tree);
    return;
}

sub apply_refresh {
    my ($tree, $inventory) = @_;
    my ($changes, $updated) = refresh_plan($tree, $inventory);
    if (!@$changes && same_json($updated, $inventory)) {
        validate_release_tree($tree, $inventory);
        print "Metadata is current; no files or backups changed.\n";
        return 0;
    }
    my @records = backup_files($tree, (map { $_->[0] } @$changes), $INVENTORY_NAME);
    my %after = map { ($_->[0] => [$_->[1], $_->[2]]) } @$changes;
    $after{$INVENTORY_NAME} = [json_bytes($updated), file_mode("$tree/$INVENTORY_NAME")];
    for my $record (@records) {
        $record->{after}      = digest($after{ $record->{path} }[0]);
        $record->{after_mode} = $after{ $record->{path} }[1];
    }
    my $operation = {
        format_version => $FORMAT_VERSION, kind => 'refresh',
        source_root => $inventory->{root}, target_root => $tree, files => \@records,
    };
    save_operation($tree, $operation);
    my $done = eval {
        local $SIG{INT} = sub { die "interrupted\n" };
        for my $change (@$changes, [$INVENTORY_NAME, @{ $after{$INVENTORY_NAME} }]) {
            my ($relative, $data, $mode) = @$change;
            my $path = locate($tree, $relative);
            my ($record) = grep { $_->{path} eq $relative } @records;
            if (digest(read_bytes($path)) ne $record->{before} || !same_mode(file_mode($path), $record->{mode})) {
                die "$relative: contents or mode changed before replacement\n";
            }
            atomic_write($path, $data, $mode);
        }
        refresh_plan($tree, $updated);
        validate_release_tree($tree, $updated);
        finish_operation($tree);
        1;
    };
    if (!$done) {
        my $error = $@;
        print STDERR "Replacement failed: $error";
        eval {
            restore($tree, \@records, 1);
            finish_operation($tree);
            print STDERR "Previous metadata and inventory restored; run apply separately to retry.\n";
            1;
        } or print STDERR "Recovery remains unfinished: $@";
        return 3;
    }
    print "Metadata refreshed for $tree. Verified backups retained.\n";
    report_external($updated);
    return 0;
}

# ---------------------------------------------------------------------------
# Installation.

sub metadata_paths {
    my ($tree, $modules) = @_;
    my %paths = map { ($_ => 1) } $INVENTORY_NAME, @STATE_FILES;
    my %module_files;
    if (-e state_path($tree, $INVENTORY_NAME)) {
        my $inventory = load_json(state_path($tree, $INVENTORY_NAME));
        validate_inventory($tree, $inventory);
        $paths{ $_->{path} } = 1 for @{ $inventory->{files} };
    }
    for my $pattern (@METADATA_PATTERNS) {
        $paths{ relative_path($tree, $_) } = 1 for glob_files($tree, $pattern);
    }
    for my $module (@$modules) {
        my ($source, $destination) = @$module;
        $paths{"$destination/configure/" . basename($_)} = 1 for glob_files("$source/configure", 'RELEASE*');
        my $installed = "$tree/$destination";
        if (-f "$installed/configure/RELEASE") {
            my $arch = host_arch($tree);
            my @included = map { relative_path($tree, $_) } release_files($installed, $arch);
            $paths{$_} = 1 for @included;
            $module_files{$destination} = \@included;
        }
    }
    return ([sort keys %paths], \%module_files);
}

sub configured_value {
    my ($tree, $value, $aliases) = @_;
    return $value if $value !~ m{\A/};
    $value = normpath($value);
    for my $alias (@$aliases) {
        my ($from, $to) = @$alias;
        return $to . substr($value, length $from) if $value eq $from || index($value, "$from/") == 0;
    }
    return $value;
}

sub prepare_install {
    my ($tree, $modules, $operation) = @_;
    my $arch = host_arch($tree);
    my @aliases;
    for my $module (@$modules) {
        my ($source, $destination) = @$module;
        my $plain = normalized_path($source);
        my $name = basename($plain) eq 'client' ? basename(dirname($plain)) : basename($plain);
        $name =~ s/-src\z//;
        $name = 'seq' if $name eq 'sequencer';
        push @aliases, ["$tree/modules/$name", "$tree/$destination"];
    }
    my %entries;
    my $changes = om_new();
    my %snapshots = map { ($_->{path} => $_) } @{ $operation->{files} };
    my $previous_inventory = $snapshots{$INVENTORY_NAME};
    my $preserved_root = $tree;
    if ($previous_inventory && defined $previous_inventory->{before}) {
        $preserved_root = JSON::PP->new->decode(verified_backup($tree, $previous_inventory))->{root};
    }

    my $register = sub {
        my ($relative, $kind, $fields, $original, $append) = @_;
        my $path = locate($tree, $relative, defined $original);
        my ($data, $mode) = -e $path ? read_file($path) : ($original, 0644);
        die "$relative: required metadata is missing\n" if !defined $data;
        $fields = om_copy($fields);
        my $fresh_fields = file_fields($data, $kind, $relative);
        if ($kind eq 'release') {
            for my $key (om_keys($fresh_fields)) {
                my $value = om_get($fresh_fields, $key);
                om_set($fields, $key, $value) if $key =~ /\Ainclude:/ && index($value, "$tree/") == 0;
            }
        }
        my $current = render_fields($data, $kind, $fields, $append);
        my $record = $snapshots{$relative};
        if ($record && defined $record->{before}) {
            my $previous = verified_backup($tree, $record);
            my $previous_fields = file_fields($previous, $kind, $relative);
            $fields = om_copy($fields);
            if ($kind eq 'release') {
                for my $key (om_keys($previous_fields)) {
                    my $value = om_get($previous_fields, $key);
                    if ($key =~ /\Ainclude:/ && index($value, "$preserved_root/") == 0) {
                        om_set($fields, $key, rebase($value, $preserved_root, $tree));
                    }
                }
            }
            for my $key (om_keys($fields)) {
                next if !om_has($previous_fields, $key) || !flexible_field($kind, $key);
                my $preserved = rebase(om_get($previous_fields, $key), $preserved_root, $tree);
                if (!same_paths([managed_paths($preserved, $tree)], [managed_paths(om_get($fields, $key), $tree)])) {
                    die "$relative: ambiguous managed path reconciliation for $key\n";
                }
                om_set($fields, $key, $preserved);
            }
            for my $key (sort grep { om_has($fresh_fields, $_) && !om_has($fields, $_) } om_keys($previous_fields)) {
                if (om_get($previous_fields, $key) ne om_get($fresh_fields, $key)) {
                    die "$relative: ambiguous reconciliation for unmanaged $key\n";
                }
            }
            $current = render_fields($previous, $kind, $fields, 1);
            my $missing = om_new(map { ($_, om_get($fresh_fields, $_)) }
                grep { !om_has($previous_fields, $_) && !om_has($fields, $_) && !/\Ainclude:/ } om_keys($fresh_fields));
            $current = render_fields($current, $kind, $missing, 1);
            $mode = $record->{mode};
        }
        if (exists $entries{$relative}) {
            my $existing = $entries{$relative}{fields};
            for my $key (grep { om_has($fields, $_) } om_keys($existing)) {
                if (om_get($existing, $key) ne om_get($fields, $key)) {
                    die "$relative: conflicting included-file dependency declarations\n";
                }
            }
            my $merged = om_copy($existing);
            om_update($merged, $fields);
            $fields = $merged;
            $current = render_fields($current, $kind, $fields, $append);
        }
        $entries{$relative} = { path => $relative, kind => $kind, fields => $fields } if om_keys($fields);
        if ($current ne $data || !-e $path || !same_mode($mode, file_mode($path))) {
            om_set($changes, $relative, [$current, $mode]);
        }
        return;
    };

    for my $module (@$modules) {
        my ($source, $destination, $module_key) = @$module;
        $source = resolve_path(File::Spec->rel2abs($source));
        die "$source: configured source RELEASE is missing\n" if !-f "$source/configure/RELEASE";
        my $parsed = parsed_release($tree, $source, $arch);
        my %expected;
        for my $key (sort keys %{ $parsed->{macros} }) {
            my $value = $parsed->{macros}{$key};
            next if $key eq 'TOP' || $key eq 'EPICS_HOST_ARCH';
            next if defined $value && $value ne '' && $value !~ m{\A/};
            $expected{$key} = configured_value($tree, defined $value ? $value : '', \@aliases);
        }
        $expected{$module_key} = "$tree/$destination" if exists $expected{$module_key};
        if (!same_text($expected{EPICS_BASE}, "$tree/base")) {
            die "$source: configured EPICS_BASE does not select the installed base\n";
        }
        my $installed = "$tree/$destination";
        my $main = "$destination/configure/RELEASE";
        my %source_files = map { (basename($_) => $_) } grep { !backup_name($_) } glob_files("$source/configure", 'RELEASE*');
        my @candidates = grep { !backup_name($_) }
            sort { $a cmp $b } bsd_glob(glob_escape("$installed/configure") . '/RELEASE*');
        push @candidates, map { "$installed/configure/$_" } grep { !-e "$installed/configure/$_" } sort keys %source_files;
        push @candidates, release_files($installed, $arch) if -e "$installed/configure/RELEASE";
        my $module_files = ref $operation->{module_files} eq 'HASH' ? $operation->{module_files}{$destination} : undef;
        push @candidates, map { locate($tree, $_, 1) } @{ $module_files || [] };
        my (%seen, %present);
        for my $path (@candidates) {
            my $relative = relative_path($tree, $path);
            next if $seen{$relative}++;
            my $name = basename($path);
            my $original = !-e $path && exists $source_files{$name} ? read_bytes($source_files{$name}) : undef;
            my $data = -e $path ? read_bytes($path) : $original;
            die "$relative: required installed metadata is missing\n" if !defined $data;
            my $actual = file_fields($data, 'release', $relative);
            my $fields = om_new(map { ($_, $expected{$_}) } grep { exists $expected{$_} } om_keys($actual));
            $present{$_} = 1 for om_keys($fields);
            $register->($relative, 'release', $fields, $original, 0);
        }
        my @missing = grep { exists $expected{$_} && !$present{$_} } @{ $parsed->{order} };
        if (@missing) {
            my %unique;
            my $missing = om_new(map { ($_, $expected{$_}) } grep { !$unique{$_}++ } @missing);
            my $previous = $entries{$main} ? $entries{$main}{fields} : om_new();
            my $fields = om_new(map { ($_, om_get($previous, $_)) } grep { !/\Ainclude:/ } om_keys($previous));
            om_update($fields, $missing);
            delete $entries{$main};
            die "$source: configured source RELEASE is missing\n" if !exists $source_files{RELEASE};
            $register->($main, 'release', $fields, read_bytes($source_files{RELEASE}), 1);
        }
    }

    $register->('base/configure/CONFIG_SITE.local', 'make', om_new(INSTALL_LOCATION => "$tree/base"), undef, 0);
    my @packages = glob_files($tree, 'base/lib/pkgconfig/epics-base*.pc');
    if (!-f "$tree/base/lib/pkgconfig/epics-base.pc" || @packages < 2) {
        die "Required base pkg-config metadata is missing\n";
    }
    for my $path (@packages) {
        my $actual = file_fields(read_bytes($path), 'pkgconfig', $path);
        my $fields = om_new(prefix => "$tree/base");
        if (om_has($actual, 'Libs')) {
            my $old_prefix = om_get($actual, 'prefix');
            die "$path: unsupported pkg-config prefix\n" if !defined $old_prefix || $old_prefix !~ m{/base\z};
            om_set($fields, 'Libs', rebase(om_get($actual, 'Libs'), substr($old_prefix, 0, -5), $tree));
        }
        $register->(relative_path($tree, $path), 'pkgconfig', $fields, undef, 0);
    }
    for my $service (['S99caRepeater', 'shell', 'INSTALL_BIN', ''],
                     ['S99logServer', 'shell', 'INSTALL_BIN', ''],
                     ['caRepeater.service', 'service', 'ExecStart', '/caRepeater']) {
        my ($name, $kind, $key, $suffix) = @$service;
        my $path = "$tree/base/bin/$arch/$name";
        $register->(relative_path($tree, $path), $kind, om_new($key => dirname($path) . $suffix), undef, 0);
    }
    for my $vendor (['vendor/lib/libuldaq.la', 'shell', 'libdir', "'$tree/vendor/lib'"],
                    ['vendor/lib/pkgconfig/open62541.pc', 'pkgconfig', 'prefix', "$tree/vendor"]) {
        my ($relative, $kind, $key, $value) = @$vendor;
        if (-e "$tree/$relative") {
            $register->($relative, $kind, om_new($key => $value), undef, 0);
        } else {
            print "$relative: optional tree-local vendor metadata is absent.\n";
        }
    }
    for my $record (@{ $operation->{files} }) {
        my $relative = $record->{path};
        next if !backup_name($relative) || exists $entries{$relative} || !defined $record->{before};
        my $path = locate($tree, $relative, 1);
        my $original = verified_backup($tree, $record);
        if (!-e $path || read_bytes($path) ne $original || !same_mode(file_mode($path), $record->{mode})) {
            om_set($changes, $relative, [$original, $record->{mode}]);
        }
    }
    undef $register;
    my $inventory = {
        format_version => $FORMAT_VERSION, root => $tree, architecture => $arch, os => native_os(),
        modules => [map { $_->[1] } @$modules],
        files => [map { { path => $_, kind => $entries{$_}{kind}, fields => om_to_hash($entries{$_}{fields}) } }
                  sort keys %entries],
    };
    return ($changes, $inventory);
}

sub finalize_install {
    my ($tree, $modules, $operation) = @_;
    my ($changes, $inventory) = prepare_install($tree, $modules, $operation);
    om_set($changes, $INVENTORY_NAME, [json_bytes($inventory), 0644]);
    my @records = backup_files($tree, om_keys($changes));
    $_->{after} = digest(om_get($changes, $_->{path})->[0]) for @records;
    $operation->{replacement} = \@records;
    save_operation($tree, $operation);
    for my $relative (om_keys($changes)) {
        my ($data, $mode) = @{ om_get($changes, $relative) };
        my $path = locate($tree, $relative, 1);
        make_parent($path);
        atomic_write($path, $data, $mode);
    }
    refresh_plan($tree, $inventory);
    validate_release_tree($tree, $inventory);
    my $source = resolve_path(File::Spec->rel2abs(__FILE__));
    atomic_write("$tree/$INSTALLED_NAME", read_bytes($source), 0644);
    finish_operation($tree);
    print "Installed metadata finalized for $tree.\n";
    report_external($inventory);
    return;
}

sub module_inputs {
    my ($tree, @values) = @_;
    my (@modules, %destinations);
    for my $value (@values) {
        my @parts = split /=/, $value, 3;
        if (@parts != 3 || $parts[0] !~ /\A[A-Z][A-Z0-9_]*\z/) {
            die "Module input requires configured key=source=installed destination\n";
        }
        my ($key, $source, $destination) = @parts;
        my $relative = relative_path($tree, $destination);
        if (index($relative, 'modules/') != 0 || $destinations{$relative}++) {
            die "$destination: duplicate or unsupported module destination\n";
        }
        push @modules, [$source, $relative, $key];
    }
    die "Explicit configured module inputs are required for installation\n" if !@modules;
    return \@modules;
}

# Takes the tree lock, or adopts the lock descriptor an installing writer
# handed down, and returns the handle that keeps it.
sub tree_lock {
    my ($tree, $inherited, $shared) = @_;
    if ($inherited) {
        my $number = $ENV{$LOCK_VARIABLE};
        my $handle;
        my $valid = defined $number && $number =~ /\A[0-9]+\z/ && open($handle, '<&=', $number);
        my @held = $valid ? stat($handle) : ();
        my @tree = stat($tree);
        die "Inherited install lock is unavailable\n" if !@held || !@tree;
        die "Inherited install lock does not select this tree\n" if $held[1] != $tree[1];
        return $handle;
    }
    sysopen(my $handle, $tree, O_RDONLY | O_DIRECTORY) or die "$tree: $!\n";
    if (!flock($handle, ($shared ? LOCK_SH : LOCK_EX) | LOCK_NB)) {
        die $! == POSIX::EWOULDBLOCK() ? "Another operation holds the selected tree lock\n" : "$tree: $!\n";
    }
    return $handle;
}

sub write_install {
    my ($tree, $option) = @_;
    my $modules = module_inputs($tree, @{ $option->{module} });
    my $operation = read_operation($tree);
    my $inherited = $operation && $operation->{kind} eq 'install'
        && same_text($operation->{session}, $ENV{$SESSION_VARIABLE});
    my $lock = tree_lock($tree, $inherited, 0);
    if ($inherited) {
        # Adopting the inherited descriptor marks it close-on-exec again; clear
        # it so nested writers below this one still find the lock.
        keep_across_exec($lock);
        return run_command(@{ $option->{command} });
    }
    $operation = read_operation($tree);
    if ($operation && $operation->{kind} ne 'install') {
        die "Unfinished replacement recovery: run the installed utility --apply before build/install\n";
    }
    if ($operation) {
        verified_backup($tree, $_) for @{ $operation->{files} };
    } else {
        my ($paths, $module_files) = metadata_paths($tree, $modules);
        $operation = {
            format_version => $FORMAT_VERSION, kind => 'install',
            files => [backup_files($tree, @$paths)], module_files => $module_files,
        };
    }
    $operation->{session} = random_hex();
    save_operation($tree, $operation);
    my $descriptor = keep_across_exec($lock);
    my $done = eval {
        local $SIG{INT} = sub { die "interrupted\n" };
        local $ENV{$SESSION_VARIABLE} = $operation->{session};
        local $ENV{$LOCK_VARIABLE} = $descriptor;
        my $status = run_command(@{ $option->{command} });
        die "Upstream writer returned $status\n" if $status;
        finalize_install($tree, $modules, $operation) if $option->{finalize};
        1;
    };
    return 0 if $done;
    my $error = $@;
    print STDERR "Installation incomplete: $error";
    eval {
        restore($tree, $operation->{files});
        print STDERR "Original metadata restored; successful full installation is still required.\n";
        1;
    } or print STDERR "Metadata restoration remains incomplete: $@";
    return 2;
}

# ---------------------------------------------------------------------------
# Command line.

sub parse_options {
    my (@argv) = @_;
    my %option = (module => []);
    Getopt::Long::Configure(qw(require_order no_ignore_case));
    my $parsed = GetOptionsFromArray(\@argv,
        'check'    => \$option{check},
        'apply'    => \$option{apply},
        'write'    => \$option{write},
        'tree=s'   => \$option{tree},
        'finalize' => \$option{finalize},
        'module=s' => $option{module},
        'help|h'   => \$option{help},
    );
    pod2usage(-exitval => 2, -verbose => 0, -output => \*STDERR) if !$parsed;
    pod2usage(-exitval => 0, -verbose => 1) if $option{help};
    if ((grep { $option{$_} } qw(check apply write)) != 1) {
        pod2usage(-exitval => 2, -verbose => 0, -output => \*STDERR,
            -message => 'Exactly one of --check, --apply, or --write is required.');
    }
    $option{command} = \@argv;
    return \%option;
}

sub main {
    my (@argv) = @_;
    my $option = parse_options(@argv);
    my $tree = defined $option->{tree}
        ? normalized_path($option->{tree})
        : dirname(resolve_path(File::Spec->rel2abs(__FILE__)));
    validate_tree_name($tree);
    $tree = resolve_path($tree);
    validate_tree_name($tree);
    if ($option->{write}) {
        die "An upstream writer command is required\n" if !@{ $option->{command} };
        make_path($tree, { error => \my $errors }) if !-d $tree;
        die "$tree: cannot create directory\n" if !-d $tree;
        return write_install($tree, $option);
    }
    if ($option->{finalize} || @{ $option->{module} } || @{ $option->{command} }) {
        die "Install-only inputs cannot be used for check/apply\n";
    }
    my $lock = tree_lock($tree, 0, $option->{check});
    my $operation = read_operation($tree);
    if ($operation) {
        die "Installation is incomplete; retry a successful full make install\n" if $operation->{kind} eq 'install';
        die "Replacement recovery is unfinished; run apply to restore previous metadata\n" if $option->{check};
        eval {
            restore($tree, $operation->{files}, 1);
            finish_operation($tree);
            print "Previous metadata and inventory restored; run apply separately for a new update.\n";
            1;
        } or print STDERR "Recovery remains unfinished: $@";
        return 3;
    }
    my $inventory = load_json(locate($tree, $INVENTORY_NAME));
    if ($option->{check}) {
        my ($changes, $updated) = refresh_plan($tree, $inventory);
        if (@$changes || !same_json($updated, $inventory)) {
            print "Managed metadata requires refresh for $tree.\n";
            return 1;
        }
        validate_release_tree($tree, $inventory);
        print "Managed metadata is current for $tree.\n";
        report_external($inventory);
        return 0;
    }
    return apply_refresh($tree, $inventory);
}

STDOUT->autoflush(1);
my $status;
eval {
    $status = main(@ARGV);
    defined $status or die "internal error: main returned no exit status\n";
    1;
} or do {
    my $error = $@;
    print STDERR "Metadata error: $error";
    $status = 2;
};
exit $status;

__END__

=head1 NAME

relocateEpicsEnv.pl - Inspect or refresh the managed metadata of an installed EPICS tree

=head1 SYNOPSIS

B<perl relocateEpicsEnv.pl> B<--check> [B<--tree> I<absolute_tree>]

B<perl relocateEpicsEnv.pl> B<--apply> [B<--tree> I<absolute_tree>]

=head1 DESCRIPTION

An installed EPICS tree records the build and service metadata it manages in
F<.epics-env-paths.json>. After the complete tree is moved, B<--apply>
rewrites the managed paths to the new root, keeps verified backups under
F<.epics-env-backups>, and validates the result with the real EPICS release
parser and consistency checker. Without B<--tree> the tree is the directory
that holds this installed file.

=head1 OPTIONS

=over 4

=item B<--check>

Inspect the managed metadata without writing.

=item B<--apply>

Refresh the managed paths, or recover an unfinished replacement.

=item B<--tree> I<absolute_tree>

Select the installed tree explicitly.

=item B<--help>, B<-h>

Show this help and exit.

=back

=head1 EXIT STATUS

=over 4

=item B<--check>

0 when the managed metadata is current, 1 when it needs a refresh, 2 on
invalid input, incomplete installation, or unfinished recovery.

=item B<--apply>

0 after a complete refresh or a verified no-op, 2 on a preflight failure or
incomplete installation, 3 when a replacement fails or an unfinished recovery
is handled, including a successful rollback.

=back

=cut
