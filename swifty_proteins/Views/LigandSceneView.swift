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
    @Binding var selectedAtomName: String
    var ligandModel: Ligand
    var previousNodeTapped: SCNNode?
    
    func makeUIView(context: Context) -> some UIView {
        let scnView = SCNView()
        scnView.allowsCameraControl = true
        scnView.backgroundColor = .white
                
        let node = SceneKitHelper().createNode(ligandModel: ligandModel)
        
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
        
        let gestureRecognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        scnView.addGestureRecognizer(gestureRecognizer)
        
        return scnView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    
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
                DispatchQueue.main.async {
                    if node == self.parent.previousNodeTapped {
                        self.parent.showPopup.toggle()
                    } else {
                        self.parent.selectedAtomName = node.name ?? "Undefined"
                        self.parent.showPopup = true
                        self.parent.previousNodeTapped = node
                    }
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
