//
//  Created by Vitali Kurlovich on 7.01.26.
//

import MathKit
import SwiftUI

struct TransformEditorGrid: View {
    @Binding var editorModel: TransformEditorModel

    @Binding var configuration: TransformEditorConfiguration

    var body: some View {
        Canvas { context, _ in
            let resolver = ControlPointsResolver(contentGeometry: editorModel.contentGeometry,
                                                 targetGeometry: editorModel.gridGeometry)

            let grid = EditorGrid(resolver.position(p0: editorModel.p0),
                                  resolver.position(p1: editorModel.p1),
                                  resolver.position(p2: editorModel.p2),
                                  resolver.position(p3: editorModel.p3))

            if configuration.showOrigin {
                context.stroke(grid.origin, with: .foreground)
            }

            if configuration.showGrid {
                context.stroke(grid.mediumGrid, with: .foreground,
                               style: .init(lineWidth: 0.5, dash: [7, 2]))

                context.stroke(grid.smallGrid,
                               with: .foreground,
                               style: .init(lineWidth: 0.25, dash: [3, 6]))
            }
            if configuration.showOutline {
                context.stroke(grid.outline,
                               with: .foreground,
                               style: .init(lineWidth: 0.75, dash: [4, 2]))
            }
        }
    }
}
