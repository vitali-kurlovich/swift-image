//
//  Created by Vitali Kurlovich on 26.02.26.
//

import Foundation
import MathKit

public extension FreeDistortTransform where Float == CGFloat {
    // p0 -- p1
    // |      |
    // |      |
    // p3 -- p2
    @inlinable init(p0: CGPoint, p1: CGPoint, p2: CGPoint, p3: CGPoint) {
        self.init(p0: MKPoint(p0),
                  p1: MKPoint(p1),
                  p2: MKPoint(p2),
                  p3: MKPoint(p3))
    }
}

public extension FreeDistortTransform where Float == CGFloat {
    @inlinable func transform(_ source: CGPoint) -> CGPoint {
        CGPoint(transform(MKPoint(source)))
    }

    @inlinable func inverse(_ source: CGPoint) -> CGPoint {
        CGPoint(inverse(MKPoint(source)))
    }
}

public extension FreeDistortTransform where Float == CGFloat {
    var p0: CGPoint {
        get {
            return CGPoint(p0)
        }
        set {
            self.p0 = MKPoint(newValue)
        }
    }

    var p1: CGPoint {
        get {
            return CGPoint(p1)
        }
        set {
            self.p1 = MKPoint(newValue)
        }
    }

    var p2: CGPoint {
        get {
            return CGPoint(p2)
        }
        set {
            self.p2 = MKPoint(newValue)
        }
    }

    var p3: CGPoint {
        get {
            return CGPoint(p3)
        }
        set {
            self.p3 = MKPoint(newValue)
        }
    }
}
