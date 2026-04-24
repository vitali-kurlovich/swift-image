//
//  TransformValueDescription.swift
//  swift-image
//
//  Created by Vitali Kurlovich on 27.03.2026.
//

import CoreImage

struct TransformValueDescription: ValueDescription {
    #if os(macOS)
        typealias Value = NSAffineTransform
    #endif

    #if os(iOS)
        typealias Value = CGAffineTransform
    #endif

    let attribute: FilterAttribute

    init(attribute: FilterAttribute) {
        assert(attribute.type == .transform)
        #if os(macOS)
            assert(attribute.className == "NSAffineTransform")
        #endif

        #if os(iOS)
            assert(attribute.className == "NSValue" || attribute.className == "CIVector")
        #endif

        self.attribute = attribute
    }
}
