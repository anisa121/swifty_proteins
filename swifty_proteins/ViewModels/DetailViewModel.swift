//
//  DetailViewModel.swift
//  swifty_proteins
//
//  Created by Anisa Kapateva on 05.11.2024.
//

import SwiftUI
import Combine

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
        var atomsCount: Int = 0
        var bondsCount: Int = 0
        var atoms: [LigandDTO.atomStruct] = []
        var bonds: [LigandDTO.bondStruct] = []
        let lines = ligandDataString.components(separatedBy: "\n")
        let headerLineIndex = 3
        var atomsLinesEnd = 0
        
        for (index, value) in lines.enumerated() {
            if index == headerLineIndex {
                let subline = value.split(separator: " ")
                guard let atoms = Int(subline[0]), let bonds = Int(subline[1]) else {
                    throw CreatingError.fileParsingFailed
                }
                atomsCount = atoms
                bondsCount = bonds
                atomsLinesEnd = headerLineIndex + atomsCount
            }
            if index > headerLineIndex && index <= atomsLinesEnd {
                let atomSublines = value.split(separator: " ")
                if let x = Float(atomSublines[0]), let y = Float(atomSublines[1]),
                   let z = Float(atomSublines[2]) {
                    atoms.append(LigandDTO.atomStruct(id: index + 1, name: String(atomSublines[3]), xcoor: x, ycoor: y, zcoor: z))
                }
            }
            
            if index > atomsLinesEnd && index <= (atomsLinesEnd + bondsCount) {
                let bondSublines = value.split(separator: " ")
                if let origin = Int(bondSublines[0]), let target = Int(bondSublines[1]),
                   let type = Int(bondSublines[2]) {
                    bonds.append(LigandDTO.bondStruct(originAtom: origin, targetAtom: target, bondType: type))
                }
            }
        }
 
        guard !atoms.isEmpty else {
            throw CreatingError.fileParsingFailed
        }
        return LigandDTO(atoms: atoms, bonds: bonds)
    }
}
