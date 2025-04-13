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

    /// Multiplication vector to number
    static func *(lhs: SCNVector3, rhs: Float) -> SCNVector3 {
        .init(x: lhs.x * rhs, y: lhs.y * rhs, z: lhs.z * rhs)
    }

    /// Vector multiplication
    static func *(lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
        .init(x: lhs.y * rhs.z - lhs.z * rhs.y,
              y: lhs.z * rhs.x - lhs.x * rhs.z,
              z: lhs.x * rhs.y - lhs.y * rhs.x)
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

    static func cross(_ lhs: SCNVector3, _ rhs: SCNVector3) -> SCNVector3 { // ✅
        .init(x: lhs.y * rhs.z - lhs.z * rhs.y,
              y: lhs.z * rhs.x - lhs.x * rhs.z,
              z: lhs.x * rhs.y - lhs.y * rhs.x)
    }

    struct Plane { // ✅
        let normal: SCNVector3
        let point: SCNVector3

        func isApproximatelyEqual(to other: Plane, tolerance: Float = 0.1) -> Bool {
            // Check if normals are approximately parallel (or anti-parallel)
            let dotProduct = abs(normal.normalized.x * other.normal.normalized.x +
                                 normal.normalized.y * other.normal.normalized.y +
                                 normal.normalized.z * other.normal.normalized.z)

            guard abs(1 - dotProduct) < tolerance else { return false }

            // Check if planes are approximately at the same position
            let distanceVector = point - other.point
            let projectionLength = abs(distanceVector.x * normal.normalized.x +
                                       distanceVector.y * normal.normalized.y +
                                       distanceVector.z * normal.normalized.z)
            return projectionLength < tolerance
        }
    }

    static func createPlane(through point: SCNVector3, normal: SCNVector3) -> Plane { // ✅
        return Plane(normal: normal.normalized, point: point)
    }

    static func createPlaneFromThreePoints(_ p1: SCNVector3,
                                           _ p2: SCNVector3,
                                           _ p3: SCNVector3) -> Plane? { // ✅
        let v1 = p2 - p1
        let v2 = p3 - p1
        let normal = SCNVector3.cross(v1, v2)

        // Check if points are collinear
        guard normal.length > Float.ulpOfOne else { return nil }

        return createPlane(through: p1, normal: normal)
    }
}
