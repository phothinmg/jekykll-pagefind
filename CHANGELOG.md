<!-- markdownlint-disable -->

## [Unreleased]

## [0.3.3]
### Changed

- Linux gems now build separate `gnu` and `musl` RubyGems platform variants from the same static Pagefind binaries.
- Release builds now include a generic `ruby` gem so RubyGems shows the latest version on the main gem page.
- `bin/publish` now supports non-interactive version input for CI releases.

### Added

- Added a GitHub Actions trusted publishing workflow for tag-based RubyGems releases.

## [0.3.1] - 2026-06-08

### Changed

- Reduced Pagefind logging to concise start, success, and error messages.
- Successful indexing now reports total runtime.

### Added

- Added a fixture-based smoke test for Jekyll builds that verifies Pagefind runs and emits concise logs.
- Added a GitHub Actions workflow for lint, smoke test, and host-platform gem build.

## [0.3.0] - 2026-05-17

- Major release

### Added

- Pagefind binaries , platform(window,macos,linus) and arch(x64,arm64).
- `jekyll_pagefind` options to `_config.yaml`.

<!--
https://keepachangelog.com/en/1.1.0/
Added :  for new features.
Changed : for changes in existing functionality.
Deprecated : for soon-to-be removed features.
Fixed : for any bug fixes.
Security : in case of vulnerabilities.
 -->
