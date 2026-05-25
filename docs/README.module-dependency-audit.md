# Module Dependency Audit Design

## Scope

This document defines the design for auditing EPICS module build dependencies
from source evidence.

**Out of scope:** dynamic ELF dependency checks are handled by
`tools/check_deps.bash`. Module configure-type classification is covered in
`README.module-management.md`.

## Problem

`configure/CONFIG_MODS_DEPS` is the build-order source of truth for this
repository, but those declarations are manually maintained. A useful Phase 4
validator must not only compare `_DEPS` against generated `RELEASE.local`
files. It must inspect the upstream module source trees and collect evidence
from Makefiles, database files, DBD files, protocol references, and source
headers.

The first implementation should therefore be an audit command, not a hard
failure gate. The audit reports evidence and confidence. A later check command
can fail the build only after the evidence rules are stable.

## Proposed Commands

```text
make audit.module-deps
make audit.module-deps MODULE=calc
make audit.module-deps FORMAT=json
make check.module-deps
```

`audit.module-deps` produces a human-readable report and can also emit JSON.
`check.module-deps` applies the strict policy gate and fails on configured
mismatch classes.

## Files

```text
tools/audit_module_deps.bash
configure/RULES_MODS_AUDIT
configure/CONFIG_MODS_AUDIT
docs/README.module-dependency-audit.md
```

`CONFIG_MODS_AUDIT` owns project-specific maps and allowlists. The script owns
source scanning and report generation. `RULES_MODS_AUDIT` exposes Make targets
and keeps the audit workflow inside the existing configure/RULES layout.

## Reference Basis

The EPICS build system uses `configure/RELEASE` top definitions to derive
include paths, DBD paths, DB paths, library paths, and bin paths for downstream
builds. Source files listed in EPICS Makefile source variables receive
generated header dependencies during the build.

Those two behaviors define the audit model:

1. A module dependency may be visible as a `RELEASE.local` macro.
2. The same dependency may also be visible as a Makefile library, DBD include,
   DB include, protocol reference, or source header include.
3. The audit must preserve source evidence because a single signal is not
   always enough to prove a required build dependency.

## Input Model

The audit starts from repository metadata already used by the build system.

- `SRC_PATH_MODULES`: defines module source directories and module keys.
- `MODS_INSTALL_LOCATIONS`: maps module keys to install names.
- `<module>_DEPS`: declares intended build prerequisites.
- `<module>_CONF_TYPE`: separates generated and custom configuration paths.
- `configure/RULES_MODS_CONFIG`: provides manually generated
  `RELEASE.local` content for custom modules.
- Generated `configure/RELEASE.local` files: provide configured dependency
  macros after `conf.*`.

The script should obtain Make-expanded values through small `make PRINT.*`
queries rather than reimplementing the Make expressions in Bash.

## Evidence Sources

The scanner should collect evidence from these source classes.

- `Makefile`: `*_LIBS`, `PROD_LIBS`, `LIB_LIBS`, `DBD +=`,
  `<name>_DBD +=`, `DB`, `DB_INSTALLS`, and installed public headers declared
  through `INC`.
- `*.dbd`: `include "module.dbd"` and `recordtype(...)` definitions.
- `*.db`, `*.template`, `*.substitutions`: `file "..."`,
  `record(type,...)`, and protocol references in `INP` and `OUT`.
- Startup command files: `dbLoadRecords`, `dbLoadTemplate`, and
  `dbLoadDatabase` references.
- C and C++ source headers: `#include <...>` and `#include "..."` mapped
  through installed public headers declared by module Makefiles.
- Generated config files: `configure/RELEASE.local`,
  `configure/CONFIG_SITE.local`, and module-specific `CONFIG_SITE` overrides.

`RELEASE.local` scanning treats module-like macros with non-empty path values as
dependency evidence. Boolean or empty local options, such as `CHECK_RELEASE=NO`
or module-specific feature switches, are configuration evidence and are not
reported as dependencies.

Documentation, license files, changelogs, and README examples should be ignored
by default. Test and example applications should be reported under a separate
context because they may not describe default production dependencies.

## Module Artifact Catalog

The audit needs a catalog that maps artifacts back to module keys.

| Artifact | Example Mapping |
| :--- | :--- |
| Release macro | `ASYN` -> `asyn`, `SNCSEQ` -> `sequencer`, `SSCAN` -> `sscan`. |
| Build target | `build.asyn` -> `asyn`. |
| Install symlink | `seq` -> `sequencer`. |
| Header | `asynDriver.h` -> `asyn`, `pvxs/version.h` -> `pvxs`. |
| DBD include | `calcSupport.dbd` -> `calc`. |
| DB file | `save_restoreStatus.db` -> `autosave`. |
| Library name | `asyn` -> `asyn`, `autosave` -> `autosave`. |

The first catalog should be generated from the source tree where possible and
completed with a small explicit alias table for names that cannot be inferred.
The required explicit aliases are expected to include `sequencer`/`SNCSEQ`/`seq`
and any module whose installed name, release macro, library name, or source key
does not match exactly.

## Evidence Classification

Each evidence item is classified before it is compared with `_DEPS`.

| Class | Meaning | Default Check Behavior |
| :--- | :--- | :--- |
| `required` | The active build path references another module directly. | Eligible for strict check. |
| `probable` | Evidence maps to one module but may be optional. | Report only at first. |
| `optional` | Evidence is in tests, examples, docs, disabled blocks, or conditional paths. | Report only. |
| `external` | The reference points to a vendor or system library outside EPICS modules. | Report separately. |
| `base` | The reference resolves to EPICS Base. | Suppress unless verbose. |
| `unknown` | The reference cannot be mapped to a known module or external allowlist. | Report as audit finding. |

Phase 4A treats generated `RELEASE.local` module macros and DBD includes as
`required` evidence. Active `Makefile` library references are reported as
`probable` until the source scanner can prove that the referencing source file
belongs to the default build path.

Source evidence expansion treats active DB and substitutions file references,
startup database loads, and startup DBD loads as `required` evidence. Active
database record types and source header includes are `probable` because they map
to support ownership but do not always prove a required link or configured
runtime dependency by themselves. The DB catalog includes source files,
Makefile `DB` or `DB_INSTALLS` declarations, and the conventional
`name.substitutions` -> `name.db` generated name so generated DB outputs can
still be resolved by name. The source header catalog is limited to installed
public headers declared through `INC`; path-qualified installed headers must
match by the same path-qualified include name.

Path context is applied before source-type classification. For example,
`iocBoot` startup loads remain `optional` even though active startup loads are
treated as `required`.

Strict mode should initially fail only on `required` missing dependencies and
unknown references from active build paths.

## Path Context

The same text has different meaning depending on where it appears.

| Context | Examples | Treatment |
| :--- | :--- | :--- |
| Active build | module `Makefile`, default `DIRS`, app `src` trees. | Candidate required dependency. |
| Installed database | `Db`, `db`, `src/Db`, installed templates. | Candidate required or probable dependency. |
| IOC boot examples | `iocBoot`, example `st.cmd`. | Optional unless default build installs it. |
| Tests and demos | `test`, `tests`, `unitTestApp`, `demoApp`, example IOC apps. | Optional by default. |
| Documentation | `docs`, `documentation`, `README`, `CHANGELOG`. | Ignored by default. |
| Platform-specific source | `os/Linux`, `os/Darwin`, `os/vxWorks`, `os/default`. | Include only when selected. |

The audit command should accept a platform selector, defaulting to the current
host platform.

```text
make audit.module-deps PLATFORM=Linux
```

## Report Shape

The human report should be grouped by module.

```text
Module Dependency Audit
Strict: NO
Source state: generated RELEASE.local files are used when present.
Platform: Linux

Module: calc
Declared: null.base build.sequencer build.sscan
Observed:
  required  sequencer  configure/RULES_MODS_CONFIG:...
  required  sscan      configure/RULES_MODS_CONFIG:...
  probable  asyn       calcApp/Makefile:...
Findings:
  none
```

The text report shows the original declared string for readability. The JSON
report stores normalized module keys so downstream tooling does not need to
remove `null.base`, strip `build.`, or apply aliases again.

The report header records that generated `RELEASE.local` files are consumed when
they exist. A clean tree that has not run `conf.*` may therefore report more
`declared-unobserved` findings than a configured tree.

```json
{
  "module": "calc",
  "declared": ["sequencer", "sscan"],
  "observed": [
    {
      "dependency": "sequencer",
      "class": "required",
      "source": "release-local",
      "path": "calc-src/configure/RELEASE.local",
      "line": 1
    },
    {
      "dependency": "sscan",
      "class": "required",
      "source": "release-local",
      "path": "calc-src/configure/RELEASE.local",
      "line": 2
    },
    {
      "dependency": "asyn",
      "class": "probable",
      "source": "make-libs",
      "path": "calcApp/Makefile",
      "line": 42
    }
  ],
  "findings": []
}
```

## Comparison Rules

The audit compares normalized module keys.

1. Remove `null.base` from declared dependencies.
2. Convert `build.<module>` to `<module>`.
3. Convert aliases to module keys through `CONFIG_MODS_AUDIT`.
4. Compare declared dependencies against observed `required` evidence.
5. Report `probable` evidence separately until the signal is promoted.
6. Report unknown active evidence even when `_DEPS` is otherwise complete.

The audit must not remove or rewrite `_DEPS`. It only reports discrepancies.

Finding labels describe the observation direction.

| Finding | Meaning |
| :--- | :--- |
| `undeclared-observed` | Evidence points to a module dependency that is not declared in `_DEPS`. |
| `declared-unobserved` | `_DEPS` declares a dependency with no matching required evidence. |
| `unknown` | Active evidence could not be mapped to a known module or allowlisted external. |

## Make Integration

`configure/RULES_MODS_AUDIT` should be included by `configure/RULES_MODS`
after module metadata is available and before user extension rules.

```makefile
.PHONY: audit.module-deps check.module-deps

AUDIT_MODULE_DEPS = bash $(TOP)/tools/audit_module_deps.bash --top $(TOP)

audit.module-deps:
	$(QUIET) $(AUDIT_MODULE_DEPS) --module "$(MODULE)" --format "$(FORMAT)" --platform "$(PLATFORM)"

check.module-deps:
	$(QUIET) $(AUDIT_MODULE_DEPS) --module "$(MODULE)" --format "$(FORMAT)" --platform "$(PLATFORM)" --strict
```

The final implementation should keep command lines readable in the Makefile.
If the argument list grows, move defaults into `CONFIG_MODS_AUDIT` and pass the
minimum required flags.

The script treats an empty `MODULE` value as all modules and an empty `FORMAT`
value as the default human-readable text report. In strict mode,
`check.module-deps` exits with code 2 when a strict finding is present.

## Implementation Phases

### Phase 4A: Inventory Report

Create `tools/audit_module_deps.bash` with read-only scanning and a JSON/text
report. No hard failure except invalid input or unreadable source paths.

Minimum coverage:

1. Parse module keys and declared `_DEPS`.
2. Scan active Makefiles for library and DBD references.
3. Scan generated `RELEASE.local` files when present.
4. Scan DBD include statements.
5. Emit unknown references and declared-vs-observed summary.

### Phase 4B: Source Evidence Expansion

Add DB, template, substitutions, protocol, startup command, and source header
scanners. Build the DB, DBD, protocol, record-type, and installed-header
catalogs from module source trees and explicit aliases.

### Phase 4C: Strict Check

Enable `make check.module-deps` after the inventory report is reviewed. The
first strict policy should fail only on:

1. `undeclared-observed`: `required` evidence points to an undeclared module
   dependency.
2. `unknown`: active evidence cannot be mapped to a known module or
   allowlisted external token.

`declared-unobserved` findings and `probable`, `optional`, and `external`
evidence remain report-only under the first strict policy.

Strict policy violations exit with code 2. Report output stays on stdout,
including valid JSON when `FORMAT=json`; the strict failure summary is written
to stderr.

### Phase 4D: CI Integration

Add the strict check to CI only after the source scanners have at least one
reviewed baseline report. Keep `audit.module-deps` available for explanatory
review output.

## Review Checklist

Reviewers should check these design points before implementation.

1. The audit is source-evidence driven and does not treat `_DEPS` as the proof.
2. The first command is report-only, so false positives do not block builds.
3. `check_deps.bash` remains separate because it verifies ELF runtime paths.
4. Alias mapping is explicit where module names diverge.
5. Test, example, documentation, and platform-specific evidence do not become
   hard failures by default.
6. Strict mode has a narrow first policy and can be expanded after baselines are
   reviewed.

## Open Design Questions

1. Whether `iocBoot` references should become required when the module installs
   those boot files by default.
2. Whether vendor dependencies such as `open62541`, `uldaq`, `net-snmp`, and
   `libevent` should stay in the same report under the `external` class or move
   to a separate vendor audit report.
3. Whether header evidence should be promoted to `required` only when the source
   file is listed by an active EPICS Makefile variable.
