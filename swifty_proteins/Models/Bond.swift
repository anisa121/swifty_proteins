//
//  Bond.swift
//  swifty_proteins
//
//  Created by Stepan Nikitin on 29.03.25.
//

import Foundation

struct Bond {
    let originAtom: Int
    let targetAtom: Int
    let kind: Bond.Kind
}

extension Bond: ParsingTypeToLigandElement {
    static func decodeFrom(line: String) -> Self? {
        let sublines = line.split(separator: " ")
        guard sublines.count == 6,
              let origin = Int(sublines[0]),
              let target = Int(sublines[1]),
              let kind = Bond.Kind(rawString: String(sublines[2])) else {
            return nil
        }
        return Bond(originAtom: origin, targetAtom: target, kind: kind)
    }
}
