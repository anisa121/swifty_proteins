//
//  SCNVector3+Helpers.swift
//  swifty_proteins
//
//  Created by Stepan Nikitin on 29.03.25.
//

import SceneKit.SCNNode

// "✅" means that function or property is using in the project

extension SCNVector3 {
    var length: Float { // ✅
        sqrt(x * x + y * y + z * z)
    }

    var normalized: SCNVector3 {
        self / length
    }

    // MARK: - Operators

    static func -(lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
        .init(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
    }

    static func +(lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 { // ✅
        .init(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }

    static func *(lhs: SCNVector3, rhs: Float) -> SCNVector3 {
        .init(x: lhs.x * rhs, y: lhs.y * rhs, z: lhs.z * rhs)
    }

    static func /(lhs: SCNVector3, rhs: Float) -> SCNVector3 { // ✅
        .init(x: lhs.x / rhs, y: lhs.y / rhs, z: lhs.z / rhs)
    }

    // MARK: - Instance methods

    func middle(between vector: SCNVector3) -> SCNVector3 { // ✅
        (self + vector) / 2
    }

    func distance(to vector: SCNVector3) -> Float {
        (self - vector).length
    }

    func projection(onto axis: SCNVector3) -> SCNVector3 {
        let normalizedAxis = axis.normalized
        let dotProduct = x * normalizedAxis.x + y * normalizedAxis.y + z * normalizedAxis.z
        return normalizedAxis * dotProduct
    }

    func rejection(from axis: SCNVector3) -> SCNVector3 {
        self - self.projection(onto: axis)
    }

    // MARK: - Static methods

    static func angle(from: SCNVector3, to: SCNVector3) -> Float {
        let dot = from.x * to.x + from.y * to.y + from.z * to.z
        let lengthProduct = from.length * to.length
        return acos(dot / lengthProduct)
    }

    static func cross(_ lhs: SCNVector3, _ rhs: SCNVector3) -> SCNVector3 {
        .init(x: lhs.y * rhs.z - lhs.z * rhs.y,
              y: lhs.z * rhs.x - lhs.x * rhs.z,
              z: lhs.x * rhs.y - lhs.y * rhs.x)
    }
}
