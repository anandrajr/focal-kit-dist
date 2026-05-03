# Changelog

All notable changes to FocalKit will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Placeholder for next release changes.

## [0.1.0] - TBD

### Added
- Initial binary XCFramework distribution via Swift Package Manager.
- `FocalKit` library target supporting iOS 17+.
- Automated release pipeline: `build-xcframework.sh` compiles and zips the
  XCFramework; `release-xcframework.sh` creates the GitHub Release, uploads
  the asset to `focal-kit-ios-sdk`, and rewrites `Package.swift` with the new
  version and SHA-256 checksum.
- DocC documentation hosted at arrcade.dev/docs/focalkit/.

