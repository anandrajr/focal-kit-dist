// swift-tools-version: 5.9
//
// FocalKitDemo — runnable example app for the FocalKit SDK.
//
// Depends on FocalKit via the public distribution manifest at
// https://github.com/anandrajr/focal-kit-dist.
//
// To open: double-click Package.swift in Finder, or run `open Package.swift`
// from this directory. Xcode resolves the FocalKit dependency automatically.
//
// Requires iOS 17+ device or Simulator (camera-dependent screens use a
// "Camera Unavailable" placeholder on Simulator).

import PackageDescription

let package = Package(
    name: "FocalKitDemo",
    platforms: [
        .iOS(.v17)
    ],
    dependencies: [
        // FocalKit binary distribution — pinned to latest release.
        // Xcode resolves this automatically when you open Package.swift.
        .package(
            url: "https://github.com/anandrajr/focal-kit-dist.git",
            from: "0.1.0"
        )
    ],
    targets: [
        .executableTarget(
            name: "FocalKitDemo",
            dependencies: [
                .product(name: "FocalKit", package: "focal-kit-dist")
            ],
            path: "Sources/FocalKitDemo",
            resources: [
                .process("Resources")
            ]
        )
    ]
)
