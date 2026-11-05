#!/usr/bin/env python3
"""Describe a quiescent tree's contents for comparison after copying."""

import argparse
import hashlib
import json
import os
from pathlib import Path
import stat
import sys


def scan_error(error):
    raise error


def manifest(root):
    """Record descendants without following symlinks or ignoring read errors."""
    root = root.resolve(strict=True)
    if not root.is_dir():
        raise ValueError("Expected an existing tree directory")
    entries = []
    for directory, directories, files in os.walk(
        root, followlinks=False, onerror=scan_error
    ):
        for name in directories + files:
            path = Path(directory) / name
            metadata = path.lstat()
            entry = {
                "path": path.relative_to(root).as_posix(),
                "mode": oct(stat.S_IMODE(metadata.st_mode)),
            }
            if stat.S_ISLNK(metadata.st_mode):
                entry.update(type="symlink", target=os.readlink(path))
            elif stat.S_ISDIR(metadata.st_mode):
                entry.update(type="directory")
            elif stat.S_ISREG(metadata.st_mode):
                digest = hashlib.sha256()
                with path.open("rb") as stream:
                    for block in iter(lambda: stream.read(1024 * 1024), b""):
                        digest.update(block)
                entry.update(type="file", size=metadata.st_size, sha256=digest.hexdigest())
            else:
                raise ValueError("Unsupported file type: " + str(path))
            entries.append(entry)
    return sorted(entries, key=lambda entry: entry["path"])


def main():
    parser = argparse.ArgumentParser(
        description="Write a deterministic JSON manifest of a directory's contents.",
        epilog=(
            "Keep the tree unchanged during scanning. Redirect stdout outside the tree. "
            "Records relative paths, types, modes, symlink targets, sizes and SHA-256. "
            "Does not record the root directory itself, ownership or timestamps."
        ),
    )
    parser.add_argument("tree", type=Path, help="Existing directory to inspect")
    args = parser.parse_args()
    try:
        entries = manifest(args.tree)
    except (OSError, ValueError) as error:
        print("tree-manifest.py: " + str(error), file=sys.stderr)
        return 1
    json.dump(entries, sys.stdout, indent=2)
    sys.stdout.write("\n")
    return 0


if __name__ == "__main__":
    sys.exit(main())
