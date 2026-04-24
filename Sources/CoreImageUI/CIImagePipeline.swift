//
//  CIImagePipeline.swift
//  swift-image
//
//  Created by Vitali Kurlovich on 24.03.26.
//

import CoreImage

public final class CIImagePipeline: CIOutputImage {
    public var outputImage: CIImage? {
        if needsInvalidate {
            invalidate()
        }
        return filters.last?.outputImage
    }

    var filters: [CIFilterNode] = []

    var needsInvalidate = true

    func invalidate() {}

    func setNeedsUpdate() {
        needsInvalidate = true
    }
}

extension CIImagePipeline {
    func append(_ node: CIFilterNode) {
        assert(!containts(node))

        let last = filters.last

        if let input = node as? CIInputImage {
            input.inputImage = last?.outputImage
        }

        filters.append(node)
    }

    func remove(_ node: CIFilterNode) {
        assert(containts(node))

        if let index = filters.firstIndex(where: { $0 === node }) {
            filters.remove(at: index)
        }
    }
}

extension CIImagePipeline {
    func containts(_ node: CIFilterNode) -> Bool {
        filters.contains { $0 === node }
    }
}
