#!/usr/bin/env python3
"""Exercise the manifest CLI against real filesystem changes."""

import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest


TOOL = Path(__file__).with_name("tree-manifest.py")


class ManifestTests(unittest.TestCase):
    def setUp(self):
        self.workspace = tempfile.TemporaryDirectory(prefix="tree-manifest-")
        self.addCleanup(self.workspace.cleanup)
        self.root = Path(self.workspace.name) / "source tree"
        self.root.mkdir()
        (self.root / "empty").mkdir()
        (self.root / "empty").chmod(0o755)
        (self.root / ".hidden").write_bytes(b"before\n")
        (self.root / ".hidden").chmod(0o644)
        (self.root / "link").symlink_to(".hidden")
        (self.root / "broken").symlink_to("absent")

    def run_cli(self, *arguments):
        return subprocess.run(
            [sys.executable, str(TOOL), *map(str, arguments)],
            capture_output=True, text=True, check=False,
        )

    def successful_manifest(self, root):
        result = self.run_cli(root)
        self.assertEqual(result.returncode, 0, result.stderr)
        return json.loads(result.stdout)

    def test_copy_and_each_recorded_property(self):
        before = self.successful_manifest(self.root)
        copy = self.root.with_name("copied tree")
        shutil.copytree(self.root, copy, symlinks=True)
        self.assertEqual(before, self.successful_manifest(copy))
        entries = {entry["path"]: entry for entry in before}
        self.assertEqual(entries["empty"]["type"], "directory")
        self.assertEqual(entries["broken"]["target"], "absent")

        changes = (
            lambda: (copy / ".hidden").write_bytes(b"after!\n"),
            lambda: (copy / ".hidden").chmod(0o600),
            lambda: (copy / "empty").chmod(0o700),
            lambda: (copy / "empty").rename(copy / "renamed"),
            lambda: (copy / "new").write_bytes(b"new"),
            lambda: (copy / "link").unlink(),
            lambda: (copy / "link").symlink_to("renamed"),
            lambda: (copy / "broken").unlink(),
            lambda: (copy / "broken").write_bytes(b"absent"),
        )
        previous = before
        for change in changes:
            change()
            current = self.successful_manifest(copy)
            self.assertNotEqual(previous, current)
            previous = current
        self.assertEqual(before, self.successful_manifest(self.root))

    def test_refuses_invalid_input_without_manifest(self):
        for arguments in ((), (self.root / "missing",), (self.root / ".hidden",)):
            result = self.run_cli(*arguments)
            self.assertNotEqual(result.returncode, 0)
            self.assertEqual(result.stdout, "")
            self.assertTrue(result.stderr)

    def test_refuses_special_files(self):
        os.mkfifo(self.root / "fifo")
        result = self.run_cli(self.root)
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(result.stdout, "")
        self.assertIn("Unsupported file type", result.stderr)

    @unittest.skipIf(os.geteuid() == 0, "Root bypasses directory permissions")
    def test_unreadable_directory_is_not_silently_skipped(self):
        directory = self.root / "empty"
        directory.chmod(0)
        try:
            result = self.run_cli(self.root)
            self.assertNotEqual(result.returncode, 0)
            self.assertEqual(result.stdout, "")
            self.assertIn("Permission denied", result.stderr)
        finally:
            directory.chmod(0o755)


if __name__ == "__main__":
    unittest.main()
