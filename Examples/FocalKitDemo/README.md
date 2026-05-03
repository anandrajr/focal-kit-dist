# FocalKitDemo

A runnable iOS example app showing how to integrate the FocalKit barcode-scanning
SDK. Each screen covers one feature area of the API with minimal, copy-pasteable
code.

## Prerequisites

- Xcode 15 or later
- iOS 17+ Simulator (for camera-independent screens) or a physical iOS 17+ device
  (required for all live-camera screens)

## Opening the project

```
open Examples/FocalKitDemo/Package.swift
```

Or in Finder, double-click `Package.swift`. Xcode opens the package and
automatically resolves the FocalKit dependency from
`https://github.com/anandrajr/focal-kit-dist`. No manual SPM steps needed.

Select any iOS 17+ Simulator or connected device and press Run.

> **Simulator note.** Camera-dependent screens show a "Camera Unavailable"
> placeholder when running on Simulator. The Static Image Decode and Camera
> Permission screens work fully on Simulator.

## Screen map

| File | Feature | Key APIs |
|---|---|---|
| `FocalKitDemoApp.swift` | App entry point | `@main`, `NavigationStack` |
| `Screens/ClosureScanScreen.swift` | Closure-based scan | `BarcodeCaptureView`, `.onBarcodeScanned` |
| `Screens/ListenerScanScreen.swift` | Listener protocol | `BarcodeCaptureListener`, `capture.addListener(_:)` |
| `Screens/SingleSymbologyScreen.swift` | Restrict symbologies | `BarcodeCaptureSettings(enabledSymbologies: [.qr])` |
| `Screens/TorchScreen.swift` | Torch control | `context.isTorchAvailable`, `context.setTorch(_:)` |
| `Screens/RegionOfInterestScreen.swift` | Region of interest | `RegionOfInterest(CGRect(...))` |
| `Screens/DuplicateFilterScreen.swift` | Duplicate suppression | `DuplicateFilter(window: 2.0)` |
| `Screens/StaticImageDecodeScreen.swift` | Still-image decode | `BarcodeCapture.scan(_:settings:)` |
| `Screens/PermissionScreen.swift` | Camera permission | `CaptureContext.requestCameraAccess()` |

## Minimal integration (three steps)

```swift
import FocalKit

// 1. Create the camera context (throws on Simulator / no back camera)
let context = try CaptureContext()

// 2. Create the capture facade
let capture = BarcodeCapture(context: context, settings: .init())

// 3. Drop the view into your SwiftUI hierarchy
BarcodeCaptureView(capture: capture)
    .onBarcodeScanned { barcode in
        print(barcode.symbology, barcode.payload)
    }
    .overlay(BarcodeCaptureOverlay(style: .defaultHighlight))
    .ignoresSafeArea()
```

Camera permission must be granted before the first call to `context.start()`.
See `PermissionScreen.swift` for the permission-request pattern, and remember to
add `NSCameraUsageDescription` to your app's `Info.plist`.

## Adding FocalKit to your own project

### Xcode

File > Add Package Dependencies and enter:

```
https://github.com/anandrajr/focal-kit-dist.git
```

### Package.swift

```swift
dependencies: [
    .package(url: "https://github.com/anandrajr/focal-kit-dist.git", from: "0.1.0")
],
targets: [
    .target(name: "YourTarget", dependencies: [
        .product(name: "FocalKit", package: "focal-kit-dist")
    ])
]
```

## Documentation

Full API reference: [arrcade.dev/docs/focalkit](https://arrcade.dev/docs/focalkit/documentation/focalkit/)
