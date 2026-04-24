//
//  BoolValueDescription.swift
//  swift-image
//
//  Created by Vitali Kurlovich on 27.03.2026.
//

import CoreImage

struct BoolValueDescription: ValueDescription {
    typealias Value = Bool

    let attribute: FilterAttribute

    init(attribute: FilterAttribute) {
        assert(attribute.type == .boolean)
        assert(attribute.className == "NSNumber")
        self.attribute = attribute
    }
}
