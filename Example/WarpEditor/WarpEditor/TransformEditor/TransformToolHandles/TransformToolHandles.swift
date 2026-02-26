//
//  Created by Vitali Kurlovich on 8.01.26.
//

import SwiftUI

struct TransformToolHandles: View {
    @Binding var editorModel: TransformEditorModel

    var body: some View {
        DraggableHandles(p0)
            .position(location0)

        DraggableHandles(p1)
            .position(location1)

        DraggableHandles(p2)
            .position(location2)

        DraggableHandles(p3)
            .position(location3)
    }
}

private extension TransformToolHandles {
    var resolver: ControlPointsResolver {
        ControlPointsResolver(contentGeometry: editorModel.contentGeometry,
                              targetGeometry: editorModel.controlsGeometry)
    }
}

private extension TransformToolHandles {
    var p0: Binding<CGPoint> {
        .init(get: {
            resolver.position(p0: editorModel.p0)
        }, set: { point in
            editorModel.p0 = resolver.offset(p0: point)
        })
    }

    var p1: Binding<CGPoint> {
        .init(get: {
            resolver.position(p1: editorModel.p1)
        }, set: { point in
            editorModel.p1 = resolver.offset(p1: point)
        })
    }

    var p2: Binding<CGPoint> {
        .init(get: {
            resolver.position(p2: editorModel.p2)
        }, set: { point in
            editorModel.p2 = resolver.offset(p2: point)
        })
    }

    var p3: Binding<CGPoint> {
        .init(get: {
            resolver.position(p3: editorModel.p3)
        }, set: { point in
            editorModel.p3 = resolver.offset(p3: point)
        })
    }
}

private extension TransformToolHandles {
    var location0: CGPoint {
        resolver.position(p0: editorModel.p0)
    }

    var location1: CGPoint {
        resolver.position(p1: editorModel.p1)
    }

    var location2: CGPoint {
        resolver.position(p2: editorModel.p2)
    }

    var location3: CGPoint {
        resolver.position(p3: editorModel.p3)
    }
}
