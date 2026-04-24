//
//  PositionValueDescription.swift
//  swift-image
//
//  Created by Vitali Kurlovich on 27.03.2026.
//

import CoreImage

struct PositionValueDescription: ValueDescription {
    typealias Value = CGPoint

    let attribute: FilterAttribute

    init(attribute: FilterAttribute) {
        assert(attribute.type == .position)
        assert(attribute.className == "CIVector")
        self.attribute = attribute
    }
}

//
