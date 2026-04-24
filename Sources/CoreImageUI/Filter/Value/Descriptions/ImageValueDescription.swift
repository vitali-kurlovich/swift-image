//
//  ImageValueDescription.swift
//  swift-image
//
//  Created by Vitali Kurlovich on 27.03.2026.
//

import CoreImage

struct ImageValueDescription: ValueDescription {
    typealias Value = CIImage

    let attribute: FilterAttribute

    init(attribute: FilterAttribute) {
        assert(attribute.type == .image)
        assert(attribute.className == "CIImage")
        self.attribute = attribute
    }
}
