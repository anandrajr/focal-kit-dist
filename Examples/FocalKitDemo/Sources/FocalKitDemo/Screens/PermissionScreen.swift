// PermissionScreen.swift
// Demonstrates camera permission handling — the required first step before
// any live-camera scan screen can work.
//
// Key APIs demonstrated:
//   • CaptureContext.cameraAuthorizationStatus  — sync read, CameraAuthorizationStatus
//   • CaptureContext.requestCameraAccess()      — async, presents system prompt
//   • CameraAuthorizationStatus                 — .notDetermined / .authorized /
//                                                  .denied / .restricted
//   • UIApplication.openSettingsURLString       — deep-link to Settings when denied

import SwiftUI
import UIKit
import FocalKit

// MARK: - View model

@Observable
final class PermissionViewModel {
    var status: CameraAuthorizationStatus = CaptureContext.cameraAuthorizationStatus

    func requestAccess() async {
        status = await CaptureContext.requestCameraAccess()
    }

    func refreshStatus() {
        status = CaptureContext.cameraAuthorizationStatus
    }

    var statusDescription: String {
        switch status {
        case .notDetermined:
            return "Not Determined — the app has not asked for camera access yet."
        case .authorized:
            return "Authorized — camera access is granted."
        case .denied:
            return "Denied — the user declined camera access. Open Settings to change this."
        case .restricted:
            return "Restricted — camera access is blocked by a device or organisational policy."
        }
    }

    var statusSystemImage: String {
        switch status {
        case .notDetermined: return "questionmark.circle"
        case .authorized:    return "checkmark.circle.fill"
        case .denied:        return "xmark.circle.fill"
        case .restricted:    return "exclamationmark.triangle.fill"
        }
    }

    var statusColor: Color {
        switch status {
        case .notDetermined: return .secondary
        case .authorized:    return .green
        case .denied:        return .red
        case .restricted:    return .orange
        }
    }

    var canRequest: Bool {
        status == .notDetermined
    }
}

// MARK: - View

struct PermissionScreen: View {
    @State private var viewModel = PermissionViewModel()

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            VStack(spacing: 16) {
                Image(systemName: viewModel.statusSystemImage)
                    .font(.system(size: 64))
                    .foregroundStyle(viewModel.statusColor)

                Text("Camera Authorization")
                    .font(.title2.bold())

                Text(viewModel.statusDescription)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            VStack(spacing: 12) {
                if viewModel.canRequest {
                    Button {
                        Task { await viewModel.requestAccess() }
                    } label: {
                        Label("Request Camera Access", systemImage: "camera")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                }

                Button {
                    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                    UIApplication.shared.open(url)
                } label: {
                    Label("Open Settings", systemImage: "gear")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                Button {
                    viewModel.refreshStatus()
                } label: {
                    Label("Refresh Status", systemImage: "arrow.clockwise")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderless)
                .foregroundStyle(.secondary)
            }
            .padding(.horizontal)

            Spacer()
        }
        .navigationTitle("Camera Permission")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { viewModel.refreshStatus() }
    }
}
