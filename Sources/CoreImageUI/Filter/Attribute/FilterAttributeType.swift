//
//  FilterAttributeType.swift
//  swift-image
//
//  Created by Vitali Kurlovich on 26.03.2026.
//

import CoreImage

enum FilterAttributeType: UInt8 {
    case uncknown = 0

    /// A parametric phase for transitions, specified as a floating-point value in the range of 0.0 to 1.0.
    case phase
    /// A scalar value.
    case scalar
    /// A distance.
    case distance
    /// An angle.
    case angle
    /// A Boolean value.
    case boolean
    /// An integer value.
    case integer
    /// A positive integer value.
    case count
    /// A two-dimensional location in the working coordinate space. (A 2-element vector type.)
    case position
    /// An offset. (A 2-element vector type.)
    case offset
    /// A three-dimensional location in the working coordinate space. (A 3-element vector type.)
    case position3D
    /// A Core Image vector that specifies the x and y values of the rectangle origin, and the width (w) and height (h) of the rectangle. The vector takes the form [x, y, w, h]. (A 4-element vector type.)
    case rectangle
    /// A Core Image color (``CIColor`` object) that specifies red, green, and blue component values. Use this key for colors with no alpha component. If the key is not present, Core Image assumes color with alpha.
    case opaqueColor
    /// A Core Image color (``CIColor`` object) that specifies red, green, and blue component values.
    case color
    /// An n-by-1 gradient image used to describe a color ramp.
    case gradient
    /// A ``CIImage`` object.
    case image

    /// The transform type of an attribute.
    ///
    /// An ``CGAffineTransform`` is associated with attribute.
    case transform
}

extension FilterAttributeType {
    init(_ key: String) {
        let mapTypes = Self.mapTypes
        guard let type = mapTypes[key] else {
            assertionFailure("Uncknown type: \(key)")
            self = .uncknown
            return
        }
        self = type
    }
}

extension FilterAttributeType {
    var string: String {
        let map = Self.mapTypes
        for (key, value) in map {
            if value == self {
                return key
            }
        }
        return ""
    }
}

extension FilterAttributeType: CustomStringConvertible {
    var description: String {
        string
    }
}

extension FilterAttributeType {
    private static var mapTypes: [String: Self] {
        [
            kCIAttributeTypeTime: .phase,
            kCIAttributeTypeScalar: .scalar,
            kCIAttributeTypeDistance: .distance,
            kCIAttributeTypeAngle: .angle,
            kCIAttributeTypeBoolean: .boolean,
            kCIAttributeTypeInteger: .integer,
            kCIAttributeTypeCount: .count,
            kCIAttributeTypePosition: .position,
            kCIAttributeTypeOffset: .offset,
            kCIAttributeTypePosition3: .position3D,
            kCIAttributeTypeRectangle: .rectangle,
            kCIAttributeTypeOpaqueColor: .opaqueColor,
            kCIAttributeTypeColor: .color,
            kCIAttributeTypeGradient: .gradient,
            kCIAttributeTypeImage: .image,
            kCIAttributeTypeTransform: .transform,
        ]
    }
}
