//
//  SCNNode+SelectionHighlight.swift
//  swifty_proteins
//
//  Created by Stepan Nikitin on 02.05.25.
//

import SceneKit

extension SCNNode {
    private static let outlineNodeName = "OutlineNode"

    func addOutline(scaleFactor: Float = 1.2,
                    outlineColor: UIColor = .systemPink,
                    transparency: CGFloat = 0.7) {
        removeOutline()

        guard let geometry = self.geometry?.copy() as? SCNGeometry else { return }

        let outlineNode = SCNNode(geometry: geometry)
        outlineNode.name = SCNNode.outlineNodeName
        outlineNode.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
        outlineNode.position = self.position
        outlineNode.orientation = self.orientation

        // Outline material
        let outlineMaterial = SCNMaterial()
        outlineMaterial.diffuse.contents = outlineColor
        outlineMaterial.transparency = transparency
        outlineMaterial.lightingModel = .constant

        outlineNode.geometry?.materials = [outlineMaterial]

        // Tune rendering order
        outlineNode.renderingOrder = -1
        outlineNode.geometry?.firstMaterial?.writesToDepthBuffer = false
        outlineNode.geometry?.firstMaterial?.readsFromDepthBuffer = true
        outlineNode.geometry?.firstMaterial?.blendMode = .alpha

        if let parent = self.parent {
            parent.insertChildNode(outlineNode, at: 0)
        }
    }

    func removeOutline() {
        if let outlineNode = self.parent?.childNode(withName: SCNNode.outlineNodeName, recursively: false) {
            outlineNode.removeFromParentNode()
        }
    }
}
