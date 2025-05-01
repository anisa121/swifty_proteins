//
//  DetailView.swift
//  swifty_proteins
//
//  Created by Anisa Kapateva on 05.11.2024.
//

import SwiftUI
import Foundation
import Photos

struct DetailView: View {
    let modelId: String
    let ligandName: String
    @StateObject private var viewModel: DetailViewModel
    @State var showPopup = false
    @State var selectedAtomName = ""
    @State private var isSharePresented = false
    @State private var showingSaveSuccess = false
    @State private var showingSaveError = false

    init(modelId: String, ligandName: String) {
        self.modelId = modelId
        self.ligandName = ligandName
        _viewModel = StateObject(wrappedValue: DetailViewModel(ligandName: ligandName))
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack {
                if viewModel.isLoading {
                    ProgressView() { Text("Loading") }
                } else if let ligand = viewModel.ligandModel {
                    ligandView(for: ligand)
                        .ignoresSafeArea(edges: .bottom)
                } else {
                    Text("We couldn't load the ligand 3D model :(")
                }
            }

            .alert("error",
                   isPresented: Binding(
                    get: { viewModel.errorMessage != nil },
                    set: { if !$0 { viewModel.errorMessage = nil } }),
                   presenting: viewModel.errorMessage,
                   actions: { _ in
                Button("ok", role: .cancel) { viewModel.errorMessage = nil }},
                   message: { err in
                Text(viewModel.errorMessage ?? "some error happened") })

            if showPopup {
                HStack {
                    Text(descriptionTitle(for: selectedAtomName))
                        .padding(8)
                        .background(Color.gray.opacity(0.8))
                        .foregroundStyle(Color.white)
                        .clipShape(.buttonBorder)
                        .animation(.easeInOut, value: showPopup)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 30)
                        .padding(.leading, 18)
                }
            }
        }
    }

    private func ligandView(for ligand: Ligand) -> some View {
        let ligandView = LigandSceneView(showPopup: $showPopup,
                                         selectedAtomName: $selectedAtomName,
                                         ligandModel: ligand)
        return ligandView
            .navigationTitle(ligandName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {
                            if let snapshot = ligandView.takeSnapshot() {
                                shareImage(snapshot)
                            }
                        }) {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }

                        Button(action: {
                            if let snapshot = ligandView.takeSnapshot() {
                                saveToPhotoLibrary(snapshot)
                            }
                        }) {
                            Label("Save to Photos", systemImage: "photo")
                        }
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
            // ADD: Toast-style success message
            .overlay(alignment: .top) {
                if showingSaveSuccess {
                    Text("Image saved successfully!")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green.opacity(0.8))
                        .cornerRadius(8)
                        .padding(.top, 000)
                        .transition(.opacity)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    showingSaveSuccess = false
                                }
                            }
                        }
                }
            }
            .alert("Failed to save", isPresented: $showingSaveError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please allow access to Photos in Settings to save images.")
            }
    }

    private func descriptionTitle(for name: String) -> String {
        var description = name
        if let kind = Atom.Kind(rawValue: selectedAtomName) {
            description += "  - \(kind.descriptiveName)"
        }
        return description
    }

    private func shareImage(_ image: UIImage) {
        let items = [image]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            ac.popoverPresentationController?.sourceView = rootVC.view
            rootVC.present(ac, animated: true)
        }
    }

    private func saveToPhotoLibrary(_ image: UIImage) {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    withAnimation {
                        showingSaveSuccess = true
                    }
                case .denied, .restricted:
                    showingSaveError = true
                case .limited:
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    withAnimation {
                        showingSaveSuccess = true
                    }
                case .notDetermined:
                    // This shouldn't happen as we already requested authorization
                    break
                @unknown default:
                    break
                }
            }
        }
    }
}
