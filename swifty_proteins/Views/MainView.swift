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
    @StateObject var biometricAuth: BiometricAuth

    var body: some View {
        List(searchResults) { item in
            NavigationLink(destination: DetailView(modelId: item.id, ligandName: item.name)) {
                Text(item.name)
            }
        }
        .navigationTitle("Ligands List")
        .searchable(text: $searchText)
//        .gesture(DragGesture()
//            .onEnded({ gesture in
//                if gesture.translation.width > 100 {
//                    biometricAuth.isUnlocked = false
//                    dismiss()
//                }
//            }))
    }

    var searchResults: [LigandName] {
        if searchText.isEmpty {
            return viewModel.items
        }
        return viewModel.items.filter { $0.name.contains(searchText) }
    }
}
