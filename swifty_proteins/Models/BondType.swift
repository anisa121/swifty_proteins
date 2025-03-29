//
//  BondType.swift
//  swifty_proteins
//
//  Created by Anisa Kapateva on 29.03.2025.
//

import Foundation
import UIKit

enum BondType: Int {
    case one = 1, two, three, four
}

extension BondType {
    static func retrieveColour(for type: BondType) -> UIColor {
        return switch type {
        case .one: .white
        case .two: .blue
        case .three: .green
            //Aromatic
        case .four: .red
        }
    }
}

