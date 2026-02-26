//
//  Created by Vitali Kurlovich on 26.02.26.
//

import Foundation
import MathKit
import MathTransform

public extension FloatingPoint {
    func isEqual(to other: Self, tolerance: Self) -> Bool {
        // Ensure the tolerance is non-negative
        assert(tolerance >= 0)
        return abs(self - other) <= tolerance
    }
}

public extension CGPoint {
    func isEqual(to other: Self, tolerance: CGFloat) -> Bool {
        x.isEqual(to: other.x, tolerance: tolerance) &&
            y.isEqual(to: other.y, tolerance: tolerance)
    }
}

public extension CGSize {
    func isEqual(to other: Self, tolerance: CGFloat) -> Bool {
        width.isEqual(to: other.width, tolerance: tolerance) &&
            height.isEqual(to: other.height, tolerance: tolerance)
    }
}

public extension CGRect {
    func isEqual(to other: Self, tolerance: CGFloat) -> Bool {
        origin.isEqual(to: other.origin, tolerance: tolerance) &&
            size.isEqual(to: other.size, tolerance: tolerance)
    }
}

public extension MKPoint {
    func isEqual(to other: Self, tolerance: Float) -> Bool {
        x.isEqual(to: other.x, tolerance: tolerance) &&
            y.isEqual(to: other.y, tolerance: tolerance)
    }
}

public extension MKVector {
    func isEqual(to other: Self, tolerance: Float) -> Bool {
        dx.isEqual(to: other.dx, tolerance: tolerance) &&
            dy.isEqual(to: other.dy, tolerance: tolerance)
    }
}

public extension MKSize {
    func isEqual(to other: Self, tolerance: Float) -> Bool {
        width.isEqual(to: other.width, tolerance: tolerance) &&
            height.isEqual(to: other.height, tolerance: tolerance)
    }
}

public extension MKRect {
    func isEqual(to other: Self, tolerance: Float) -> Bool {
        origin.isEqual(to: other.origin, tolerance: tolerance) &&
            size.isEqual(to: other.size, tolerance: tolerance)
    }
}

public extension Affine2DTransform {
    func isEqual(to other: Self, tolerance: Float) -> Bool {
        m11.isEqual(to: other.m11, tolerance: tolerance) &&
            m12.isEqual(to: other.m12, tolerance: tolerance) &&
            m21.isEqual(to: other.m21, tolerance: tolerance) &&
            m22.isEqual(to: other.m22, tolerance: tolerance) &&

            tx.isEqual(to: other.tx, tolerance: tolerance) &&
            ty.isEqual(to: other.ty, tolerance: tolerance)
    }
}
