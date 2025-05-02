//
//  SCNNode+SelectionHighlight.swift
//  swifty_proteins
//
//  Created by Stepan Nikitin on 02.05.25.
//

import SceneKit

extension SCNNode {
    // Имя для идентификации ноды обводки
    private static let outlineNodeName = "OutlineNode"

    // Добавляет обводку вокруг объекта
    func addOutline(scaleFactor: Float = 1.2,
                    outlineColor: UIColor = .systemPink,
                    transparency: CGFloat = 0.7) {
        // Удаляем существующую обводку, если она есть
        removeOutline()

        // Клонируем геометрию для обводки
        guard let geometry = self.geometry?.copy() as? SCNGeometry else { return }

        // Создаем новый узел для обводки
        let outlineNode = SCNNode(geometry: geometry)
        outlineNode.name = SCNNode.outlineNodeName
        outlineNode.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
        outlineNode.position = self.position
        outlineNode.orientation = self.orientation

        // Создаем материал для обводки
        let outlineMaterial = SCNMaterial()
        outlineMaterial.diffuse.contents = outlineColor
        outlineMaterial.transparency = transparency
        outlineMaterial.lightingModel = .constant // Равномерный цвет без теней

        // Применяем материал к геометрии обводки
        outlineNode.geometry?.materials = [outlineMaterial]

        // Настраиваем рендеринг для обводки
        outlineNode.renderingOrder = -1 // Рендерим перед оригиналом
        outlineNode.geometry?.firstMaterial?.writesToDepthBuffer = false
        outlineNode.geometry?.firstMaterial?.readsFromDepthBuffer = true
        outlineNode.geometry?.firstMaterial?.blendMode = .alpha

        // Добавляем обводку как sibling перед оригиналом
        if let parent = self.parent {
            parent.insertChildNode(outlineNode, at: 0)
        }
    }

    // Удаляет обводку
    func removeOutline() {
        // Находим и удаляем ноду обводки
        if let outlineNode = self.parent?.childNode(withName: SCNNode.outlineNodeName, recursively: false) {
            outlineNode.removeFromParentNode()
        }
    }
}
