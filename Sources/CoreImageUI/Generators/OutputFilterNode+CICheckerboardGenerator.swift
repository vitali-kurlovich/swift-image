//
//  Created by Vitali Kurlovich on 25.03.26.
//

import CoreImage
import CoreImage.CIFilterBuiltins

extension OutputFilterNode where Filter: CICheckerboardGenerator {
    /// The center of the effect as x and y pixel coordinates.
    var center: CGPoint {
        get {
            outputFilter.center
        }

        set {
            outputFilter.center = newValue
        }
    }

    /// A color to use for the first set of squares.
    var color0: CIColor {
        get {
            outputFilter.color0
        }
        set {
            outputFilter.color0 = newValue
        }
    }

    /// A color to use for the second set of squares.
    var color1: CIColor {
        get {
            outputFilter.color1
        }
        set {
            outputFilter.color1 = newValue
        }
    }

    /// The width of the squares in the pattern.
    var width: Float {
        get {
            outputFilter.width
        }
        set {
            outputFilter.width = newValue
        }
    }

    /// The sharpness of the edges in pattern. The smaller the value, the more blurry the pattern. Values range from 0.0 to 1.0.
    var sharpness: Float {
        get {
            outputFilter.sharpness
        }
        set {
            outputFilter.sharpness = newValue
        }
    }
}
