//
//  Created by Vitali Kurlovich on 26.03.2026.
//

import CoreImage

struct AngleValueDescription: ValueDescription {
    typealias Value = Float

    let attribute: FilterAttribute

    init(attribute: FilterAttribute) {
        assert(attribute.type == .angle)
        assert(attribute.className == "NSNumber")
        self.attribute = attribute
    }
}
