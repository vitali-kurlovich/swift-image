//
//  FilterAttributes.swift
//  swift-image
//
//  Created by Vitali Kurlovich on 26.03.2026.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import Playgrounds
import SwiftUI

struct FilterAttributes: View {
    let filter: CIFilter

    @State private var expandedInput: Bool = true
    @State private var expandedOutput: Bool = true

    var body: some View {
        Table(of: FilterAttribute.self) {
            TableColumn("Name") { attr in
                Text(attr.displayName)
            }

            TableColumn("Description") { attr in
                Text(attr.localizedDescription)
            }

            TableColumn("Type") { attr in
                Text(attr.type.description)
            }
        } rows: {
            //  DisclosureTableRow(<#T##Value#>, isExpanded: <#T##Binding<Bool>?#>, content: <#T##() -> Content#>)

            ForEach(filter.inputAttributes) { value in
                TableRow(value)
            }
        }
    }
}

#Playground {
    let filter = CIFilter.falseColor()

    filter.name
    CIFilter.localizedDescription(forFilterName: filter.name)

    filter.inputAttributes

    filter.attributes["inputColor0"]

    // kCIAttributeTypeImage
}

#Preview {
    let filter = CIFilter.falseColor()

    FilterAttributes(filter: filter)
}
