//
//  Created by Vitali Kurlovich on 26.02.26.
//

import Foundation
import MathKit

extension CoreAffineTransform {
    func transform(_ point: MKPoint<CGFloat>) -> MKPoint<CGFloat> {
        let tr = transform(CGPoint(x: point.x, y: point.y))

        return .init(x: tr.x, y: tr.y)
    }
}

extension FreeDistortTransformInverseTests {
    typealias Point = MKPoint<CGFloat>

    struct PointsMap {
        let p0: Point
        let p1: Point
        let p2: Point
        let p3: Point

        init(p0: Point, p1: Point, p2: Point, p3: Point, transform: CoreAffineTransform = .identity) {
            self.p0 = transform.transform(p0)
            self.p1 = transform.transform(p1)
            self.p2 = transform.transform(p2)
            self.p3 = transform.transform(p3)
        }
    }
}

extension FreeDistortTransformInverseTests.PointsMap {
    typealias Point = MKPoint<CGFloat>

    init(_ p0: (CGFloat, CGFloat), _ p1: (CGFloat, CGFloat), _ p2: (CGFloat, CGFloat), _ p3: (CGFloat, CGFloat), _ transform: CoreAffineTransform = .identity) {
        self.init(p0: Point(x: p0.0, y: p0.1),
                  p1: Point(x: p1.0, y: p1.1),
                  p2: Point(x: p2.0, y: p2.1),
                  p3: Point(x: p3.0, y: p3.1),
                  transform: transform)
    }
}

extension FreeDistortTransformInverseTests {
    enum UVGrid {
        typealias Point = MKPoint<CGFloat>

        nonisolated static let u: [CGFloat] = [0.0, 0.25, 0.5, 0.75, 1.0]
        nonisolated static let v: [CGFloat] = [0.0, 0.25, 0.5, 0.75, 1.0]

        static var uvs: [Point] {
            var map: [Point] = []
            map.reserveCapacity(Self.u.count * Self.v.count)

            for u in Self.u {
                for v in Self.v {
                    map.append(Point(x: u, y: v))
                }
            }
            return map
        }
    }
}
