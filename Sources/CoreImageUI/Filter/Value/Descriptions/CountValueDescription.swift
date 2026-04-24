//
//  CountValueDescription.swift
//  swift-image
//
//  Created by Vitali Kurlovich on 27.03.2026.
//

import CoreImage

struct CountValueDescription: ValueDescription {
    typealias Value = UInt

    let attribute: FilterAttribute

    init(attribute: FilterAttribute) {
        assert(attribute.type == .count)
        assert(attribute.className == "NSNumber")
        self.attribute = attribute
    }
}
