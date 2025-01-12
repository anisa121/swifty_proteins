//
//  SceneKitHelper.swift
//  swifty_proteins
//
//  Created by Anisa Kapateva on 04.01.2025.
//

import Foundation
import SceneKit

class SceneKitHelper {
    
    func createNode(ligandModelDTO: LigandDTO) -> SCNNode {
        let moleculeNode = SCNNode()
        
//        var testNode = SCNNode(geometry: SCNSphere(radius: 0.5))
//        testNode.position = SCNVector3(0, 0, 0)
//        testNode.geometry?.firstMaterial?.diffuse.contents = UIColor.darkGray
        
        for atom in ligandModelDTO.atoms {
            let atomNode = SCNNode(geometry: SCNSphere(radius: 0.3))
            atomNode.position = SCNVector3(x: atom.xcoor, y: atom.ycoor, z: atom.ycoor)
            atomNode.geometry?.firstMaterial?.diffuse.contents = UIColor.darkGray
            moleculeNode.addChildNode(atomNode)
            atomNode.name = atom.name
            
        }
        
        for (index, bond) in ligandModelDTO.bonds.enumerated() {
            let startPoint = ligandModelDTO.atoms[bond.originAtom - 1]
            let endPoint = ligandModelDTO.atoms[bond.targetAtom - 1]
            let height: Float = (pow(endPoint.xcoor - startPoint.xcoor, 2) + pow(endPoint.ycoor - startPoint.ycoor, 2) + pow(endPoint.zcoor - startPoint.zcoor, 2)).squareRoot()
            
            let midPoint = SCNVector3(x: (startPoint.xcoor + endPoint.xcoor) / 2,
                                      y: (startPoint.ycoor + endPoint.ycoor) / 2,
                                      z: (startPoint.zcoor + endPoint.zcoor) / 2)
            
            let bondNode = SCNNode(geometry: SCNCylinder(radius: 0.1, height: CGFloat(height)))
            bondNode.position = midPoint
            
            
        }
        
        return moleculeNode
    }
}
