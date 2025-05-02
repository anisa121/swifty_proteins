//
//  Atom.Kind.swift
//  swifty_proteins
//
//  Created by Anisa Kapateva on 29.03.2025.
//

import Foundation
import UIKit

extension Atom {
    enum Kind: String {
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
        case unknown

        static func from(string: String) -> Atom.Kind {
            Atom.Kind(rawValue: string) ?? .unknown
        }
    }
}

extension Atom.Kind {
    var color: UIColor {
        return switch self {
        case .hydrogen: UIColor(white: 0.85, alpha: 1.0)
        case .carbon: .black
        case .nitrogen: .blue
        case .oxygen: .red
        case .fluorine, .chlorine: .green
        case .bromine: .red          //make darker
        case .iron: .orange          //darker
        case .iodine: .purple        //darker
        case .phosphorus: .orange
        case .sulfur: .yellow
        case .titanium: .gray
        case .helium, .neon, .argon: .cyan
        case .lithium: .purple
        case .iridium: .systemPink
        default: .systemMint
        }
    }

    var descriptiveName: String {
        return switch self {
        case .hydrogen: "Hydrogen"
        case .carbon: "Carbon"
        case .nitrogen: "Nitrogen"
        case .oxygen: "Oxygen"
        case .fluorine: "Fluorine"
        case .chlorine: "Chlorine"
        case .bromine: "Bromine"
        case .iron: "Iron"
        case .iodine: "Iodine"
        case .phosphorus: "Phosphorus"
        case .sulfur: "Sulfur"
        case .titanium: "Titanium"
        case .helium: "Helium"
        case .neon: "Neon"
        case .argon: "Argon"
        case .lithium: "Lithium"
        case .iridium: "Iridium"
        case .unknown: "Unknown"
        }
    }
}

