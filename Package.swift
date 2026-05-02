// swift-tools-version: 5.9
//
// FocalKit — binary distribution manifest.
//
// This is the public, manifest-only repository for FocalKit. The framework
// source lives in a private repository; consumers integrate via the binary
// XCFramework attached to each release.
//
// To cut a new release, the release script in the source repo will rewrite
// the two marker constants below and push a new tag. Do not edit by hand.

import PackageDescription

// FOCALKIT-VERSION — bumped by scripts/release-xcframework.sh in the source repo.
let focalKitVersion = "0.0.0"

// FOCALKIT-CHECKSUM — SPM-canonical checksum of FocalKit-<version>.xcframework.zip,
// produced by `swift package compute-checksum`. Bumped by the release script.
let focalKitChecksum = "0000000000000000000000000000000000000000000000000000000000000000"

let package = Package(
    name: "FocalKit",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "FocalKit",
            targets: ["FocalKit"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "FocalKit",
            url: "https://github.com/anandrajr/focal-kit/releases/download/v\(focalKitVersion)/FocalKit-\(focalKitVersion).xcframework.zip",
            checksum: focalKitChecksum
        )
    ]
)
