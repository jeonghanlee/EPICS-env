#!/usr/bin/env python3
"""Exercise the report CLI with retained distribution evidence and a real tree."""

import argparse
import json
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile
import unittest


TOOL = Path(__file__).with_name("distribution-report.py")


class ReportChecks(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(prefix="distribution-report-")
        self.addCleanup(self.temporary.cleanup)
        self.scratch = Path(self.temporary.name)

    def call(self, *arguments, status=0):
        result = subprocess.run([sys.executable, str(TOOL)] + [str(arg) for arg in arguments],
                                stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                                universal_newlines=True)
        self.assertEqual(result.returncode, status, result.stderr)
        if status == 2:
            self.assertEqual(result.stdout, "")
            self.assertTrue(result.stderr)
            return None
        return json.loads(result.stdout)

    def result_arguments(self):
        logs = self.evidence / "guest-logs"
        return ["results", "--source", self.source,
                "--loader-run", logs / "loader-run.log", "--loader-logs", logs / "loader",
                "--common-installed", logs / "common-installed.log",
                "--common-isolated", logs / "common-isolated.log",
                "--caputlog", logs / "caputlog/summary.json"]

    def test_recorded_summaries(self):
        report = self.call(*self.result_arguments())
        self.assertFalse(report["reported_failure"])
        self.assertGreater(report["loader"]["checks"], 0)

    def test_separate_loader_source(self):
        relative = Path("examples/iocsh/tests/run_all.bash")
        runner = self.scratch / relative
        runner.parent.mkdir(parents=True)
        shutil.copyfile(str(self.source / relative), str(runner))
        arguments = self.result_arguments() + ["--loader-source", self.scratch]
        self.assertEqual(self.call(*arguments), self.call(*self.result_arguments()))
        # A different runner order must not accept the retained run's results.
        text = runner.read_text()
        match = re.search(r"^readonly ORDER=\(\n(.*?)^\)", text, re.MULTILINE | re.DOTALL)
        self.assertIsNotNone(match)
        lines = match[1].splitlines(keepends=True)
        self.assertGreater(len(lines), 1)
        lines[0], lines[1] = lines[1], lines[0]
        runner.write_text(text[:match.start(1)] + "".join(lines) + text[match.end(1):])
        self.call(*arguments, status=2)

    def test_incomplete_or_inconsistent_logs(self):
        arguments = self.result_arguments()
        loader = Path(arguments[4]).read_text()
        first = loader.splitlines(keepends=True)[0]
        variants = [loader.replace(first, "", 1), first + loader,
                    loader[:loader.index("run done ")],
                    re.sub(r"SUMMARY ok=(\d+)",
                           lambda match: "SUMMARY ok=" + str(int(match[1]) + 1), loader, count=1)]
        self.assertNotEqual(variants[-1], loader, "Evidence needs a counted loader summary")
        changed = self.scratch / "loader.log"
        arguments[4] = changed
        for text in variants:
            with self.subTest(text=text[:80]):
                changed.write_text(text)
                self.call(*arguments, status=2)

    def test_reported_exit_failure(self):
        arguments = self.result_arguments()
        changed = self.scratch / "loader.log"
        changed.write_text(Path(arguments[4]).read_text().replace(" exit 0", " exit 1", 1))
        arguments[4] = changed
        self.assertTrue(self.call(*arguments, status=1)["reported_failure"])

    def test_malformed_failure_records(self):
        mutations = [
            ("--loader-run", "run done ",
             "verify_directives exit 1, SUMMARY ok=15 fail=\nrun done "),
            ("--common-installed", "OVERALL: PASS",
             "RESULT verify_serial.sh: FAIL (exit 1)\nOVERALL: PASS"),
            ("--common-isolated", "OVERALL: PASS",
             "OVERALL: FAIL (exit 1)\nOVERALL: PASS"),
        ]
        for option, before, after in mutations:
            arguments = self.result_arguments()
            index = arguments.index(option) + 1
            original = Path(arguments[index]).read_text()
            self.assertIn(before, original)
            changed = self.scratch / "malformed.log"
            changed.write_text(original.replace(before, after, 1))
            arguments[index] = changed
            with self.subTest(option=option):
                self.call(*arguments, status=2)

    def test_common_and_caputlog_missing_results(self):
        for option in ("--common-installed", "--common-isolated", "--caputlog"):
            arguments = self.result_arguments()
            index = arguments.index(option) + 1
            changed = self.scratch / "incomplete"
            text = Path(arguments[index]).read_text()
            if option == "--caputlog":
                data = json.loads(text)
                data["cases"].pop()
                text = json.dumps(data)
            else:
                text = text.replace("RESULT verify_linstat.sh: PASS", "", 1)
            changed.write_text(text)
            arguments[index] = changed
            with self.subTest(option=option):
                self.call(*arguments, status=2)

    def test_manifest_comparison(self):
        before = self.evidence / "installed-manifest.json"
        self.assertEqual(self.call("diff", before, before), {"added": [], "removed": [], "changed": []})
        entries = json.loads(before.read_text())
        removed = entries.pop()
        original = entries[0]["mode"]
        entries[0]["mode"] = "0o700" if original != "0o700" else "0o755"
        entries.append({"path": "report-test-directory", "type": "directory", "mode": "0o755"})
        after = self.scratch / "after.json"
        after.write_text(json.dumps(entries))
        result = self.call("diff", before, after, status=1)
        self.assertEqual(result["added"], ["report-test-directory"])
        self.assertEqual(result["removed"], [removed["path"]])
        self.assertEqual(result["changed"][0]["fields"], ["mode"])
        entries.append(entries[0])
        after.write_text(json.dumps(entries))
        self.call("diff", before, after, status=2)

    def test_real_debug_scan_and_truncation(self):
        report = self.call("debug", self.tree)
        previous = json.loads((self.evidence / "debug-sections.json").read_text())
        for key in ("elf_files", "archives", "debug_sections"):
            self.assertEqual(report[key], previous[key])
        # Corrupt a copy of an actual scanned ELF; readelf must reject it.
        source = None
        for path in sorted(self.tree.rglob("*")):
            if path.is_symlink() or not path.is_file():
                continue
            with path.open("rb") as stream:
                if stream.read(4) == b"\x7fELF":
                    source = path
                    break
        self.assertIsNotNone(source, "Candidate must contain an ELF file")
        target = self.scratch / "truncated.so"
        shutil.copyfile(str(source), str(target))
        with target.open("r+b") as stream:
            stream.truncate(32)
        self.call("debug", self.scratch, status=2)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", type=Path, help="Recorded release source checkout")
    parser.add_argument("evidence", type=Path, help="Retained run directory with guest-logs and manifests")
    parser.add_argument("tree", type=Path, help="Verified candidate tree; read only")
    args = parser.parse_args()
    ReportChecks.source = args.source.resolve(strict=True)
    ReportChecks.evidence = args.evidence.resolve(strict=True)
    ReportChecks.tree = args.tree.resolve(strict=True)
    unittest.main(argv=[sys.argv[0]], verbosity=2)


if __name__ == "__main__":
    main()
