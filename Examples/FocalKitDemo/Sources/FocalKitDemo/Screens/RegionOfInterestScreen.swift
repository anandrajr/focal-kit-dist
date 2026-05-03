// RegionOfInterestScreen.swift
// Demonstrates restricting barcode detection to a sub-region of the frame.
//
// Key APIs demonstrated:
//   • RegionOfInterest(CGRect(x:y:width:height:)) — normalised 0…1 coordinates
//   • BarcodeCaptureSettings(regionOfInterest:)   — attach ROI to settings
//   • Visual indicator drawn over the active ROI using GeometryReader

import SwiftUI
import FocalKit

// MARK: - View model

@Observable
final class RegionOfInterestViewModel {
    var lastPayload: String?
    var errorMessage: String?
    var capture: BarcodeCapture?

    init() {
        // Restrict scanning to the centre 50 % of the frame.
        // Normalised coordinates: (0.25, 0.25) origin, 0.5 x 0.5 size.
        let roi = RegionOfInterest(CGRect(x: 0.25, y: 0.25, width: 0.5, height: 0.5))
        let settings = BarcodeCaptureSettings(regionOfInterest: roi)
        switch BarcodeCapture.makeForDemo(settings: settings) {
        case .success(let bc):
            capture = bc
        case .failure(let message):
            errorMessage = message
        }
    }
}

// MARK: - View

struct RegionOfInterestScreen: View {
    @State private var viewModel = RegionOfInterestViewModel()

    var body: some View {
        Group {
            if let errorMessage = viewModel.errorMessage {
                ContentUnavailableView(
                    "Camera Unavailable",
                    systemImage: "camera.slash",
                    description: Text(errorMessage)
                )
            } else if let capture = viewModel.capture {
                ZStack {
                    // Live camera preview with barcode-detection overlay.
                    BarcodeCaptureView(capture: capture)
                        .onBarcodeScanned { barcode in
                            viewModel.lastPayload = barcode.payload
                        }
                        .overlay(BarcodeCaptureOverlay(style: .defaultHighlight))
                        .ignoresSafeArea()

                    // Yellow border that mirrors the active RegionOfInterest rect.
                    // The ROI is (0.25, 0.25, 0.5, 0.5) in normalised space, so
                    // we multiply by the geometry size to get points.
                    GeometryReader { geo in
                        let roiRect = CGRect(
                            x: geo.size.width * 0.25,
                            y: geo.size.height * 0.25,
                            width: geo.size.width * 0.5,
                            height: geo.size.height * 0.5
                        )
                        Rectangle()
                            .strokeBorder(Color.yellow, lineWidth: 2)
                            .frame(width: roiRect.width, height: roiRect.height)
                            .position(x: roiRect.midX, y: roiRect.midY)
                    }

                    // Bottom status panel.
                    VStack {
                        Spacer()
                        VStack(spacing: 8) {
                            Label(
                                "Scanning active in the outlined region only",
                                systemImage: "crop"
                            )
                            .font(.caption)
                            .foregroundStyle(.secondary)

                            if let payload = viewModel.lastPayload {
                                Text("Last scanned:")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text(payload)
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            } else {
                                Text("Point camera at a barcode inside the yellow box")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.ultraThinMaterial)
                    }
                }
            }
        }
        .navigationTitle("Region of Interest")
        .navigationBarTitleDisplayMode(.inline)
    }
}
