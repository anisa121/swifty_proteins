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
            atomNode.position = SCNVector3(x: atom.xcoor, y: atom.ycoor, z: atom.zcoor)
            atomNode.geometry?.firstMaterial?.diffuse.contents = UIColor.darkGray
            moleculeNode.addChildNode(atomNode)
            atomNode.name = atom.name
            
        }
        
        for bond in ligandModelDTO.bonds {
            let startPoint = ligandModelDTO.atoms[bond.originAtom - 1]
            let endPoint = ligandModelDTO.atoms[bond.targetAtom - 1]
            let height = CGFloat((
                pow(endPoint.xcoor - startPoint.xcoor, 2)
                + pow(endPoint.ycoor - startPoint.ycoor, 2)
                + pow(endPoint.zcoor - startPoint.zcoor, 2)
            ).squareRoot())

            let midPoint = SCNVector3(x: (startPoint.xcoor + endPoint.xcoor) / 2,
                                      y: (startPoint.ycoor + endPoint.ycoor) / 2,
                                      z: (startPoint.zcoor + endPoint.zcoor) / 2)
            
            let bondNode = SCNNode(geometry: SCNCylinder(radius: 0.1, height: height))

            bondNode.position = midPoint
            bondNode.name = "\(bond.originAtom)-\(bond.targetAtom)"
            bondNode.look(at: .init(x: endPoint.xcoor,
                                    y: endPoint.ycoor,
                                    z: endPoint.zcoor),
                          up: moleculeNode.worldUp,
                          localFront: bondNode.worldUp)
            bondNode.geometry?.firstMaterial?.diffuse.contents = switch bond.bondType {
            case 1:
                UIColor.white
            case 2:
                UIColor.blue
            case 3:
                UIColor.green
            // Aromatic
            case 4:
                UIColor.red
            default:
                UIColor.orange
            }
            moleculeNode.addChildNode(bondNode)
        }
        
        return moleculeNode
    }
}
