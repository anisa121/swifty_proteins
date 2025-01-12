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
        light.type = .omni
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(0, 10, 10)
        
        let scene = SCNScene()
        scene.rootNode.addChildNode(node)
        scene.rootNode.addChildNode(cameraNode)
        scene.rootNode.addChildNode(lightNode)
        scnView.scene = scene
        
        return scnView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        //
    }
}
