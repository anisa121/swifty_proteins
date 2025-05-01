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

    /// Vector subtraction
    static func -(lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
        .init(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
    }

    /// Vector addition
    static func +(lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 { // ✅
        .init(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }

    /// Vector multiplication
    static func *(lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
        .init(x: lhs.y * rhs.z - lhs.z * rhs.y,
              y: lhs.z * rhs.x - lhs.x * rhs.z,
              z: lhs.x * rhs.y - lhs.y * rhs.x)
    }

    /// Scalar multiplication of vectors

    static func scalarProduct(_ vector1: SCNVector3, _ vector2: SCNVector3) -> Float {
        abs(vector1.length * vector2.length) * cos(angle(from: vector1, to: vector2))
    }

    /// Multiplication vector to number
    static func *(lhs: SCNVector3, rhs: Float) -> SCNVector3 {
        .init(x: lhs.x * rhs, y: lhs.y * rhs, z: lhs.z * rhs)
    }

    /// Division vector to number
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

//    acos(vector1 * vector2 / (vector1.length * vector2.length))
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

        func isApproximatelyEqualOriented(to other: Plane, tolerance: Float = 0.1) -> Bool {
            // Check if normals are approximately parallel (or anti-parallel)
            return abs(1 - scalarProduct(normal, other.normal)) < tolerance
        }
    }

    static func createPlane(through point: SCNVector3, normal: SCNVector3) -> Plane { // ✅
        return Plane(normal: normal.normalized, point: point)
    }

    static func createPlaneFromThreePoints(_ a: SCNVector3,
                                           _ b: SCNVector3,
                                           _ c: SCNVector3) -> Plane? { // ✅
        let ab = b - a
        let ac = c - a
        let normal = (ab * ac).normalized

        return Plane(normal: normal, point: a)
    }
}
