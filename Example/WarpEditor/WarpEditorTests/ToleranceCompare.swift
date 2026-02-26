//
//  Created by Vitali Kurlovich on 9.01.26.
//

import Foundation

extension FloatingPoint {
    func isEqual(to other: Self, tolerance: Self) -> Bool {
        // Ensure the tolerance is non-negative
        assert(tolerance >= 0)
        return abs(self - other) <= tolerance
    }
}

extension CGPoint {
    func isEqual(to other: Self, tolerance: CGFloat) -> Bool {
        x.isEqual(to: other.x, tolerance: tolerance) &&
            y.isEqual(to: other.y, tolerance: tolerance)
    }
}

extension CGVector {
    func isEqual(to other: Self, tolerance: CGFloat) -> Bool {
        dx.isEqual(to: other.dx, tolerance: tolerance) &&
            dy.isEqual(to: other.dy, tolerance: tolerance)
    }
}

extension CGSize {
    func isEqual(to other: Self, tolerance: CGFloat) -> Bool {
        width.isEqual(to: other.width, tolerance: tolerance) &&
            height.isEqual(to: other.height, tolerance: tolerance)
    }
}

extension CGRect {
    func isEqual(to other: Self, tolerance: CGFloat) -> Bool {
        origin.isEqual(to: other.origin, tolerance: tolerance) &&
            size.isEqual(to: other.size, tolerance: tolerance)
    }
}
