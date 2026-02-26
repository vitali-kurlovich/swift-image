//
//  Created by Vitali Kurlovich on 9.01.26.
//

import SwiftUI

nonisolated struct ContentGeometry: Equatable {
    let local: CGRect
    let global: CGRect
}

extension ContentGeometry {
    init() {
        self.init(local: .zero, global: .zero)
    }

    init(_ proxy: GeometryProxy) {
        self.init(local: proxy.frame(in: .local), global: proxy.frame(in: .global))
    }

    var coordinateSpace: CoordinateSpace {
        CoordinateSpace(local: local, global: global)
    }
}
