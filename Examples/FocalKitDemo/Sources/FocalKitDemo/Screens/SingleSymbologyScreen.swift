// SingleSymbologyScreen.swift
// Demonstrates restricting BarcodeCaptureSettings to a single symbology.
//
// Key APIs demonstrated:
//   • BarcodeCaptureSettings(enabledSymbologies: [.qr])
//   • Symbology enum — .qr, .code128, .ean13, .upcA, .pdf417, .aztec, etc.

import SwiftUI
import FocalKit

// MARK: - View model

@Observable
final class SingleSymbologyViewModel {
    var lastPayload: String?
    var errorMessage: String?
    var capture: BarcodeCapture?

    init() {
        // Only QR codes — every other symbology is ignored.
        let settings = BarcodeCaptureSettings(enabledSymbologies: [.qr])
        switch BarcodeCapture.makeForDemo(settings: settings) {
        case .success(let bc):
            capture = bc
        case .failure(let message):
            errorMessage = message
        }
    }
}

// MARK: - View

struct SingleSymbologyScreen: View {
    @State private var viewModel = SingleSymbologyViewModel()

    var body: some View {
        CameraScreenChrome(
            capture: viewModel.capture,
            errorMessage: viewModel.errorMessage,
            onScanned: { barcode in viewModel.lastPayload = barcode.payload }
        ) {
            VStack(spacing: 8) {
                Label("Only QR codes enabled", systemImage: "checkmark.circle.fill")
                    .font(.subheadline)
                    .foregroundStyle(.green)

                if let payload = viewModel.lastPayload {
                    Text("Last QR payload:")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(payload)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                } else {
                    Text("Point camera at a QR code")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
        }
        .navigationTitle("Single Symbology (QR only)")
        .navigationBarTitleDisplayMode(.inline)
    }
}
