// FocalKitDemoApp.swift
// Entry point and root navigation for the FocalKit SDK demo.
//
// Each NavigationLink corresponds to one SDK feature. Open any screen
// to see the minimal code required to use that feature.

import SwiftUI

@main
struct FocalKitDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Live Camera") {
                    NavigationLink {
                        ClosureScanScreen()
                    } label: {
                        Label("Closure Scan", systemImage: "barcode.viewfinder")
                    }

                    NavigationLink {
                        ListenerScanScreen()
                    } label: {
                        Label("Listener Protocol", systemImage: "list.bullet.rectangle")
                    }

                    NavigationLink {
                        SingleSymbologyScreen()
                    } label: {
                        Label("Single Symbology (QR only)", systemImage: "qrcode")
                    }

                    NavigationLink {
                        TorchScreen()
                    } label: {
                        Label("Torch Toggle", systemImage: "flashlight.on.fill")
                    }

                    NavigationLink {
                        RegionOfInterestScreen()
                    } label: {
                        Label("Region of Interest", systemImage: "crop")
                    }

                    NavigationLink {
                        DuplicateFilterScreen()
                    } label: {
                        Label("Duplicate Filter", systemImage: "doc.on.doc")
                    }
                }

                Section("No-Camera APIs") {
                    NavigationLink {
                        StaticImageDecodeScreen()
                    } label: {
                        Label("Static Image Decode", systemImage: "photo")
                    }

                    NavigationLink {
                        PermissionScreen()
                    } label: {
                        Label("Camera Permission", systemImage: "camera.badge.ellipsis")
                    }
                }
            }
            .navigationTitle("FocalKit Demo")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
