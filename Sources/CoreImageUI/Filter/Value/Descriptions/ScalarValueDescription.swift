//
//  ScalarValueDescription.swift
//  swift-image
//
//  Created by Vitali Kurlovich on 27.03.2026.
//

import CoreImage

struct ScalarValueDescription: ValueDescription {
    typealias Value = Float

    let attribute: FilterAttribute

    init(attribute: FilterAttribute) {
        assert(attribute.type == .scalar)
        assert(attribute.className == "NSNumber")
        self.attribute = attribute
    }
}
