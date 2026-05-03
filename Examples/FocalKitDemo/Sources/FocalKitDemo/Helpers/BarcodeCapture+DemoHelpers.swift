// BarcodeCapture+DemoHelpers.swift
// Convenience factory that centralises the CaptureContext + BarcodeCapture
// initialisation pattern used by most demo screens.

import FocalKit

extension BarcodeCapture {

    /// Creates a `BarcodeCapture` backed by the default back wide-angle camera.
    ///
    /// Returns `.success` when a real camera device is available, or `.failure`
    /// with a user-facing string when creation fails (e.g. on Simulator where
    /// no physical back camera exists).
    ///
    /// - Parameter settings: Scanning configuration. Defaults to
    ///   `BarcodeCaptureSettings()` (QR + Code 128 + EAN-13 + UPC-A, full frame,
    ///   2-second duplicate filter, torch off).
    /// - Returns: `.success(BarcodeCapture)` on a real device, `.failure(errorMessage)`
    ///   on Simulator or any host without a back camera.
    static func makeForDemo(
        settings: BarcodeCaptureSettings = BarcodeCaptureSettings()
    ) -> Result<BarcodeCapture, String> {
        do {
            let context = try CaptureContext()
            return .success(BarcodeCapture(context: context, settings: settings))
        } catch {
            return .failure("Camera unavailable: \(error.localizedDescription)")
        }
    }
}
