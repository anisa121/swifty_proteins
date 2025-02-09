//
//  CPKColors.swift
//  swifty_proteins
//
//  Created by Anisa Kapateva on 10.12.2024.
//

import Foundation
import UIKit

enum BondType: Int {
    case one =  1, two, three, four
}

enum AtomType: String {
    case hydrogen = "H"
    case carbon = "C"
    case nitrogen = "N"
    case oxygen = "O"
    case fluorine = "F"
    case chlorine = "Cl"
    case bromine = "Br"
    case iron = "Fe"
    case iodine = "I"
    case phosphorus = "P"
    case sulfur = "S"
    case titanium = "Ti"
    case helium = "He"
    case neon = "Ne"
    case argon = "Ar"
    case lithium = "Li"
    case iridium = "Ir"
}

class CPKColourProvider {
    
    class func bondColour(for type: BondType) -> UIColor {
        switch type {
        case .one:
            return .white
        case .two:
            return .blue
        case .three:
            return .green
            //Aromatic
        case .four:
            return .red
        }
    }
    
    class func atomColour(for type: AtomType) -> UIColor {
        switch type {
        case .hydrogen: return UIColor(white: 0.85, alpha: 1.0)
        case .carbon: return .black
        case .nitrogen: return .blue
        case .oxygen: return .red
        case .fluorine, .chlorine: return .green
        case .bromine: return .red          //make darker
        case .iron: return .orange          //darker
        case .iodine: return .purple        //darker
        case .phosphorus: return .orange
        case .sulfur: return .yellow
        case .titanium: return .gray
        case .helium, .neon, .argon: return .cyan
        case .lithium: return .purple
        case .iridium: return .systemPink
        }
    }
}
