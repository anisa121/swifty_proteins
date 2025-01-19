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
    var ligandModel: LigandDTO
    
    func makeUIView(context: Context) -> some UIView {
        let scnView = SCNView()
        scnView.allowsCameraControl = true
        scnView.backgroundColor = .white
        
        let node = SceneKitHelper().createNode(ligandModelDTO: ligandModel)
        
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
        
        return scnView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        //
    }
}
