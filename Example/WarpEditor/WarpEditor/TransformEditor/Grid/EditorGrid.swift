//
//  Created by Vitali Kurlovich on 1.01.26.
//

import MathKit
import MathTransform
import SwiftUI

struct EditorGrid {
    let p0: CGPoint
    let p1: CGPoint
    let p2: CGPoint
    let p3: CGPoint

    init(_ p0: CGPoint, _ p1: CGPoint, _ p2: CGPoint, _ p3: CGPoint) {
        self.p0 = p0
        self.p1 = p1
        self.p2 = p2
        self.p3 = p3
    }

    var outline: Path {
        var path = Path()

        path.move(to: p0)
        path.addLine(to: p1)
        path.addLine(to: p2)
        path.addLine(to: p3)
        path.addLine(to: p0)
        return path
    }

    var origin: Path {
        var path = Path()
        let transform = ControlPointsTransform(p0: p0, p1: p1, p2: p2, p3: p3)

        let v0 = transform.transform(CGPoint(x: 0.5, y: 0))
        let v1 = transform.transform(CGPoint(x: 0.5, y: 1))

        path.move(to: v0)
        path.addLine(to: v1)

        let h0 = transform.transform(CGPoint(x: 0, y: 0.5))
        let h1 = transform.transform(CGPoint(x: 1, y: 0.5))

        path.move(to: h0)
        path.addLine(to: h1)

        return path
    }

    var mediumGrid: Path {
        var path = Path()

        let transform = ControlPointsTransform(p0: p0, p1: p1, p2: p2, p3: p3)

        let locations = [0.25, 0.5, 0.75]

        for u in locations {
            let t0 = transform.transform(CGPoint(x: u, y: 0))
            let t1 = transform.transform(CGPoint(x: u, y: 1))

            path.move(to: t0)
            path.addLine(to: t1)
        }

        for v in locations {
            let t0 = transform.transform(CGPoint(x: 0, y: v))
            let t1 = transform.transform(CGPoint(x: 1, y: v))

            path.move(to: t0)
            path.addLine(to: t1)
        }

        return path
    }

    var smallGrid: Path {
        var path = Path()

        let transform = ControlPointsTransform(p0: p0, p1: p1, p2: p2, p3: p3)

        let locations = [0.125, 0.375, 0.5, 0.625, 0.875]

        for u in locations {
            let t0 = transform.transform(CGPoint(x: u, y: 0))
            let t1 = transform.transform(CGPoint(x: u, y: 1))

            path.move(to: t0)
            path.addLine(to: t1)
        }

        for v in locations {
            let t0 = transform.transform(CGPoint(x: 0, y: v))
            let t1 = transform.transform(CGPoint(x: 1, y: v))

            path.move(to: t0)
            path.addLine(to: t1)
        }

        return path
    }
}
