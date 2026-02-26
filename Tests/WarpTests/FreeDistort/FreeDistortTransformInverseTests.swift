//
//  Created by Vitali Kurlovich on 26.02.26.
//

import Foundation
import MathKit
import Testing
import WarpTransform

private let tolerance: Double = 0.000001

extension FreeDistortTransformInverseTests {}

@Suite("FreeDistortTransform Inverse Transform")
struct FreeDistortTransformInverseTests {
    @Test("Affine transform", arguments: [
        //         3 -- 2
        //         |    |
        //         0 -- 1
        PointsMap((0, 0), (1, 0), (1, 1), (0, 1)), // 0, 1, 2, 3
        PointsMap((0, 0), (1, 0), (1, 1), (0, 1), .rotate45),
        PointsMap((0, 0), (1, 0), (1, 1), (0, 1), .rotate90),
        PointsMap((0, 0), (1, 0), (1, 1), (0, 1), .rotate180),
        PointsMap((0, 0), (1, 0), (1, 1), (0, 1), .rotate270),
        PointsMap((0, 0), (1, 0), (1, 1), (0, 1), .flipHorizontal),
        PointsMap((0, 0), (1, 0), (1, 1), (0, 1), .flipVertical),
        PointsMap((0, 0), (1, 0), (1, 1), (0, 1), .scale(4).rotated(45).translated(x: 40, y: 50)),

        //         2 -- 3
        //         |    |
        //         1 -- 0
        PointsMap((1, 0), (0, 0), (0, 1), (1, 1)), // 1, 0, 3, 2
        PointsMap((1, 0), (0, 0), (0, 1), (1, 1), .translate(x: 10, y: 20)),

        //         0 -- 1
        //         |    |
        //         3 -- 2
        PointsMap((0, 1), (1, 1), (1, 0), (0, 0)), // 3, 2, 1, 0
        PointsMap((0, 1), (1, 1), (1, 0), (0, 0),
                  .scale(x: 4, y: 2)
                      .translated(x: -3, y: 2)),

        //         1 -- 0
        //         |    |
        //         2 -- 3
        PointsMap((1, 1), (0, 1), (0, 0), (1, 0)), // 2, 3, 0, 1
        PointsMap((1, 1), (0, 1), (0, 0), (1, 0), .rotate(12)),

        //         0 -- 3
        //         |    |
        //         1 -- 2
        PointsMap((1, 0), (1, 1), (0, 1), (0, 0)), // 1, 2, 3, 0
        PointsMap((1, 0), (1, 1), (0, 1), (0, 0), .scale(2)),
    ])
    func affine(_ points: PointsMap) {
        let tr = FreeDistortTransform(p0: points.p0,
                                        p1: points.p1,
                                        p2: points.p2,
                                        p3: points.p3)

        #expect(tr.isUParallel)
        #expect(tr.isVParallel)
        #expect(tr.isAffine)

        for uv in UVGrid.uvs {
            let transformed = tr.transform(uv)

            #expect(
                tr.inverse(transformed).isEqual(to: uv, tolerance: tolerance)
            )
        }
    }

    @Test("Control points", arguments: [
        //         3 -- 2
        //         |    |
        //         0 -- 1
        PointsMap((-10, -20), (10, -10), (15, 20), (-20, 15)), // 0, 1, 2, 3
        PointsMap((-10, -20), (10, -10), (15, 20), (-20, 15), .rotate45),
        PointsMap((-10, -20), (10, -10), (15, 20), (-20, 15), .rotate90),
        PointsMap((-10, -20), (10, -10), (15, 20), (-20, 15), .rotate180),
        PointsMap((-10, -20), (10, -10), (15, 20), (-20, 15), .rotate270),
        PointsMap((-10, -20), (10, -10), (15, 20), (-20, 15), .flipHorizontal),
        PointsMap((-10, -20), (10, -10), (15, 20), (-20, 15), .flipVertical),

        //         2 -- 3
        //         |    |
        //         1 -- 0
        PointsMap((10, -10), (-10, -20), (-20, 15), (15, 20)), // 1, 0, 3, 2

        //         0 -- 1
        //         |    |
        //         3 -- 2
        PointsMap((-20, 15), (15, 20), (10, -10), (-10, -20)), // 3, 2, 1, 0

        //         1 -- 0
        //         |    |
        //         2 -- 3
        PointsMap((15, 20), (-20, 15), (-10, -20), (10, -10)), // 2, 3, 0, 1

        //         0 -- 3
        //         |    |
        //         1 -- 2
        PointsMap((10, -10), (15, 20), (-20, 15), (-10, -20)), // 1, 2, 3, 0
    ])
    func pointsGrid(_ points: PointsMap) {
        let tr = FreeDistortTransform(p0: points.p0,
                                        p1: points.p1,
                                        p2: points.p2,
                                        p3: points.p3)

        #expect(tr.isUParallel == false)
        #expect(tr.isVParallel == false)
        #expect(tr.isAffine == false)

        for uv in UVGrid.uvs {
            let transformed = tr.transform(uv)

            #expect(
                tr.inverse(transformed).isEqual(to: uv, tolerance: tolerance)
            )
        }
    }

    @Test("Сrossed")
    func сrossed() {
        let transform: CoreAffineTransform = .rotate45

        let tr = FreeDistortTransform(p0: transform.transform(MKPoint(x: 0, y: 0)),
                                        p1: transform.transform(MKPoint(x: 1, y: 0)),
                                        p2: transform.transform(MKPoint(x: 0, y: 1)),
                                        p3: transform.transform(MKPoint(x: 1, y: 1)))

        let transformed = tr.transform(.init(x: 0.75, y: 0.5))
        let result = tr.inverse(transformed)

        #expect(
            tr.transform(result).isEqual(to: transformed, tolerance: tolerance)
        )
    }

    @Test("Сrossed U", arguments: [
        //         3      2
        //         | \  / |
        //         |   X  |
        //         | /   \|
        //         0      1

        PointsMap((0, 1), (1, 0), (1, 1), (0, 0)),
        PointsMap((0, 1), (1, 0), (1, 1), (0, 0), .rotate45),
        PointsMap((0, 1), (1, 0), (1, 1), (0, 0), .rotate45.translated(x: 2, y: 4)),
        PointsMap((0, 1), (1, 0), (1, 1), (0, 0), .rotate90),
        PointsMap((0, 1), (1, 0), (1, 1), (0, 0), .rotate180),
        PointsMap((0, 1), (1, 0), (1, 1), (0, 0), .rotate270),
        PointsMap((0, 1), (1, 0), (1, 1), (0, 0), .flipHorizontal),
        PointsMap((0, 1), (1, 0), (1, 1), (0, 0), .flipVertical),

    ])
    func сrossedU(_ points: PointsMap) {
        let tr = FreeDistortTransform(p0: points.p0,
                                        p1: points.p1,
                                        p2: points.p2,
                                        p3: points.p3)

        for uv in UVGrid.uvs {
            let transformed = tr.transform(uv)

            let result = tr.inverse(transformed)

            if !tr.transform(result).isEqual(to: transformed, tolerance: tolerance) {
                debugPrint(uv, transformed, result)
            }

            #expect(
                // result.isEqual(to: uv, tolerance: tolerance)
                tr.transform(result).isEqual(to: transformed, tolerance: tolerance)
            )
        }
    }

    @Test("Сrossed V", arguments: [
        //         2 --- 3
        //          \   /
        //            X
        //          /   \
        //         0 --- 1

        PointsMap((0, 0), (1, 0), (0, 1), (1, 1)),
        PointsMap((0, 0), (1, 0), (0, 1), (1, 1), .rotate45),
        PointsMap((0, 0), (1, 0), (0, 1), (1, 1), .rotate45.translated(x: 2, y: 4)),
        PointsMap((0, 0), (1, 0), (0, 1), (1, 1), .rotate90),
        PointsMap((0, 0), (1, 0), (0, 1), (1, 1), .rotate180),
        PointsMap((0, 0), (1, 0), (0, 1), (1, 1), .rotate270),
        PointsMap((0, 0), (1, 0), (0, 1), (1, 1), .flipHorizontal),
        PointsMap((0, 0), (1, 0), (0, 1), (1, 1), .flipVertical),
        ///
        PointsMap((-10, -20), (10, -10), (-20, 15), (15, 20)),
        PointsMap((-10, -20), (10, -10), (-20, 15), (15, 20), .rotate45),
        PointsMap((-10, -20), (10, -10), (-20, 15), (15, 20), .rotate45.translated(x: 2, y: 4)),
        PointsMap((-10, -20), (10, -10), (-20, 15), (15, 20), .rotate90),
        PointsMap((-10, -20), (10, -10), (-20, 15), (15, 20), .rotate180),
        PointsMap((-10, -20), (10, -10), (15, 20), (-20, 15), .rotate270),
        PointsMap((-10, -20), (10, -10), (-20, 15), (15, 20), .flipHorizontal),
        PointsMap((-10, -20), (10, -10), (-20, 15), (15, 20), .flipVertical),

    ])
    func сrossedV(_ points: PointsMap) {
        let tr = FreeDistortTransform(p0: points.p0,
                                        p1: points.p1,
                                        p2: points.p2,
                                        p3: points.p3)

        for uv in UVGrid.uvs {
            let transformed = tr.transform(uv)

            let result = tr.inverse(transformed)

            if !tr.transform(result).isEqual(to: transformed, tolerance: tolerance) {
                debugPrint(uv, transformed, result)
            }

            #expect(
                // result.isEqual(to: uv, tolerance: tolerance)
                tr.transform(result).isEqual(to: transformed, tolerance: tolerance)
            )
        }
    }

    @Test("skew", arguments: [
        //         3 -- 2
        //         |    |
        //         0 -- 1
        PointsMap((-13, -13), (10, -10), (13, 13), (-10, 10)), // 0, 1, 2, 3

        PointsMap((-13, -13), (10, -10), (13, 13), (-10, 10), .flipVertical),
        PointsMap((-13, -13), (10, -10), (13, 13), (-10, 10), .flipHorizontal),
        PointsMap((-13, -13), (10, -10), (13, 13), (-10, 10), .scale(x: -1, y: -1)),

        PointsMap((-13, -13), (10, -10), (13, 13), (-10, 10), .rotate45),
        PointsMap((-13, -13), (10, -10), (13, 13), (-10, 10), .rotate90),
        PointsMap((-13, -13), (10, -10), (13, 13), (-10, 10), .rotate180),
        PointsMap((-13, -13), (10, -10), (13, 13), (-10, 10), .rotate270),

        PointsMap((-13, -13), (10, -10), (13, 13), (-10, 10),
                  .rotate(45)
                      .translated(x: 40, y: 90)
                      .scaled(x: -1, y: -1)),

        PointsMap((-13, -13), (10, -10), (13, 13), (-10, 10),
                  .rotate(90)
                      .translated(x: 40, y: 90)
                      .scaled(x: -1, y: -1)),

        PointsMap((-13, -13), (10, -10), (13, 13), (-10, 10),
                  .rotate(180)
                      .translated(x: 40, y: 90)),

        PointsMap((-13, -13), (10, -10), (13, 13), (-10, 10), .rotate(270)),

    ])
    func skew(_ points: PointsMap) {
        let tr = FreeDistortTransform(p0: points.p0,
                                        p1: points.p1,
                                        p2: points.p2,
                                        p3: points.p3)

        for uv in UVGrid.uvs {
            let transformed = tr.transform(uv)

            #expect(
                tr.inverse(transformed).isEqual(to: uv, tolerance: tolerance)
            )
        }
    }

    @Test("Line", arguments: [
        //         3 -- 2
        //         0 -- 1
        PointsMap((0, 0), (1, 0), (1, 0), (0, 0)), // 0, 1, 2, 3
        PointsMap((0, 0), (1, 0), (1, 0), (0, 0), .rotate45),
        PointsMap((0, 0), (1, 0), (1, 0), (0, 0), .rotate90),
        PointsMap((0, 0), (1, 0), (1, 0), (0, 0), .rotate180),
        PointsMap((0, 0), (1, 0), (1, 0), (0, 0), .rotate270),
        PointsMap((0, 0), (1, 0), (1, 0), (0, 0), .flipHorizontal),
        PointsMap((0, 0), (1, 0), (1, 0), (0, 0), .flipVertical),
        PointsMap((0, 0), (1, 0), (1, 0), (0, 0), .scale(4).rotated(45).translated(x: 40, y: 50)),

        //        3 ---- 2
        //         0 -- 1
        PointsMap((0, 0), (1, 0), (2, 0), (-1, 0)), // 0, 1, 2, 3
        PointsMap((0, 0), (1, 0), (2, 0), (-1, 0), .rotate45),
        PointsMap((0, 0), (1, 0), (2, 0), (-1, 0), .rotate90),
        PointsMap((0, 0), (1, 0), (2, 0), (-1, 0), .rotate180),
        PointsMap((0, 0), (1, 0), (2, 0), (-1, 0), .rotate270),
        PointsMap((0, 0), (1, 0), (2, 0), (-1, 0), .flipHorizontal),
        PointsMap((0, 0), (1, 0), (2, 0), (-1, 0), .flipVertical),
        PointsMap((0, 0), (1, 0), (2, 0), (-1, 0), .scale(4).rotated(45).translated(x: 40, y: 50)),

        //           3 --- 2
        //         0 --- 1
        PointsMap((0, 0), (1, 0), (2, 0), (1, 0)), // 0, 1, 2, 3
        PointsMap((0, 0), (1, 0), (2, 0), (1, 0), .rotate45),
        PointsMap((0, 0), (1, 0), (2, 0), (1, 0), .rotate90),
        PointsMap((0, 0), (1, 0), (2, 0), (1, 0), .rotate180),
        PointsMap((0, 0), (1, 0), (2, 0), (1, 0), .rotate270),
        PointsMap((0, 0), (1, 0), (2, 0), (1, 0), .flipHorizontal),
        PointsMap((0, 0), (1, 0), (2, 0), (1, 0), .flipVertical),
        PointsMap((0, 0), (1, 0), (2, 0), (1, 0), .scale(4).rotated(45).translated(x: 40, y: 50)),

    ])
    func line(_ points: PointsMap) {
        let tr = FreeDistortTransform(p0: points.p0,
                                        p1: points.p1,
                                        p2: points.p2,
                                        p3: points.p3)

        for uv in UVGrid.uvs {
            let transformed = tr.transform(uv)

            #expect(
                tr.inverse(transformed).isEqual(to: .init(x: 0.5, y: 0.5), tolerance: tolerance)
            )
        }
    }

    @Test("Point", arguments: [
        //         3 -- 2
        //         0 -- 1
        PointsMap((0, 0), (0, 0), (0, 0), (0, 0)), // 0, 1, 2, 3
        PointsMap((0, 0), (0, 0), (0, 0), (0, 0), .rotate45),
        PointsMap((0, 0), (0, 0), (0, 0), (0, 0), .translate(x: 4, y: 6)),
        PointsMap((0, 0), (0, 0), (0, 0), (0, 0), .scale(4).rotated(45).translated(x: 40, y: 50)),

    ])
    func point(_ points: PointsMap) {
        let tr = FreeDistortTransform(p0: points.p0,
                                        p1: points.p1,
                                        p2: points.p2,
                                        p3: points.p3)

        for uv in UVGrid.uvs {
            let transformed = tr.transform(uv)

            #expect(
                tr.inverse(transformed).isEqual(to: .init(x: 0.5, y: 0.5), tolerance: tolerance)
            )
        }
    }
}
