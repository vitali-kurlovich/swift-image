//
//  Created by Vitali Kurlovich on 9.01.26.
//

import MathKit
import SwiftUI

struct ControlPointsResolver {
    let contentGeometry: ContentGeometry
    let targetGeometry: ContentGeometry

    private let space: CoordinateSpace

    init(contentGeometry: ContentGeometry, targetGeometry: ContentGeometry) {
        self.contentGeometry = contentGeometry
        self.targetGeometry = targetGeometry
        space = CoordinateSpace(from: contentGeometry.coordinateSpace,
                                to: targetGeometry.coordinateSpace)
    }
}

extension ControlPointsResolver {
    var baseP0: CGPoint {
        let local = contentGeometry.local
        return CGPoint(x: local.minX, y: local.minY)
    }

    var baseP1: CGPoint {
        let local = contentGeometry.local
        return CGPoint(x: local.maxX, y: local.minY)
    }

    var baseP2: CGPoint {
        let local = contentGeometry.local
        return CGPoint(x: local.maxX, y: local.maxY)
    }

    var baseP3: CGPoint {
        let local = contentGeometry.local
        return CGPoint(x: local.minX, y: local.maxY)
    }
}

extension ControlPointsResolver {
    func position(p0: CGVector) -> CGPoint {
        space.transform(baseP0 + p0)
    }

    func position(p1: CGVector) -> CGPoint {
        space.transform(baseP1 + p1)
    }

    func position(p2: CGVector) -> CGPoint {
        space.transform(baseP2 + p2)
    }

    func position(p3: CGVector) -> CGPoint {
        space.transform(baseP3 + p3)
    }
}

extension ControlPointsResolver {
    func offset(p0: CGPoint) -> CGVector {
        let lp0 = space.inverseTransform(p0)
        return CGVector(lp0 - baseP0)
    }

    func offset(p1: CGPoint) -> CGVector {
        let lp1 = space.inverseTransform(p1)
        return CGVector(lp1 - baseP1)
    }

    func offset(p2: CGPoint) -> CGVector {
        let lp2 = space.inverseTransform(p2)
        return CGVector(lp2 - baseP2)
    }

    func offset(p3: CGPoint) -> CGVector {
        let lp3 = space.inverseTransform(p3)
        return CGVector(lp3 - baseP3)
    }
}
