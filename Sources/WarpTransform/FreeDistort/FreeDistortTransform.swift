//
//  Created by Vitali Kurlovich on 26.02.26.
//

import MathKit
import MathTransform

public nonisolated struct FreeDistortTransform<Float: FloatingPoint & Sendable>: Hashable, Sendable {
    public var p0: MKPoint<Float>
    public var p1: MKPoint<Float>
    public var p2: MKPoint<Float>
    public var p3: MKPoint<Float>

    // p0 -- p1
    // |      |
    // |      |
    // p3 -- p2
    @inlinable public init(p0: MKPoint<Float>, p1: MKPoint<Float>, p2: MKPoint<Float>, p3: MKPoint<Float>) {
        self.p0 = p0
        self.p1 = p1
        self.p2 = p2
        self.p3 = p3
    }
}

extension FreeDistortTransform {
    private var epsilon: Float {
        (Float.zero + 1) / 1_000_000
    }
}

public extension FreeDistortTransform {
    var isAffine: Bool {
        isUParallel && isVParallel
    }

    var isUParallel: Bool {
        let x0 = p0.x, y0 = p0.y
        let x1 = p1.x, y1 = p1.y
        let x2 = p2.x, y2 = p2.y
        let x3 = p3.x, y3 = p3.y

        let dx01 = x0 - x1, dy01 = y0 - y1
        let dx23 = x2 - x3, dy23 = y2 - y3

        //   dx01 dy23 - dx23 dy01
        //  (x2 (y0 - y1) + x3 (-y0 + y1) - (x0 - x1) (y2 - y3)) -> DU
        // dx23 dy01 - dx01 dy23 -> DU
        let DU = (dy01 * dx23).addingProduct(-dx01, dy23)

        return abs(DU) <= epsilon
    }

    var isVParallel: Bool {
        let x0 = p0.x, y0 = p0.y
        let x1 = p1.x, y1 = p1.y
        let x2 = p2.x, y2 = p2.y
        let x3 = p3.x, y3 = p3.y

        let dx03 = x0 - x3, dy03 = y0 - y3
        let dx12 = x1 - x2, dy12 = y1 - y2

        // ((x0 - x3) (y1 - y2) + x2 (y0 - y3) + x1 (-y0 + y3)) -> DV
        //  dx03 dy12 - dx12 dy03 -> DV
        let DV = (dx03 * dy12).addingProduct(-dy03, dx12)

        return abs(DV) <= epsilon
    }
}

extension FreeDistortTransform: Transform, InverseTransform {
    @inlinable public func transform(_ source: MKPoint<Float>) -> MKPoint<Float> {
        lerp(lerp(p0, p1, t: source.x), lerp(p3, p2, t: source.x), t: source.y)
    }

    public func inverse(_ source: MKPoint<Float>) -> MKPoint<Float> {
        let px = source.x, py = source.y

        let x0 = p0.x, y0 = p0.y
        let x1 = p1.x, y1 = p1.y
        let x2 = p2.x, y2 = p2.y
        let x3 = p3.x, y3 = p3.y

        let dx01 = x0 - x1, dy01 = y0 - y1
        let dx03 = x0 - x3, dy03 = y0 - y3
        let dx12 = x1 - x2, dy12 = y1 - y2
        let dy13 = y1 - y3
        let dx23 = x2 - x3, dy23 = y2 - y3

        //   dx01 dy23 - dx23 dy01
        //  (x2 (y0 - y1) + x3 (-y0 + y1) - (x0 - x1) (y2 - y3)) -> DU
        // dx23 dy01 - dx01 dy23 -> DU
        let DU = (dy01 * dx23).addingProduct(-dx01, dy23)

        // ((x0 - x3) (y1 - y2) + x2 (y0 - y3) + x1 (-y0 + y3)) -> DV
        //  dx03 dy12 - dx12 dy03 -> DV
        let DV = (dx03 * dy12).addingProduct(-dy03, dx12)

        // p0 -- p1
        // |      |
        // |      |
        // p3 -- p2

        let isP01P32Parallel = abs(DU) <= epsilon
        let isP03P12Parallel = abs(DV) <= epsilon

        let isAffine = isP01P32Parallel && isP03P12Parallel

        if isAffine {
            let divider = dy13 * x0 - dy03 * x1 + dy01 * x3

            if abs(divider) <= epsilon {
                return .init(x: 1 / 2, y: 1 / 2)
            }

            let u = dx03 * py - dy03 * px + x3 * y0 - x0 * y3
            let v = dy01 * px - dx01 * py - x1 * y0 + x0 * y1

            return .init(x: u / divider, y: v / divider)
        }

        let PD = (py * (dx01 + dx23)).addingProduct(-px, dy01 + dy23)

        // py (x0 - x1 + x2 - x3) - x2 y0 + x3 (2 y0 - y1) + x0 (y2 - 2 y3) + x1 y3 + px (-y0 + y1 - y2 + y3) -> PP
        // (dx01 + dx23) py - px (dy01 + dy23) - x2 y0 + x3 (dy01 + y0) + x0 (dy23 - y3) + x1 y3 -> PP
        let PP = PD
            .addingProduct(x0, dy23 - y3)
            .addingProduct(x3, dy01 + y0)
            .addingProduct(x1, y3)
            .addingProduct(-x2, y0)

        // 4 (x2 (y0 - y1) + x3 (-y0 + y1) - (x0 - x1) (y2 - y3)) (py (x0 - x3) + x3 y0 - x0 y3 + px (-y0 + y3)) -> AA
        // 4 (-dx01 dy23 + dy01 x2 - dy01 x3) (-dy03 px + dx03 py + x3 y0 - x0 y3) -> AA
        // 4 (dx01 dy23 + dy01 (-x2 + x3)) (dy03 px - dx03 py - x3 y0 + x0 y3) -> AA
        let AA = 4 * ((dx01 * dy23).addingProduct(-dy01, dx23)) * (
            (dy03 * px)
                .addingProduct(-dx03, py)
                .addingProduct(x0, y3)
                .addingProduct(-x3, y0)
        )

        // Sqrt[AA + PP^2] -> SS
        var SS = AA.addingProduct(PP, PP) // .squareRoot()

        if abs(SS) <= epsilon {
            SS = 0
        } else {
            SS = SS.squareRoot()
        }

        // py (x0 - x1 + x2 - x3) - x2 y0 + x3 (2 y0 - y1) + x0 (y2 - 2 y3) + x1 y3 + px (-y0 + y1 - y2 + y3) -> BB
        // -((dy01 + dy23) px) + (dx01 + dx23) py - x2 y0 + x3 (dy01 + y0) + x0 (dy23 - y3) + x1 y3 -> BB
        let BB = PD
            .addingProduct(x0, dy23 - y3)
            .addingProduct(x1, y3)
            .addingProduct(-x2, y0)
            .addingProduct(x3, dy01 + y0)

        // py (x0 - x1 + x2 - x3) + 2 x1 y0 - x2 y0 + x3 y1 + x0 (-2 y1 + y2) - x1 y3 + px (-y0 + y1 - y2 + y3) -> EE
        // py (dx01 + dx23) - px (dy01 + dy23) + (dx12 + x1) y0 + x3 y1 - x0 (dy12 + y1) - x1 y3 -> EE
        let EE = PD
            .addingProduct(-x0, dy12 + y1)
            .addingProduct(-x1, y3)
            .addingProduct(x3, y1)
            .addingProduct(y0, dx12 + x1)

        //  =======
        let CN = px * (dy01 + dy23) - py * (dx01 + dx23) + x2 * y0
        // py (-x0 + x1 - x2 + x3) + x2 y0 - x3 y1 + x0 (2 y1 - y2) + px (y0 - y1 + y2 - y3) + x1 (-2 y0 + y3) -> CC
        // (dy01 + dy23) px - (dx01 + dx23) py + x2 y0 - x1 (dy03 + y0) - x3 y1 + x0 (dy12 + y1)
        let CC = CN
            .addingProduct(x0, dy12 + y1)
            .addingProduct(-x1, dy03 + y0)
            .addingProduct(-x3, y1)

        // py (-x0 + x1 - x2 + x3) + x2 y0 + x3 (-2 y0 + y1) + px (y0 - y1 + y2 - y3) - x1 y3 + x0 (-y2 + 2 y3) -> NN
        // px (dy01 + dy23) -  py (dx01 + dx23) + x2 y0 - x3 (dy01 + y0) - x0 (dy23 - y3) - x1 y3 -> NN
        let NN = CN
            .addingProduct(-x0, dy23 - y3)
            .addingProduct(-x1, y3)
            .addingProduct(-x3, dy01 + y0)

        // U -> -((BB + SS)/(2 DU))
        let ul: Float

        // U -> (NN + SS)/(2 DU)
        let ur: Float // = (NN + SS) / (2 * DU)

        if isP01P32Parallel {
            let vl = (CC + SS) / (2 * DV)
            let vr = (EE + SS) / (-2 * DV)

            ul = inverseU(by: vl, for: source)
            ur = inverseU(by: vr, for: source)

            let left = MKPoint(x: ul, y: vl)
            let right = MKPoint(x: ur, y: vr)

            return uv(firstUV: left, secondUI: right, for: source)

        } else {
            ul = -((BB + SS) / (2 * DU))
            ur = (NN + SS) / (2 * DU)
        }

        // V -> (CC + SS)/(2 DV)
        let vl: Float

        // V -> -(EE + SS)/(2 DVR)
        let vr: Float

        if isP03P12Parallel {
            vl = inverseV(by: ul, for: source)
            vr = inverseV(by: ur, for: source)

            let left = MKPoint(x: ul, y: vl)
            let right = MKPoint(x: ur, y: vr)

            return uv(firstUV: left, secondUI: right, for: source)

        } else {
            vl = (CC + SS) / (2 * DV)
            vr = (EE + SS) / (-2 * DV)
        }

        let left = MKPoint(x: ul, y: vl)
        let right = MKPoint(x: ur, y: vr)

        return uv(firstUV: left, secondUI: right, for: source)
    }
}

private extension FreeDistortTransform {
    var epsilonRange: ClosedRange<Float> {
        -epsilon ... (1 + epsilon)
    }

    func inNormalRange(_ uv: MKPoint<Float>) -> Bool {
        epsilonRange.contains(uv.x) && epsilonRange.contains(uv.y)
    }

    func uv(firstUV: MKPoint<Float>, secondUI: MKPoint<Float>, for source: MKPoint<Float>) -> MKPoint<Float> {
        if !inNormalRange(firstUV) {
            return secondUI
        }

        let first = source - transform(firstUV)

        if first.magnitudeSquared <= epsilon {
            return firstUV
        }

        return secondUI
    }

    func inverseU(by v: Float, for source: MKPoint<Float>) -> Float {
        let m0 = p0 + (p3 - p0) * v

        let sourceMagnitudeSquared = (source - m0).magnitudeSquared
        if sourceMagnitudeSquared <= epsilon {
            return .zero
        }

        let m1 = p1 + (p2 - p1) * v

        let deltaMagnitudeSquared = (m1 - m0).magnitudeSquared
        if deltaMagnitudeSquared <= epsilon {
            return 1 / 2
        }

        return (sourceMagnitudeSquared / deltaMagnitudeSquared).squareRoot()
    }

    func inverseV(by u: Float, for source: MKPoint<Float>) -> Float {
        let m0 = p0 + (p1 - p0) * u

        let sourceMagnitudeSquared = (source - m0).magnitudeSquared

        if sourceMagnitudeSquared <= epsilon {
            return .zero
        }

        let m1 = p3 + (p2 - p3) * u

        let deltaMagnitudeSquared = (m1 - m0).magnitudeSquared
        if deltaMagnitudeSquared <= epsilon {
            return 1 / 2
        }

        return ((source - m0).magnitudeSquared / deltaMagnitudeSquared).squareRoot()
    }
}
