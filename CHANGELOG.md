# Changelog

All notable changes to this project are documented here. The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the project aims to
follow [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- `sysinfo-list` and `sysinfo-alist` — alternative views of the data returned
  by `sysinfo` (these symbols were previously exported but undefined).
- `uptime-duration` — system uptime as a `local-time-duration:duration`.
- `sysinfo-error` condition (subclass of `error`) carrying the syscall return
  code (`sysinfo-error-code`) and the C `errno`/`strerror` text
  (`sysinfo-error-errno`).
- FiveAM test suite (`cl-sysinfo/test`), runnable via `asdf:test-system`.
- GitHub Actions CI running the suite on SBCL and CCL.
- `LICENSE` file with the LLGPL preamble.

### Changed
- `sysinfo-list`, `sysinfo-alist` and `uptime-duration` accept an optional
  pre-fetched `info` plist, allowing a single consistent snapshot and avoiding
  redundant syscalls.
- `sysinfo` now signals the typed `sysinfo-error` instead of a generic error.
- README rewritten with a full field reference, the Linux-only requirement and
  the `:mem-unit` scaling note.

### Fixed
- The `loads` slot is groveled as `:ulong` (matching `unsigned long loads[3]`)
  rather than `:long`.

### Removed
- The struct slot names (`uptime`, `totalram`, …) are no longer exported; they
  were never callable functions.
