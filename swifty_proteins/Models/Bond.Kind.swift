//
//  Bond.Kind.swift
//  swifty_proteins
//
//  Created by Anisa Kapateva on 29.03.2025.
//

import Foundation
import UIKit

extension Bond {
    enum Kind: Int {
        case one = 1, two, three, four

        init?(rawString: String) {
            guard let value = Int(rawString) else {
                return nil
            }
            self.init(rawValue: value)
        }
    }
}

extension Bond.Kind {
    var radius: CGFloat {
        switch self {
        case .one: 0.1
        case .two: 0.07
        default: 0.05
        }
    }
}

