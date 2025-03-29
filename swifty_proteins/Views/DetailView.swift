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
    @State var showPopup = false
    @State var selectedAtomName = ""
    
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
                    LigandSceneView(showPopup: $showPopup, selectedAtomName: $selectedAtomName, ligandModel: ligand)
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
            
            if showPopup {
                Text(selectedAtomName)
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
