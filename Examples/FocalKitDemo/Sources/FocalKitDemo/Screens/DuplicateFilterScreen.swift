// DuplicateFilterScreen.swift
// Demonstrates the DuplicateFilter suppression window.
//
// Key APIs demonstrated:
//   • DuplicateFilter(window: 2.0)           — suppress the same barcode for 2 s
//   • DuplicateFilter.disabled               — emit every barcode on every frame
//   • BarcodeCaptureSettings(duplicateFilter:)
//
// The counter shows how many emissions survived the filter vs. how many
// distinct payloads have been seen — making the suppression effect visible.

import SwiftUI
import FocalKit

// MARK: - View model

@Observable
final class DuplicateFilterViewModel {
    // Each increment represents a barcode that survived the filter window.
    var totalFilteredScans: Int = 0
    var uniquePayloads: Set<String> = []
    var lastScanTime: Date?
    var errorMessage: String?
    var capture: BarcodeCapture?

    private static let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .none
        f.timeStyle = .medium
        return f
    }()

    var lastScanTimeString: String {
        guard let time = lastScanTime else { return "—" }
        return Self.timeFormatter.string(from: time)
    }

    var uniqueCount: Int { uniquePayloads.count }

    init() {
        // Explicit 2-second window — same as the SDK default, shown explicitly
        // here so the value is obvious in code.
        let settings = BarcodeCaptureSettings(
            duplicateFilter: DuplicateFilter(window: 2.0)
        )
        switch BarcodeCapture.makeForDemo(settings: settings) {
        case .success(let bc):
            capture = bc
        case .failure(let message):
            errorMessage = message
        }
    }

    func recordScan(_ barcode: Barcode) {
        totalFilteredScans += 1
        uniquePayloads.insert(barcode.payload)
        lastScanTime = barcode.timestamp
    }
}

// MARK: - View

struct DuplicateFilterScreen: View {
    @State private var viewModel = DuplicateFilterViewModel()

    var body: some View {
        CameraScreenChrome(
            capture: viewModel.capture,
            errorMessage: viewModel.errorMessage,
            onScanned: { barcode in viewModel.recordScan(barcode) }
        ) {
            VStack(spacing: 12) {
                Label("2-second duplicate suppression active", systemImage: "timer")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                HStack(spacing: 24) {
                    VStack {
                        Text("\(viewModel.totalFilteredScans)")
                            .font(.largeTitle.monospacedDigit())
                            .bold()
                        Text("Total scans")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Divider().frame(height: 40)

                    VStack {
                        Text("\(viewModel.uniqueCount)")
                            .font(.largeTitle.monospacedDigit())
                            .bold()
                        Text("Unique codes")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                Text("Last scan: \(viewModel.lastScanTimeString)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
        }
        .navigationTitle("Duplicate Filter")
        .navigationBarTitleDisplayMode(.inline)
    }
}
