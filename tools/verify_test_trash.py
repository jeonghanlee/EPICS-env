#!/usr/bin/env python3
"""Exercise the shipped trash helper and callers on real temporary files."""

import os
from pathlib import Path
import stat
import subprocess
import tempfile
import unittest


REPO = Path(__file__).resolve().parent.parent
EVIDENCE = Path(tempfile.mkdtemp(prefix="epics-test-trash-"))
HELPER = REPO / "tools/test-trash.bash"


class TrashTests(unittest.TestCase):
    def setUp(self):
        self.root = EVIDENCE / self._testMethodName
        self.root.mkdir()
        self.trash = self.root / "trash"
        self.calls = 0

    def run_bash(self, args, env=None):
        self.calls += 1
        result = subprocess.run(
            ["bash", *map(str, args)], capture_output=True, text=True,
            env=dict(os.environ, **(env or {})), cwd=self.root,
        )
        (self.root / f"call-{self.calls}.out").write_text(result.stdout)
        (self.root / f"call-{self.calls}.err").write_text(result.stderr)
        return result

    def move(self, *paths, trash=None):
        return self.run_bash([
            "-c", 'source "$1"; shift; test_move_to_trash "$@"',
            "trash-test", HELPER, trash or self.trash, *paths,
        ])

    def entries(self, trash=None):
        return sorted((trash or self.trash).glob("*/entry"))

    def test_file_versions_are_preserved_without_overwrite(self):
        path = self.root / "result with spaces.log"
        for content in (b"first\x00result", b"second result", b"third result"):
            path.write_bytes(content)
            result = self.move(path)
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertEqual(result.stdout, "")
            self.assertFalse(path.exists())
        self.assertCountEqual(
            [p.read_bytes() for p in self.entries()],
            [b"first\x00result", b"second result", b"third result"],
        )
        for entry in self.entries():
            self.assertRegex(entry.parent.name, r"^\d{8}T\d{6}Z\.[A-Za-z0-9]+$")
            self.assertEqual((entry.parent / "source-path").read_text(), f"{path}\n")

    def test_directory_and_fifo_are_preserved(self):
        directory = self.root / "tree"
        directory.mkdir()
        (directory / "data").write_bytes(b"saved tree")
        fifo = self.root / "input.fifo"
        os.mkfifo(fifo)
        result = self.move(directory, fifo)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertFalse(directory.exists())
        self.assertFalse(fifo.exists())
        self.assertTrue(any(p.is_dir() and (p / "data").read_bytes() == b"saved tree" for p in self.entries()))
        self.assertTrue(any(stat.S_ISFIFO(p.lstat().st_mode) for p in self.entries()))

    def test_symlinks_move_without_moving_their_targets(self):
        target = self.root / "target"
        target.write_text("target stays")
        link = self.root / "link"
        broken = self.root / "broken"
        link.symlink_to(target)
        broken.symlink_to(self.root / "absent")
        result = self.move(link, broken)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertFalse(link.is_symlink())
        self.assertFalse(broken.is_symlink())
        self.assertEqual(target.read_text(), "target stays")
        self.assertCountEqual([os.readlink(p) for p in self.entries()], [str(target), str(self.root / "absent")])

    def test_missing_path_is_a_noop(self):
        result = self.move(self.root / "absent")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertFalse(self.trash.exists())

    def test_unsafe_paths_and_nested_trash_are_refused(self):
        source = self.root / "source"
        source.mkdir()
        (source / "evidence").write_text("keep")
        for path in ("", "/", ".", ".."):
            with self.subTest(path=path):
                self.assertNotEqual(self.move(path).returncode, 0)
        result = self.move(source, trash=source / "trash")
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual((source / "evidence").read_text(), "keep")
        self.assertFalse((source / "trash").exists())
        alias = self.root / "alias"
        alias.symlink_to(source, target_is_directory=True)
        self.assertNotEqual(self.move(source, trash=alias / "trash").returncode, 0)

    def test_destination_failure_keeps_source(self):
        self.trash.write_text("not a directory")
        source = self.root / "evidence"
        source.write_text("keep")
        result = self.move(source)
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(source.read_text(), "keep")
        self.assertEqual(self.trash.read_text(), "not a directory")

    def test_loader_wrapper_stops_after_preservation_failure(self):
        out = self.root / "out"
        out.mkdir()
        (out / "trash").write_text("blocked")
        source = self.root / "evidence"
        source.write_text("keep")
        marker = self.root / "continued"
        result = self.run_bash([
            "-c", 'source "$1"; IOCSH_TEST_OUT="$2"; iocsh_test_trash "$3"; printf continued > "$4"',
            "wrapper-test", REPO / "examples/iocsh/tests/common.bash", out, source, marker,
        ])
        self.assertEqual(result.returncode, 2)
        self.assertFalse(marker.exists())
        self.assertEqual(source.read_text(), "keep")

    def test_copy_tree_preserves_previous_copy_and_stdout(self):
        out = self.root / "out"
        dest = out / "copies/with space"
        dest.mkdir(parents=True)
        (dest / "previous").write_text("prior copy")
        result = self.run_bash([
            "-c", 'source "$1"; IOCSH_TEST_OUT="$2"; IOCSH_TEST_TREE="$3"; iocsh_test_copy_tree "$4"',
            "copy-test", REPO / "examples/iocsh/tests/common.bash", out, REPO / "commonIocsh", dest,
        ])
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(result.stdout, str(dest / "commonIocsh"))
        self.assertEqual(self.entries(out / "trash")[0].joinpath("previous").read_text(), "prior copy")
        for source in (REPO / "commonIocsh").rglob("*.iocsh"):
            self.assertEqual((dest / "commonIocsh" / source.relative_to(REPO / "commonIocsh")).read_bytes(), source.read_bytes())

    def test_runner_archives_logs_and_copies_before_failure(self):
        out = self.root / "out"
        (out / "copies").mkdir(parents=True)
        (out / "copies/evidence").write_text("prior copy")
        (out / "no-such-test.log").write_text("prior log")
        result = self.run_bash([REPO / "examples/iocsh/tests/run_all.bash", "no-such-test"], env={
            "IOCSH_TEST_OUT": str(out), "IOCSH_TEST_REPO": str(REPO),
            "IOCSH_TEST_TREE": str(self.root / "absent-tree"),
        })
        self.assertEqual(result.returncode, 1, result.stderr)
        self.assertIn("no such script", result.stderr)
        self.assertIn("run done", result.stdout)
        self.assertFalse((out / "copies").exists())
        entries = self.entries(out / "trash")
        self.assertTrue(any(p.is_dir() and (p / "evidence").read_text() == "prior copy" for p in entries))
        self.assertTrue(any(p.is_file() and p.read_text() == "prior log" for p in entries))

    def test_roundtrip_archives_clone_before_real_checkout_failure(self):
        old = self.root / "EPICS-env-roundtrip"
        old.mkdir()
        (old / "evidence").write_text("prior roundtrip")
        result = self.run_bash([
            REPO / "tools/module-check/guest-roundtrip.bash",
            "no-such-test-trash-commit", "", self.root,
        ], env={"EPICS_ENV_REPO": str(REPO)})
        self.assertEqual(result.returncode, 1, result.stderr)
        self.assertTrue((old / ".git").is_dir(), result.stderr)
        self.assertIn("no-such-test-trash-commit", result.stderr)
        self.assertEqual((self.entries()[0] / "evidence").read_text(), "prior roundtrip")

    def test_common_iocsh_exit_trap_preserves_failed_workspace(self):
        result = self.run_bash([REPO / "examples/commonIocsh/tests/verify_caputlog.sh"], env={
            "ARCH": "test-trash-no-binary", "DIST_TOP": str(self.root / "no-tree"),
            "TC32SIM": str(self.root / "no-ioc"), "COMMONIOCSH_TEST_TRASH": str(self.trash),
            "KEEP_WORKSPACE": "0", "TMPDIR": str(self.root),
        })
        self.assertEqual(result.returncode, 1, result.stderr)
        self.assertIn("example IOC not built", result.stdout)
        self.assertEqual(len(self.entries()), 1)
        self.assertTrue(self.entries()[0].is_dir())
        original = Path((self.entries()[0].parent / "source-path").read_text().strip())
        self.assertFalse(original.exists())


if __name__ == "__main__":
    print(f"Evidence retained in {EVIDENCE}", flush=True)
    unittest.main(verbosity=2)
