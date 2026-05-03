// StaticImageDecodeScreen.swift
// Demonstrates decoding barcodes from a still image — no AVCaptureSession opened.
//
// Key APIs demonstrated:
//   • BarcodeCapture.scan(_:settings:) — static async throws, Vision-only path
//   • PhotosPicker                     — SwiftUI system picker for photo library
//   • CaptureError.invalidImage        — thrown when UIImage → CIImage fails

import SwiftUI
import PhotosUI
import UIKit
import FocalKit

// MARK: - View model

@Observable
final class StaticImageDecodeViewModel {
    var selectedItem: PhotosPickerItem?
    var selectedImage: UIImage?
    var decodedPayloads: [String] = []
    var isDecoding = false
    var decodeError: String?

    func decode() async {
        guard let item = selectedItem else { return }
        isDecoding = true
        decodedPayloads = []
        decodeError = nil

        do {
            guard let data = try await item.loadTransferable(type: Data.self),
                  let image = UIImage(data: data) else {
                decodeError = "Could not load the selected image."
                isDecoding = false
                return
            }
            selectedImage = image

            // BarcodeCapture.scan runs entirely in Vision — no camera required.
            // Returns all barcodes found whose symbology matches settings.enabledSymbologies.
            let barcodes = try await BarcodeCapture.scan(image, settings: .init())
            decodedPayloads = barcodes.map { "\($0.symbology.displayName): \($0.payload)" }

            if decodedPayloads.isEmpty {
                decodeError = "No barcodes found in the selected image."
            }
        } catch {
            decodeError = "Decode failed: \(error.localizedDescription)"
        }

        isDecoding = false
    }
}

// MARK: - Symbology display name

extension Symbology {
    var displayName: String {
        switch self {
        case .qr:         return "QR"
        case .code128:    return "Code 128"
        case .code39:     return "Code 39"
        case .ean13:      return "EAN-13"
        case .ean8:       return "EAN-8"
        case .upcA:       return "UPC-A"
        case .upcE:       return "UPC-E"
        case .pdf417:     return "PDF417"
        case .aztec:      return "Aztec"
        case .dataMatrix: return "Data Matrix"
        }
    }
}

// MARK: - View

struct StaticImageDecodeScreen: View {
    @State private var viewModel = StaticImageDecodeViewModel()
    @State private var showPicker = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Selected image preview
                if let image = viewModel.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 260)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(.separator, lineWidth: 1)
                        )
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.secondarySystemBackground))
                        .frame(height: 180)
                        .overlay(
                            Label("No image selected", systemImage: "photo")
                                .foregroundStyle(.secondary)
                        )
                }

                // Photo picker button
                Button {
                    showPicker = true
                } label: {
                    Label("Select Photo", systemImage: "photo.badge.plus")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .photosPicker(
                    isPresented: $showPicker,
                    selection: $viewModel.selectedItem,
                    matching: .images,
                    photoLibrary: .shared()
                )
                .onChange(of: viewModel.selectedItem) {
                    Task { await viewModel.decode() }
                }

                // Decode status / results
                if viewModel.isDecoding {
                    ProgressView("Decoding…")
                } else if let error = viewModel.decodeError {
                    Label(error, systemImage: "exclamationmark.circle")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .font(.subheadline)
                } else if !viewModel.decodedPayloads.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Decoded barcodes")
                            .font(.headline)
                        ForEach(viewModel.decodedPayloads, id: \.self) { payload in
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                                Text(payload)
                                    .font(.system(.body, design: .monospaced))
                                    .textSelection(.enabled)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(
                        Color(.secondarySystemBackground),
                        in: RoundedRectangle(cornerRadius: 10)
                    )
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Static Image Decode")
        .navigationBarTitleDisplayMode(.inline)
    }
}
