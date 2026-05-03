# FocalKit

Binary Swift Package distribution for **FocalKit** — a tunable, restylable iOS
barcode-scanning SDK built on Apple's Vision framework. SwiftUI-first, zero
runtime dependencies beyond AVFoundation and Vision.

> This repository is **manifest-only**. It contains a single `Package.swift`
> that points Swift Package Manager at the signed XCFramework attached to each
> release of the (private) source repository. The framework source is not
> published here.

## Installation

### Swift Package Manager (Xcode)

In Xcode: **File - Add Package Dependencies...** and enter:

```
https://github.com/anandrajr/focal-kit-ios-sdk.git
```

Choose the **Up to Next Major Version** rule and start from the latest tagged
release.

### Swift Package Manager (Package.swift)

```swift
dependencies: [
    .package(url: "https://github.com/anandrajr/focal-kit-ios-sdk.git", from: "0.1.0")
],
targets: [
    .target(
        name: "YourApp",
        dependencies: [
            .product(name: "FocalKit", package: "focal-kit-ios-sdk")
        ]
    )
]
```

## Quick start

```swift
import FocalKit

// 1. Request camera permission (call once at app launch)
let status = await CaptureContext.requestCameraAccess()
guard status == .authorized else { /* handle denial */ return }

// 2. Create the context and capture facade
let context = try CaptureContext()
let capture = BarcodeCapture(context: context, settings: .init())

// 3. Drop the view into your SwiftUI hierarchy
BarcodeCaptureView(capture: capture)
    .onBarcodeScanned { barcode in
        print(barcode.symbology, barcode.payload)
    }
    .overlay(BarcodeCaptureOverlay(style: .defaultHighlight))
    .ignoresSafeArea()
```

Remember to add `NSCameraUsageDescription` to your app's `Info.plist`.

## Example app

A runnable Swift Package demo is included in [`Examples/FocalKitDemo/`](Examples/FocalKitDemo/).
It covers every major API surface — live scanning, listener protocol, single
symbology, torch control, region of interest, duplicate filtering, static image
decode, and camera permission handling.

To run it:

```
open Examples/FocalKitDemo/Package.swift
```

See [`Examples/FocalKitDemo/README.md`](Examples/FocalKitDemo/README.md) for the full screen map.

## Versioning

This repo's tags mirror the source repo's tags one-for-one. Every `vX.Y.Z` here
corresponds to a `vX.Y.Z` release in the source repo, and the manifest pins to
the matching `FocalKit-X.Y.Z.xcframework.zip` asset by SPM-canonical SHA256
checksum. SwiftPM verifies the checksum on download — a tampered binary will
fail integrity validation before it is linked.

## Platforms

- iOS 17 and later
- iOS Simulator (Apple Silicon and Intel)

## Documentation

API documentation is published at
[arrcade.dev/docs/focalkit](https://arrcade.dev/docs/focalkit/documentation/focalkit/).

## Licence

Distribution of the FocalKit XCFramework is governed by the licence shipped
inside each release archive. The contents of *this* repository
(`Package.swift`, `README.md`, `Examples/`) are MIT licensed.

## Reporting issues

Issues, feature requests, and integration questions:
[ARRcade contact](https://arrcade.dev).

