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
            atomNode.position = SCNVector3(x: atom.xcoor, y: atom.ycoor, z: atom.zcoor)
            atomNode.geometry?.firstMaterial?.diffuse.contents = atom.kind.colour
            moleculeNode.addChildNode(atomNode)
            atomNode.name = atom.name
        }
        
        for bond in ligandModel.bonds {
            /*check if there is no error with file and bond info
             contains valid infoabout origin and targer atom*/
            
            let firstAtom = ligandModel.atoms[bond.originAtom - 1]
            let secondAtom = ligandModel.atoms[bond.targetAtom - 1]
            let height = CGFloat(
                (pow(secondAtom.xcoor - firstAtom.xcoor, 2)
                 + pow(secondAtom.ycoor - firstAtom.ycoor, 2)
                 + pow(secondAtom.zcoor - firstAtom.zcoor, 2)).squareRoot()
            )

            let midPoint = SCNVector3(x: (firstAtom.xcoor + secondAtom.xcoor) / 2,
                                      y: (firstAtom.ycoor + secondAtom.ycoor) / 2,
                                      z: (firstAtom.zcoor + secondAtom.zcoor) / 2)

            let bondNode = SCNNode(geometry: SCNCylinder(radius: 0.1, height: height))

            bondNode.position = midPoint
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
