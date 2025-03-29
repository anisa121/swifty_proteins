//
//  Atom.swift
//  swifty_proteins
//
//  Created by Stepan Nikitin on 29.03.25.
//

import SceneKit.SCNNode

struct Atom {
    let id: Int
    let name: String
    let kind: Atom.Kind
    let vector: SCNVector3
}

extension Atom: ParsingTypeToLigandElement {
    static func decodeFrom(line: String) -> Self? {
        let sublines = line.split(separator: " ")
        guard sublines.count == 9,
              let x = Float(sublines[0]),
              let y = Float(sublines[1]),
              let z = Float(sublines[2]) else {
            return nil
        }
        let name = String(sublines[3])
        // id = 1: temporary decision since idk what to put there
        return Atom(id: 1,
                    name: name,
                    kind: .from(string: name),
                    vector: .init(x: x, y: y, z: z))
    }
}
