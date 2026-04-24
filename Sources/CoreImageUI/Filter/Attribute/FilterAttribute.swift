//
//  Created by Vitali Kurlovich on 26.03.2026.
//

import CoreImage

import CoreImage.CIFilterBuiltins
import Playgrounds

struct FilterAttribute: Hashable {
    let filter: CIFilter
    let key: String
}

extension FilterAttribute: Identifiable {
    var id: String {
        key
    }
}

extension FilterAttribute {
    subscript(key: String) -> Any? {
        attributes[key]
    }
}

extension FilterAttribute {
    var name: String {
        self[kCIAttributeName] as? String ?? ""
    }

    var displayName: String {
        self[kCIAttributeDisplayName] as? String ?? ""
    }

    var localizedDescription: String {
        self[kCIAttributeDescription] as? String ?? ""
    }
}

extension FilterAttribute {
    var className: String {
        self[kCIAttributeClass] as? String ?? ""
    }
}

extension CIFilter {
    var inputAttributes: [FilterAttribute] {
        inputKeys.compactMap {
            attribute(for: $0)
        }
    }

    var outputAttributes: [FilterAttribute] {
        outputKeys.compactMap {
            attribute(for: $0)
        }
    }
}

extension FilterAttribute {
    var type: FilterAttributeType {
        let key = self[kCIAttributeType] as? String ?? ""
        return FilterAttributeType(key)
    }
}

extension FilterAttribute {
    private var attributes: [String: Any] { filter.attributes[key] as? [String: Any] ?? [:] }
}

private extension CIFilter {
    func attribute(for key: String) -> FilterAttribute {
        assert(attributes.keys.contains(key))
        return FilterAttribute(filter: self, key: key)
    }
}

#Playground {
    let filter = CIFilter.aztecCodeGenerator()

    filter.setDefaults()

    filter.attributes

    filter.attributes["inputColor0"]

    // kCIAttributeFilterCategories
    // let desc = FilterDescription(filter: filter)
}
