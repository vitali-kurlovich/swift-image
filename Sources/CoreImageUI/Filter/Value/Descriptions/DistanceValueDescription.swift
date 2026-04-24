//
//  DistanceValueDescription.swift
//  swift-image
//
//  Created by Vitali Kurlovich on 27.03.2026.
//

import CoreImage

struct DistanceValueDescription: ValueDescription {
    typealias Value = Float

    let attribute: FilterAttribute

    init(attribute: FilterAttribute) {
        assert(attribute.type == .distance)
        assert(attribute.className == "NSNumber")
        self.attribute = attribute
    }
}
