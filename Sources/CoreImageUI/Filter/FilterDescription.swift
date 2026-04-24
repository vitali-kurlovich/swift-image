//
//  FilterDescription.swift
//  swift-image
//
//  Created by Vitali Kurlovich on 26.03.2026.
//

import CoreImage

import CoreImage.CIFilterBuiltins
import Playgrounds

struct FilterDescription: Hashable {
    let filter: CIFilter

    #if os(macOS)
        var isEnabled: Bool {
            get { filter.isEnabled }
            set { filter.isEnabled = newValue }
        }

        var className: String {
            filter.className
        }

    #endif

    var name: String {
        filter.name
    }
}

extension FilterDescription {
    var inputAttributes: [FilterAttribute] {
        filter.inputKeys.compactMap {
            FilterAttribute(filter: filter, key: $0)
        }
    }

    var outputAttributes: [FilterAttribute] {
        filter.outputKeys.compactMap {
            FilterAttribute(filter: filter, key: $0)
        }
    }
}

extension FilterDescription {
    var attributes: [String: Any] {
        filter.attributes
    }
}

extension FilterDescription {
    var displayName: String {
        attributes[kCIAttributeFilterDisplayName] as? String ?? ""
    }

    var localizedName: String {
        CIFilter.localizedName(forFilterName: name) ?? ""
    }

    var localizedDescription: String {
        CIFilter.localizedDescription(forFilterName: name) ?? ""
    }

    var localizedReferenceDocumentation: URL? {
        CIFilter.localizedReferenceDocumentation(forFilterName: name)
    }

    var categories: FilterCategories {
        let categories = attributes[kCIAttributeFilterCategories] as? [String] ?? []

        return FilterCategories(categories)
    }
}

extension FilterDescription: CustomStringConvertible {
    var description: String {
        filter.description
    }
}

extension FilterDescription: CustomDebugStringConvertible {
    var debugDescription: String {
        filter.debugDescription
    }
}

#Playground {
    let filter = CIFilter.circularWrap()
    // kCIAttributeFilterCategories
    let desc = FilterDescription(filter: filter)
    desc.inputAttributes

//    filter.name
//    filter.debugDescription
//    filter.attributes
    // CIFilter.localizedDescription(forFilterName: filter.name)
}

/*

 /** Name of the filter */
 public let kCIAttributeFilterName: String

 /** Name of the filter intended for UI display (eg. localized) */
 public let kCIAttributeFilterDisplayName: String

 /** Description of the filter intended for UI display (eg. localized) */
 @available(macOS 10.5, *)
 public let kCIAttributeDescription: String

 */
