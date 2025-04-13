//
//  Bond.swift
//  swifty_proteins
//
//  Created by Stepan Nikitin on 29.03.25.
//

import Foundation

struct Bond: Equatable {
    let id = UUID().uuidString
    let originIndex: Int
    let targetIndex: Int
    let kind: Bond.Kind
    var originAtom: Atom?
    var targetAtom: Atom?
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
        return Bond(originIndex: origin - 1, targetIndex: target - 1, kind: kind)
    }
}
