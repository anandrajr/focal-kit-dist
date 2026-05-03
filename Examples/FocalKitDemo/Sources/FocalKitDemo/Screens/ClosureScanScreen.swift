// ClosureScanScreen.swift
// The simplest FocalKit integration — three lines to scan barcodes.
//
// Key APIs demonstrated:
//   • CaptureContext()            — wraps AVCaptureSession setup
//   • BarcodeCapture(context:settings:) — the top-level @Observable scanning facade
//   • BarcodeCaptureView(capture:)      — SwiftUI view that shows the live preview
//   • .onBarcodeScanned { barcode in }  — closure fired once per new barcode
//   • .overlay(BarcodeCaptureOverlay(style: .defaultHighlight)) — yellow highlight

import SwiftUI
import FocalKit

// MARK: - View model

@Observable
final class ClosureScanViewModel {
    var lastPayload: String?
    var errorMessage: String?
    var capture: BarcodeCapture?

    init() {
        switch BarcodeCapture.makeForDemo() {
        case .success(let bc):
            capture = bc
        case .failure(let message):
            errorMessage = message
        }
    }
}

// MARK: - View

struct ClosureScanScreen: View {
    @State private var viewModel = ClosureScanViewModel()

    var body: some View {
        CameraScreenChrome(
            capture: viewModel.capture,
            errorMessage: viewModel.errorMessage,
            onScanned: { barcode in
                viewModel.lastPayload = barcode.payload
            }
        ) {
            VStack(spacing: 8) {
                if let payload = viewModel.lastPayload {
                    Text("Last scanned:")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(payload)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                } else {
                    Text("Point camera at a barcode")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
        }
        .navigationTitle("Closure Scan")
        .navigationBarTitleDisplayMode(.inline)
    }
}
