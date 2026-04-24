//
//  Created by Vitali Kurlovich on 26.03.2026.
//

import CoreImage

struct FilterCategories: OptionSet, Hashable {
    var rawValue: UInt64
}

extension FilterCategories {
    init(_ name: String) {
        let categoryMap = Self.categoryMap

        guard let findCategory = categoryMap[name] else {
            assertionFailure("Uncknown category: \(name)")
            self = .init(rawValue: 0)
            return
        }
        self = findCategory
    }

    init<S>(_ sequence: S) where S: Sequence, S.Element == String {
        var category = FilterCategories(rawValue: 0)

        let categoryMap = Self.categoryMap

        for categoryName in sequence {
            guard let newCategory = categoryMap[categoryName] else {
                assertionFailure("Uncknown category: \(categoryName)")
                continue
            }

            category.insert(newCategory)
        }

        self = category
    }
}

extension FilterCategories {
    var keys: [String] {
        let categoryMap = Self.categoryMap

        var names: [String] = []

        for (key, value) in categoryMap {
            if contains(value) {
                names.append(key)
            }
        }

        return names
    }
}

extension FilterCategories {
    /// A filter that reshapes an image by altering its geometry to create a 3D effect. Using distortion filters, you can displace portions of an image, apply lens effects, make a bulge in an image, and perform other operation to achieve an artistic effect.
    static var distortionEffect: Self { .init(rawValue: 1 << 0) }
    static var geometryAdjustment: Self { .init(rawValue: 1 << 1) }
    static var compositeOperation: Self { .init(rawValue: 1 << 2) }
    static var halftoneEffect: Self { .init(rawValue: 1 << 3) }
    static var colorAdjustment: Self { .init(rawValue: 1 << 4) }
    static var colorEffect: Self { .init(rawValue: 1 << 5) }
    static var transition: Self { .init(rawValue: 1 << 6) }
    static var tileEffect: Self { .init(rawValue: 1 << 7) }
    static var generator: Self { .init(rawValue: 1 << 8) }
    static var reduction: Self { .init(rawValue: 1 << 9) }
    static var gradient: Self { .init(rawValue: 1 << 10) }
    static var stylize: Self { .init(rawValue: 1 << 11) }
    static var sharpen: Self { .init(rawValue: 1 << 12) }
    static var blur: Self { .init(rawValue: 1 << 13) }
    static var video: Self { .init(rawValue: 1 << 14) }
    static var stillImage: Self { .init(rawValue: 1 << 15) }
    static var interlaced: Self { .init(rawValue: 1 << 16) }
    static var nonSquarePixels: Self { .init(rawValue: 1 << 17) }
    static var highDynamicRange: Self { .init(rawValue: 1 << 18) }
    static var builtIn: Self { .init(rawValue: 1 << 19) }
    static var filterGenerator: Self { .init(rawValue: 1 << 19) }
}

extension FilterCategories {
    private static var categoryMap: [String: FilterCategories] {
        [
            kCICategoryDistortionEffect: .distortionEffect,
            kCICategoryGeometryAdjustment: .geometryAdjustment,
            kCICategoryCompositeOperation: .compositeOperation,
            kCICategoryHalftoneEffect: .halftoneEffect,
            kCICategoryColorAdjustment: .colorAdjustment,
            kCICategoryColorEffect: colorEffect,
            kCICategoryTransition: .transition,
            kCICategoryTileEffect: .tileEffect,
            kCICategoryGenerator: .generator,
            kCICategoryReduction: .reduction,
            kCICategoryGradient: .gradient,
            kCICategoryStylize: .stylize,
            kCICategorySharpen: .sharpen,
            kCICategoryBlur: .blur,
            kCICategoryVideo: .video,
            kCICategoryStillImage: .stillImage,
            kCICategoryInterlaced: .interlaced,
            kCICategoryNonSquarePixels: .nonSquarePixels,
            kCICategoryHighDynamicRange: .highDynamicRange,
            kCICategoryBuiltIn: .builtIn,
            kCICategoryFilterGenerator: .filterGenerator,
        ]
    }
}
