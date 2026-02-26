//
//  Created by Vitali Kurlovich on 8.01.26.
//

import MathKit
import SwiftUI

nonisolated struct CoordinateSpace: Equatable {
    let _transform: MKAffineTransform<CGFloat>
}

extension CoordinateSpace {
    init() {
        self.init(_transform: .identity)
    }

    init(from: Self, to: Self) {
        var transform = from._transform

        transform.invert()
        transform.prepend(to._transform)

        self.init(_transform: transform)
    }
}

extension CoordinateSpace {
    init(_ proxy: GeometryProxy) {
        self.init(local: proxy.frame(in: .local), global: proxy.frame(in: .global))
    }
}

extension CoordinateSpace {
    init(local: CGRect, global: CGRect) {
        let result: MKAffineTransform<CGFloat>

        let offset = local.origin - global.origin

        if local == global {
            result = .identity
        } else if local.size == global.size {
            result = .init(translationByX: offset.x, byY: offset.y)
        } else {
            let scaleX = local.size.width / global.size.width
            let scaleY = local.size.height / global.size.height

            var transform: MKAffineTransform<CGFloat> = .init(scaleByX: scaleX, byY: scaleY)
            transform.translate(x: offset.x, y: offset.y)

            result = transform
        }

        self.init(_transform: result)
    }

    init(local: CGPoint, global: CGPoint) {
        self.init(local: .init(origin: local, size: .zero), global: .init(origin: global, size: .zero))
    }

    func transform(_ point: CGPoint) -> CGPoint {
        _transform.transform(point)
    }

    func inverseTransform(_ point: CGPoint) -> CGPoint {
        _transform.inverse(point)
    }

    func transform(_ rect: CGRect) -> CGRect {
        _transform.transform(rect)
    }

    func inverseTransform(_ rect: CGRect) -> CGRect {
        guard let tr = _transform.inverted() else {
            assertionFailure("inverted must not be nil")
            return rect
        }

        return tr.transform(rect)
    }
}
