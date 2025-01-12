//
//  MainView.swift
//  swifty_proteins
//
//  Created by Anisa Kapateva on 04.11.2024.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        NavigationStack {
            List(viewModel.items) { item in
                NavigationLink(destination: DetailView(modelId: item.id, ligandName: item.name)) {
                    Text(item.name)
                }
            }
            .navigationTitle("Ligands List")
        }
    }
}


//#Preview {
//    MainView()
//}
