//
//  LigandSceneView.swift
//  swifty_proteins
//
//  Created by Anisa Kapateva on 03.01.2025.
//

import Foundation
import SwiftUI
import SceneKit

struct LigandSceneView: UIViewRepresentable {
    @Binding var showPopup: Bool
    @Binding var selectedNodeName: String
    var ligandModel: Ligand
    var previousNodeTapped: SCNNode?
    var selectionHighlightNode: SCNNode?
    private let scnView = SCNView()

    func makeUIView(context: Context) -> some UIView {
        scnView.allowsCameraControl = true
        scnView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)

        let node = SceneKitBuilder(model: ligandModel).makeNode()

        let camera = SCNCamera()
        camera.fieldOfView = 45
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 20)
        
        let light = SCNLight()
        light.type = .ambient
        light.color = UIColor(white: 0.6, alpha: 1.0)
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(0, 10, 10)
        
        let frontOmniLight = SCNLight()
        frontOmniLight.type = .omni
        let frontOmniNode = SCNNode()
        frontOmniNode.light = frontOmniLight
        frontOmniNode.position = SCNVector3(x: 10, y: 10, z: 10)
        
        let backOmniLight = SCNLight()
        backOmniLight.type = .omni
        let backOmniNode = SCNNode()
        backOmniNode.light = frontOmniLight
        backOmniNode.position = SCNVector3(x: 10, y: 10, z: 10)
        
        let scene = SCNScene()
        scene.rootNode.addChildNode(node)
        scene.rootNode.addChildNode(cameraNode)
        scene.rootNode.addChildNode(lightNode)
        scene.rootNode.addChildNode(frontOmniNode)
        scene.rootNode.addChildNode(backOmniNode)
        scnView.scene = scene
        
        let gestureRecognizer = UITapGestureRecognizer(target: context.coordinator,
                                                       action: #selector(Coordinator.handleTap(_:)))

        scnView.addGestureRecognizer(gestureRecognizer)

        return scnView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}

    func takeSnapshot() -> UIImage? {
        return scnView.snapshot()
    }

    class Coordinator: NSObject {
        var parent: LigandSceneView

        init(_ parent: LigandSceneView) {
            self.parent = parent
        }
        
        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            guard let scene = gesture.view as? SCNView else {
                return
            }
            let touchPlace = gesture.location(in: scene)
            let nodeRecognised = scene.hitTest(touchPlace, options: nil)
            if let node = nodeRecognised.first?.node {
                if node.name == "OutlineNode" {
                    self.removeSelection(for: node)
                } else {
                    if node == self.parent.previousNodeTapped {
                        self.removeSelection(for: node)
                    } else {
                        self.addSelection(for: node)
                    }
                }
            } else if let lastSelectedNode = self.parent.previousNodeTapped {
                self.removeSelection(for: lastSelectedNode)
            }
        }

        private func addSelection(for node: SCNNode) {
            DispatchQueue.main.async {
                self.parent.previousNodeTapped?.removeOutline()
                node.addOutline()
                self.parent.selectedNodeName = node.name ?? "Undefined"
                self.parent.showPopup = true
                self.parent.previousNodeTapped = node
            }
        }

        private func removeSelection(for node: SCNNode) {
            DispatchQueue.main.async {
                node.removeOutline()
                self.parent.showPopup.toggle()
                self.parent.previousNodeTapped = nil
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
