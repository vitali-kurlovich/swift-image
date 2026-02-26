//
//  Created by Vitali Kurlovich on 26.02.26.
//

#if canImport(UIKit)
    import UIKit

    typealias CoreAffineTransform = CGAffineTransform

    extension CGAffineTransform {
        var m11: CGFloat { a }
        var m12: CGFloat { b }
        var m21: CGFloat { c }
        var m22: CGFloat { d }
        var tX: CGFloat { tx }
        var tY: CGFloat { ty }
    }

    extension CGAffineTransform {
        func transform(_ p: CGPoint) -> CGPoint {
            p.applying(self)
        }
    }

    extension CGAffineTransform {
        init(m11: CGFloat, m12: CGFloat, m21: CGFloat, m22: CGFloat, tX: CGFloat, tY: CGFloat) {
            self.init(m11, m12, m21, m22, tX, tY)
        }

        init(translationByX x: CGFloat, byY y: CGFloat) {
            self.init(translationX: x, y: y)
        }

        init(scale: CGFloat) {
            self.init(scaleX: scale, y: scale)
        }

        init(scaleByX x: CGFloat, byY y: CGFloat) {
            self.init(scaleX: x, y: y)
        }

        init(rotationByRadians angle: CGFloat) {
            self.init(rotationAngle: angle)
        }

        init(rotationByDegrees angle: CGFloat) {
            self.init(rotationAngle: angle * (.pi / 180))
        }
    }

    extension CGAffineTransform {
        mutating func scale(_ scaler: CGFloat) {
            self = scaledBy(x: scaler, y: scaler)
        }

        mutating func scale(x: CGFloat, y: CGFloat) {
            self = scaledBy(x: x, y: y)
        }

        mutating func translate(x: CGFloat, y: CGFloat) {
            self = translatedBy(x: x, y: y)
        }

        mutating func rotate(byRadians angle: CGFloat) {
            self = rotated(by: angle)
        }

        mutating func rotate(byDegrees angle: CGFloat) {
            rotate(byRadians: angle * (.pi / 180))
        }

        mutating func invert() {
            self = inverted()
        }

        mutating func append(_ other: Self) {
            self = concatenating(other)
        }

        mutating func prepend(_ other: Self) {
            self = other.concatenating(self)
        }
    }

#else
    import Foundation

    typealias CoreAffineTransform = AffineTransform
#endif
