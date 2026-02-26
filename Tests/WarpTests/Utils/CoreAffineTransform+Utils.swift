//
//  Created by Vitali Kurlovich on 26.02.26.
//

import Foundation

extension CoreAffineTransform {
    static var rotate45: Self {
        .rotate(45)
    }

    static var rotate90: Self {
        .rotate(90)
    }

    static var rotate180: Self {
        .rotate(180)
    }

    static var rotate270: Self {
        .rotate(270)
    }

    static var flipHorizontal: Self {
        .scale(x: 1, y: -1)
    }

    static var flipVertical: Self {
        .scale(x: -1, y: 1)
    }
}

extension CoreAffineTransform {
    static func translate(x: CGFloat, y: CGFloat) -> Self {
        .init(translationByX: x, byY: y)
    }

    static func scale(_ scalar: CGFloat) -> Self {
        .init(scale: scalar)
    }

    static func scale(x: CGFloat, y: CGFloat) -> Self {
        .init(translationByX: x, byY: y)
    }

    static func rotate(_ angle: CGFloat) -> Self {
        .init(rotationByDegrees: angle)
    }
}

extension CoreAffineTransform {
    func translated(x: CGFloat, y: CGFloat) -> Self {
        var tr = self
        tr.prepend(.translate(x: x, y: y))
        return self
    }

    func scaled(_ scalar: CGFloat) -> Self {
        var tr = self
        tr.prepend(.scale(scalar))
        return self
    }

    func scaled(x: CGFloat, y: CGFloat) -> Self {
        var tr = self
        tr.prepend(.scale(x: x, y: y))
        return self
    }

    func rotated(_ angle: CGFloat) -> Self {
        var tr = self
        tr.prepend(.rotate(angle))
        return self
    }
}
