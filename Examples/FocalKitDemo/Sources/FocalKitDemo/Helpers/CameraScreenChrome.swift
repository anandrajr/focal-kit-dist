// CameraScreenChrome.swift
// Reusable scaffold for demo screens that present a live camera preview.
//
// Handles the three-state layout shared by most screens:
//   1. Error state   — ContentUnavailableView when camera init failed.
//   2. Loading state — nothing while capture is nil.
//   3. Running state — BarcodeCaptureView + defaultHighlight overlay +
//                      a bottom-anchored panel you supply.
//
// Screens that need a non-standard overlay (e.g. RegionOfInterestScreen
// with its GeometryReader ROI indicator, or TorchScreen with its toggle)
// compose their ZStack directly instead of using this chrome.

import SwiftUI
import FocalKit

struct CameraScreenChrome<BottomPanel: View>: View {
    let capture: BarcodeCapture?
    let errorMessage: String?
    var onScanned: (@MainActor (Barcode) -> Void)? = nil
    var captureOverlay: BarcodeCaptureOverlay = BarcodeCaptureOverlay(style: .defaultHighlight)
    @ViewBuilder var bottomPanel: () -> BottomPanel

    var body: some View {
        Group {
            if let errorMessage {
                ContentUnavailableView(
                    "Camera Unavailable",
                    systemImage: "camera.slash",
                    description: Text(errorMessage)
                )
            } else if let capture {
                ZStack(alignment: .bottom) {
                    makeCaptureView(capture: capture)
                    bottomPanel()
                }
            }
        }
    }

    @ViewBuilder
    private func makeCaptureView(capture: BarcodeCapture) -> some View {
        if let onScanned {
            BarcodeCaptureView(capture: capture)
                .onBarcodeScanned(onScanned)
                .overlay(captureOverlay)
                .ignoresSafeArea()
        } else {
            BarcodeCaptureView(capture: capture)
                .overlay(captureOverlay)
                .ignoresSafeArea()
        }
    }
}
