//
//  Created by Vitali Kurlovich on 26.02.26.
//

import SwiftUI
import VisualEffects
import WarpMetal

public extension View {
    func freeDistort(p0: CGVector, p1: CGVector, p2: CGVector, p3: CGVector, isEnabled: Bool = true) -> some View {
        modifier(FreeDistortModifier(p0: p0, p1: p1, p2: p2, p3: p3, isEnabled: isEnabled))
    }
}

struct FreeDistortModifier: ViewModifier {
    let p0: CGVector
    let p1: CGVector
    let p2: CGVector
    let p3: CGVector
    let isEnabled: Bool

    func body(content: Content) -> some View {
        content.shaderEffect(
            FreeDistortShader(p0: p0, p1: p1, p2: p2, p3: p3),
            isEnabled: isEnabled
        )
    }
}

#Preview {
    ZStack {
        UVGrid().frame(width: 400, height: 400)
            .geometryGroup()
            .freeDistort(
                p0: .init(dx: -30, dy: 50),
                p1: .init(dx: 30, dy: -60),
                p2: .init(dx: 10, dy: 100),
                p3: .init(dx: 40, dy: -50)
            )
    }.frame(width: 400, height: 400)
        .padding(88)
}
