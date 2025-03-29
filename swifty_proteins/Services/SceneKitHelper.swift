//
//  SceneKitHelper.swift
//  swifty_proteins
//
//  Created by Anisa Kapateva on 04.01.2025.
//

import Foundation
import SceneKit

class SceneKitHelper {

    func createNode(ligandModel: Ligand) -> SCNNode {
        let moleculeNode = SCNNode()

        for atom in ligandModel.atoms {
            let atomNode = SCNNode(geometry: SCNSphere(radius: 0.3))
            atomNode.position = atom.vector
            atomNode.geometry?.firstMaterial?.diffuse.contents = atom.kind.colour
            moleculeNode.addChildNode(atomNode)
            atomNode.name = atom.name
        }

        for bond in ligandModel.bonds {
            /*check if there is no error with file and bond info
             contains valid infoabout origin and targer atom*/

            let firstAtom = ligandModel.atoms[bond.originAtom - 1]
            let secondAtom = ligandModel.atoms[bond.targetAtom - 1]
            let height = firstAtom.vector.distance(to: secondAtom.vector)

            let bondNode = SCNNode(geometry: SCNCylinder(radius: 0.1,
                                                         height: CGFloat(height)))

            bondNode.position = firstAtom.vector.middle(between: secondAtom.vector)
            bondNode.name = "\(bond.originAtom)-\(bond.targetAtom)"
            bondNode.look(at: secondAtom.vector,
                          up: moleculeNode.worldUp,
                          localFront: bondNode.worldUp)
            bondNode.geometry?.firstMaterial?.diffuse.contents = bond.kind.color

            moleculeNode.addChildNode(bondNode)
        }
        return moleculeNode
    }
}
