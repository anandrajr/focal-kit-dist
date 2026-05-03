// ListenerScanScreen.swift
// Demonstrates the BarcodeCaptureListener protocol — an alternative to the
// closure modifier for callers that prefer a delegate pattern (e.g. UIKit
// view controllers already conforming to a protocol).
//
// Key APIs demonstrated:
//   • BarcodeCaptureListener protocol — didScan and didUpdate callbacks
//   • capture.addListener(_:)         — registers the listener (weak reference)
//   • BarcodeCaptureSession           — carries newlyRecognized barcodes

import SwiftUI
import FocalKit

// MARK: - View model / listener

@Observable
final class ListenerScanViewModel: BarcodeCaptureListener {
    private(set) var lastPayload: String?
    private(set) var scanCount: Int = 0
    private(set) var captureError: String?

    let capture: BarcodeCapture?

    init() {
        switch BarcodeCapture.makeForDemo() {
        case .success(let bc):
            self.capture = bc
            // Register self as a listener. BarcodeCapture holds a weak reference,
            // so the view model must be kept alive by the view's @State.
            bc.addListener(self)
        case .failure(let message):
            self.capture = nil
            self.captureError = message
        }
    }

    // MARK: BarcodeCaptureListener

    /// Called once per frame for each barcode that survived the duplicate filter.
    @MainActor
    func barcodeCapture(_ capture: BarcodeCapture, didScan session: BarcodeCaptureSession) {
        guard let first = session.newlyRecognized.first else { return }
        lastPayload = first.payload
        scanCount += 1
    }

    /// Called on every processed frame — including frames with no new barcodes.
    /// Use for viewfinder feedback or frame-rate monitoring.
    @MainActor
    func barcodeCapture(_ capture: BarcodeCapture, didUpdate session: BarcodeCaptureSession) {}
}

// MARK: - View

struct ListenerScanScreen: View {
    @State private var viewModel = ListenerScanViewModel()

    var body: some View {
        ZStack {
            if let capture = viewModel.capture {
                BarcodeCaptureView(capture: capture)
                    .ignoresSafeArea()
                    .overlay(alignment: .bottom) {
                        scanOverlay
                    }
            } else {
                ContentUnavailableView(
                    "Camera Unavailable",
                    systemImage: "camera.slash",
                    description: Text(viewModel.captureError ?? "No camera on this device.")
                )
            }
        }
        .navigationTitle("Listener Protocol")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var scanOverlay: some View {
        VStack(spacing: 4) {
            Text("Last scanned (via BarcodeCaptureListener):")
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(viewModel.lastPayload ?? "–")
                .font(.headline)
                .monospacedDigit()
            Text("Scan count: \(viewModel.scanCount)")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .multilineTextAlignment(.center)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
    }
}
