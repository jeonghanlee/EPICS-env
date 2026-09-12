# Introduction

EPICS-env is a self-contained, reproducible build environment for EPICS
Base and a curated set of EPICS modules, managed entirely through GNU
Make. The repository lives at
[github.com/jeonghanlee/EPICS-env](https://github.com/jeonghanlee/EPICS-env).

This book collects the user-facing guides for the environment:

- [Architecture](architecture.md) — what the repository assembles, how the
  build is organized, and the gates that keep the installed tree consistent
  and relocatable.
- [EPICS Environment Parameters](reference/epics-parameters.md) — the
  environment variables recognized by EPICS Base and PVXS.

For the build quick start, supported platforms, and the prebuilt
distribution, see the repository
[README](https://github.com/jeonghanlee/EPICS-env#readme).

Cycle records (work register, test plans, carry decision records) are
maintained separately under `docs/` in the repository; they are working
records, not part of this book.
