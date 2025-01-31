//
//  DetailView.swift
//  swifty_proteins
//
//  Created by Anisa Kapateva on 05.11.2024.
//

import SwiftUI
import Foundation

struct DetailView: View {
    let modelId: String
    let ligandName: String
    @StateObject private var viewModel: DetailViewModel
    
    init(modelId: String, ligandName: String) {
        self.modelId = modelId
        self.ligandName = ligandName
        _viewModel = StateObject(wrappedValue: DetailViewModel(ligandName: ligandName))
    }
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView() { Text("Loading") }
            } else if let ligandDTO = viewModel.ligandModel {
                LigandSceneView(ligandModel: ligandDTO)
                    .navigationTitle(ligandName)
                    .navigationBarTitleDisplayMode(.inline)
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
        
        }
}
