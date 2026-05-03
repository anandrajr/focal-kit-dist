// TorchScreen.swift
// Demonstrates torch (flashlight) control via CaptureContext.setTorch(_:).
//
// Key APIs demonstrated:
//   • context.isTorchAvailable           — Bool, sync read
//   • context.isTorchOn                  — Bool, async computed property
//   • context.setTorch(_ on: Bool)       — async throws
//   • CaptureError.torchUnavailable      — thrown when hardware absent/locked

import SwiftUI
import FocalKit

// MARK: - View model

@Observable
final class TorchViewModel {
    var isTorchOn: Bool = false
    var torchAvailable: Bool = false
    var errorMessage: String?
    var torchError: String?
    var capture: BarcodeCapture?
    private var captureContext: CaptureContext?

    init() {
        do {
            let context = try CaptureContext()
            captureContext = context
            torchAvailable = context.isTorchAvailable
            capture = BarcodeCapture(context: context, settings: .init())
        } catch {
            errorMessage = "Camera unavailable: \(error.localizedDescription)"
        }
    }

    func toggleTorch() async {
        guard let context = captureContext, context.isTorchAvailable else { return }
        do {
            let newState = !isTorchOn
            try await context.setTorch(newState)
            isTorchOn = newState
        } catch let error as CaptureError {
            switch error {
            case .torchUnavailable:
                torchAvailable = false
            default:
                torchError = error.localizedDescription
            }
        } catch {
            torchError = error.localizedDescription
        }
    }
}

// MARK: - View

struct TorchScreen: View {
    @State private var viewModel = TorchViewModel()

    var body: some View {
        Group {
            if let errorMessage = viewModel.errorMessage {
                ContentUnavailableView(
                    "Camera Unavailable",
                    systemImage: "camera.slash",
                    description: Text(errorMessage)
                )
            } else if let capture = viewModel.capture {
                ZStack(alignment: .bottom) {
                    BarcodeCaptureView(capture: capture)
                        .ignoresSafeArea()

                    VStack(spacing: 16) {
                        if let torchError = viewModel.torchError {
                            Label(torchError, systemImage: "exclamationmark.triangle")
                                .foregroundStyle(.red)
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                        }

                        if viewModel.torchAvailable {
                            HStack(spacing: 12) {
                                Image(
                                    systemName: viewModel.isTorchOn
                                        ? "flashlight.on.fill"
                                        : "flashlight.off.fill"
                                )
                                .font(.title2)
                                .foregroundStyle(viewModel.isTorchOn ? .yellow : .secondary)

                                Text(viewModel.isTorchOn ? "Torch is ON" : "Torch is OFF")
                                    .font(.headline)
                            }

                            Button {
                                Task { await viewModel.toggleTorch() }
                            } label: {
                                Label(
                                    viewModel.isTorchOn ? "Turn Off Torch" : "Turn On Torch",
                                    systemImage: viewModel.isTorchOn
                                        ? "flashlight.off.fill"
                                        : "flashlight.on.fill"
                                )
                                .padding(.horizontal, 24)
                                .padding(.vertical, 10)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(viewModel.isTorchOn ? .red : .yellow)
                        } else {
                            Label(
                                "Torch unavailable on Simulator",
                                systemImage: "flashlight.slash"
                            )
                            .foregroundStyle(.secondary)
                            .font(.subheadline)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.ultraThinMaterial)
                }
            }
        }
        .navigationTitle("Torch Toggle")
        .navigationBarTitleDisplayMode(.inline)
    }
}
