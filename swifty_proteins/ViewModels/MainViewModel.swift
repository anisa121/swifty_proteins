//
//  MainViewModel.swift
//  swifty_proteins
//
//  Created by Anisa Kapateva on 05.11.2024.
//

import SwiftUI

class MainViewModel: ObservableObject {
    @Published var items: [LigandName]  = []
    
    init() {
        loadData()
    }
    
    func loadData() {
        if let url = Bundle.main.url(forResource: "ligands", withExtension: "txt") {
            do {
                let content = try String(contentsOf: url, encoding: .utf8)
                let lines = content.split(separator: "\n")
                self.items = lines.map { line in
                    LigandName(id: UUID().uuidString, name: String(line))
                }
            } catch {
                print("Couldn't load ligand names \(error.localizedDescription)")
            }
        } else { print("Couldn't read ligands.txt file :\\") }
    }
}

struct LigandName: Identifiable {
    let id: String
    let name: String
}

