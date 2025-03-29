//
//  LigandDTO.swift
//  swifty_proteins
//
//  Created by Anisa Kapateva on 05.11.2024.
//

import Foundation

struct Ligand {
    let name: String
    let atoms: [Atom]
    let bonds: [Bond]
}

struct Atom: ParsingTypeToLigandElement {
    let id: Int
    let name: String
    let xcoor: Float
    let ycoor: Float
    let zcoor: Float
    
    static func convertToType(singleLine: String) -> Self? {
        let sublines = singleLine.split(separator: " ")
        if sublines.count != 9 {
            return nil
        }
        if let x = Float(sublines[0]), let y = Float(sublines[1]), let z = Float(sublines[2]) {
            // id = 1: temporary decision since idk what to put there
            return Atom(id: 1, name: String(sublines[3]), xcoor: x, ycoor: y, zcoor: z)
        }
        return nil
        
    }
    
    init(id: Int, name: String, xcoor: Float, ycoor: Float, zcoor: Float) {
        self.id = id
        self.name = name
        self.xcoor = xcoor
        self.ycoor = ycoor
        self.zcoor = zcoor
    }

}

struct Bond: ParsingTypeToLigandElement {
    let originAtom: Int
    let targetAtom: Int
    let type: Int
    
    static func convertToType(singleLine: String) -> Self? {
        let sublines = singleLine.split(separator: " ")
        if sublines.count != 6 {
            return nil
        }
        if let origin = Int(sublines[0]), let target = Int(sublines[1]), let type = Int(sublines[2]) {
            return Bond(originAtom: origin, targetAtom: target, bondType: type)
        }
        return nil
    }
    
    init(originAtom: Int, targetAtom: Int, bondType: Int) {
        self.originAtom = originAtom
        self.targetAtom = targetAtom
        self.type = bondType
    }
    
}
