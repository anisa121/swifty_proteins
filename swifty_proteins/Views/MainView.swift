//
//  MainView.swift
//  swifty_proteins
//
//  Created by Anisa Kapateva on 04.11.2024.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    @State private var searchText = ""
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var biometricAuth: BiometricAuth

    var body: some View {
        NavigationStack {
            TextField("Search", text: $searchText)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 8)

            List(searchResults) { item in
                NavigationLink(destination: DetailView(modelId: item.id, ligandName: item.name)) {
                    Text(item.name)
                }
            }
            .contentMargins(12, for: .scrollContent)
            .navigationTitle("Ligands List")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    var searchResults: [LigandName] {
        if searchText.isEmpty {
            return viewModel.items
        }
        return viewModel.items.filter { $0.name.contains(searchText) }
    }
}
