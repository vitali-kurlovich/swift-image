//
//  Created by Vitali Kurlovich on 27.03.2026.
//

import CoreImage

struct IntValueDescription: ValueDescription {
    typealias Value = Int

    let attribute: FilterAttribute

    init(attribute: FilterAttribute) {
        assert(attribute.type == .integer)
        assert(attribute.className == "NSNumber")
        self.attribute = attribute
    }
}
