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
    @Published var ligandModel: LigandDTO?
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
            } receiveValue: { ligandDTO in
                self.isLoading = false
                self.ligandModel = ligandDTO
            }
            .store(in: &self.cancellable)
    }
    
    func creatingLigandModel(ligandDataString: String) throws -> LigandDTO {
        print(ligandDataString)
        var atoms: [AtomType] = []
        var bonds: [BondType] = []
        let parserTypes: Array<ParsingTypeToLigandElement.Type> = [
            AtomType.self, BondType.self
        ]
        
        let lines = ligandDataString.components(separatedBy: "\n")
        
        for line in lines {
            for type in parserTypes {
                if let element = type.convertToType(singleLine: line) {
                    if let newAtom = element as? AtomType {
                        atoms.append(newAtom)
                    } else if let newBond = element as? BondType {
                        bonds.append(newBond)
                    }
                }
            }
        }
        
        guard !atoms.isEmpty else {
            throw CreatingError.fileParsingFailed
        }
        return LigandDTO(name: ligandName, atoms: atoms, bonds: bonds)
    }
}
