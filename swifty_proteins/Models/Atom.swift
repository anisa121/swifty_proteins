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
    let xcoor: Float
    let ycoor: Float
    let zcoor: Float

    var vector: SCNVector3 {
        .init(x: xcoor, y: ycoor, z: zcoor)
    }
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
        return Atom(id: 1, name: name, kind: .from(string: name), xcoor: x, ycoor: y, zcoor: z)
    }
}
