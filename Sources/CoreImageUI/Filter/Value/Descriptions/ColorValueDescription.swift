//
//  ColorValueDescription.swift
//  swift-image
//
//  Created by Vitali Kurlovich on 27.03.2026.
//

import CoreImage

struct ColorValueDescription: ValueDescription {
    typealias Value = CIColor

    let attribute: FilterAttribute

    init(attribute: FilterAttribute) {
        assert(attribute.type == .color || attribute.type == .opaqueColor)
        assert(attribute.className == "CIColor")
        self.attribute = attribute
    }

    var isOpaque: Bool {
        type == .opaqueColor
    }
}
