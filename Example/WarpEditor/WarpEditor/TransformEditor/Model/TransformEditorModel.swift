//
//  Created by Vitali Kurlovich on 8.01.26.
//

import Observation
import SwiftUI

@Observable
final class TransformEditorModel {
    enum ContentType: CaseIterable {
        case animation
        case image
    }

    let contentType: ContentType

    init(contentType: ContentType) {
        self.contentType = contentType
    }

    var p0: CGVector = .zero
    var p1: CGVector = .zero
    var p2: CGVector = .zero
    var p3: CGVector = .zero

    var image: Image?

    var contentGeometry = ContentGeometry()
    var controlsGeometry = ContentGeometry()
    var gridGeometry = ContentGeometry()

    func reset() {
        p0 = .zero
        p1 = .zero
        p2 = .zero
        p3 = .zero
    }
}
