//
//  SceneKitBuilder.swift
//  swifty_proteins
//
//  Created by Anisa Kapateva on 04.01.2025.
//

import Foundation
import SceneKit

class SceneKitBuilder {
    let model: Ligand

    init(model: Ligand) {
        self.model = model
    }

    func makeNode() -> SCNNode {
        let moleculeNode = SCNNode()

        for atom in model.atoms {
            let atomNode = SCNNode(geometry: SCNSphere(radius: 0.3))
            atomNode.position = atom.vector
            atomNode.geometry?.firstMaterial?.diffuse.contents = atom.kind.colour
            moleculeNode.addChildNode(atomNode)
            atomNode.name = atom.name
        }

        for bond in model.bonds {
            /*check if there is no error with file and bond info
             contains valid infoabout origin and targer atom*/

            guard let originAtom = bond.originAtom,
                  let targetAtom = bond.targetAtom else { continue }
            let height = originAtom.vector.distance(to: targetAtom.vector)

            let bondNode = SCNNode(geometry: SCNCylinder(radius: bond.kind.radius, height: CGFloat(height)))

            bondNode.position = originAtom.vector.middle(between: targetAtom.vector)
            bondNode.name = "\(bond.originIndex)-\(bond.targetIndex)"
            bondNode.look(at: targetAtom.vector,
                          up: moleculeNode.worldUp,
                          localFront: bondNode.worldUp)
            bondNode.geometry?.firstMaterial?.diffuse.contents = bond.kind.color

            switch bond.kind {
            case .one:
                moleculeNode.addChildNode(bondNode)
            default:
                let nearbyAtoms = nearbyAtoms(for: bond)
                // TODO: Please use exact this plane:
                guard let plane = planeFor(bond: bond, atoms: nearbyAtoms) else {
                    moleculeNode.addChildNode(bondNode)
                    continue
                }
                // Calculate offset distance based on bond type
                let offsetDistance: Float = bond.kind == .two ? 0.1 : 0.15

                // Create a vector perpendicular to the bond direction using the plane's normal
                let bondDirection = (targetAtom.vector - originAtom.vector).normalized
                let planeNormal = SCNVector3.cross(bondDirection, plane.point).normalized
                let offset = planeNormal * offsetDistance

                // Clone the bond node and position both nodes
                let bondNode2 = bondNode.clone()

                // Offset the nodes in opposite directions
                bondNode.position = bondNode.position + offset
                bondNode2.position = bondNode2.position - offset

                moleculeNode.addChildNode(bondNode)
                moleculeNode.addChildNode(bondNode2)

                // For triple bond, add a third bond in the middle
                if case .three = bond.kind {
                    let bondNode3 = bondNode.clone()
                    bondNode3.position = originAtom.vector.middle(between: targetAtom.vector)
                    moleculeNode.addChildNode(bondNode3)
                }
            }
        }
        return moleculeNode
    }

    private func nearbyAtoms(for currentBond: Bond) -> [Atom] {
        guard let bondOriginAtom = currentBond.originAtom,
              let bondTargetAtom = currentBond.targetAtom else { return [] }
        var nearbyAtoms: [Atom] = []
        for bond in model.bonds {
            if bond != currentBond {
                guard let originAtom = bond.originAtom,
                      let targetAtom = bond.targetAtom else { continue }
                if originAtom == bondOriginAtom || originAtom == bondTargetAtom,
                   targetAtom != bondOriginAtom && targetAtom != bondTargetAtom {
                    nearbyAtoms.append(targetAtom)
                }
                if targetAtom == bondOriginAtom || targetAtom == bondTargetAtom,
                   originAtom != bondOriginAtom && originAtom != bondTargetAtom {
                    nearbyAtoms.append(originAtom)
                }
            }
        }
        return nearbyAtoms
    }

    private func planeFor(bond: Bond, atoms: [Atom]) -> SCNVector3.Plane? {
        guard let originAtom = bond.originAtom,
              let targetAtom = bond.targetAtom,
              atoms.isEmpty == false else { return nil }

        let bondVector = targetAtom.vector - originAtom.vector
        var possiblePlanes: [SCNVector3.Plane] = []

        // Create planes using bond points and each atom from the array
        for atom in atoms {
            if let plane = SCNVector3.createPlaneFromThreePoints(
                originAtom.vector,
                targetAtom.vector,
                atom.vector
            ) {
                possiblePlanes.append(plane)
            }
        }

        // Group similar planes together
        var planeGroups: [[SCNVector3.Plane]] = []
        for plane in possiblePlanes {
            var addedToGroup = false

            for (groupIndex, group) in planeGroups.enumerated() {
                if let firstPlane = group.first, plane.isApproximatelyEqual(to: firstPlane) {
                    planeGroups[groupIndex].append(plane)
                    addedToGroup = true
                    break
                }
            }

            if addedToGroup == false {
                planeGroups.append([plane])
            }
        }

        // Find the largest group of similar planes
        guard let largestGroup = planeGroups.max(by: { $0.count < $1.count }) else { return nil }

        // Calculate average normal and point for the largest group
        let averageNormal =
            largestGroup.reduce(SCNVector3(0, 0, 0)) { $0 + $1.normal } / Float(largestGroup.count)
        let averagePoint =
            largestGroup.reduce(SCNVector3(0, 0, 0)) { $0 + $1.point } / Float(largestGroup.count)

        return SCNVector3.Plane(normal: averageNormal, point: averagePoint)
    }
}
