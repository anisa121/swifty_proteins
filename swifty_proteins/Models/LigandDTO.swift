//
//  LigandDTO.swift
//  swifty_proteins
//
//  Created by Anisa Kapateva on 05.11.2024.
//

import Foundation

struct LigandDTO {
    let name: String
    let atoms: [atomStruct]
    let bonds: [bondStruct]

    struct atomStruct {
        let id: Int
        let name: String
        let xcoor: Float
        let ycoor: Float
        let zcoor: Float
    }
    
    struct bondStruct {
        let originAtom: Int
        let targetAtom: Int
        let bondType: Int
    }
    
    
}
