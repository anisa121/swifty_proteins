//
//  DetailViewModel.swift
//  swifty_proteins
//
//  Created by Anisa Kapateva on 05.11.2024.
//

import SwiftUI
import Combine

protocol ParsingTypeToLigandElement {
    static func convertToType(singleLine: String) -> Self?
}

enum CreatingError: Error {
    case fileParsingFailed
}

class DetailViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var ligandModel: Ligand?
    let ligandName: String
    var networkLayer = NetworkManager()
    private var cancellable = Set<AnyCancellable>()
    private var isIncorrectFile: Bool = false
    
    init(ligandName: String) {
        self.ligandName = ligandName
        fetchingLigand()
    }
    
    func fetchingLigand() {
        isLoading = true
        networkLayer.fetchLigand(name: ligandName)
            .tryMap({ str in
                try self.creatingLigandModel(ligandDataString: str)
            })
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.isLoading = false
                    self.errorMessage = "Please, try letter. \(error)"
                }
            } receiveValue: { ligand in
                self.isLoading = false
                self.ligandModel = ligand
            }
            .store(in: &self.cancellable)
    }
    
    func creatingLigandModel(ligandDataString: String) throws -> Ligand {
        print(ligandDataString)
        var atoms: [Atom] = []
        var bonds: [Bond] = []
        let parserTypes: Array<ParsingTypeToLigandElement.Type> = [
            Atom.self, Bond.self
        ]
        
        let lines = ligandDataString.components(separatedBy: "\n")
        
        for line in lines {
            for type in parserTypes {
                if let element = type.convertToType(singleLine: line) {
                    if let newAtom = element as? Atom {
                        atoms.append(newAtom)
                    } else if let newBond = element as? Bond {
                        bonds.append(newBond)
                    }
                }
            }
        }
        
        guard !atoms.isEmpty else {
            throw CreatingError.fileParsingFailed
        }
        return Ligand(name: ligandName, atoms: atoms, bonds: bonds)
    }
}
