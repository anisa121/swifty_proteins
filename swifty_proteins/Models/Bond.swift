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

    static func decodeFromFailed(line: String, prevAtomNumber: Int) -> Self? {
        let sublines = line.split(separator: " ")
        guard sublines.count == 5,
              let (origin, target) = originTarget(from: String(sublines[0]),
                                                  prevAtomNumber: prevAtomNumber + 1),
              let kind = Bond.Kind(rawString: String(sublines[1])) else {
            return nil
        }
        return Bond(originIndex: origin - 1, targetIndex: target - 1, kind: kind)
    }

    private static func originTarget(from subline: String,
                                     prevAtomNumber: Int) -> (origin: Int, target: Int)? {
        var origin: Int?
        if subline.starts(with: String(prevAtomNumber)) {
            origin = prevAtomNumber
        } else if subline.starts(with: String(prevAtomNumber + 1)) {
            origin = prevAtomNumber + 1
        }
        if let origin = origin {
            let originLength = String(origin).count
            if subline.count > originLength {
                let startIndex = subline.index(subline.startIndex, offsetBy:originLength)
                let targetSubline = String(subline[startIndex...])
                if let target = Int(targetSubline) {
                    return (origin: origin, target: target)
                }
            }
        }
        return nil
    }
}
