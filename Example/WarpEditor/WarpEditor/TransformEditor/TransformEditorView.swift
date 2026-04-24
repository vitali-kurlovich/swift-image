//
//  Created by Vitali Kurlovich on 31.12.25.
//

import SwiftUI
import WarpSwiftUI

struct TransformEditorView: View {
    @Binding var editorModel: TransformEditorModel
    @Binding var configuration: TransformEditorConfiguration

    @GestureState private var magnifyBy: CGFloat = 1

    @State private var scale: CGFloat = 1

    var body: some View {
        ZStack {
            if containsContent {
                EditedContent(editorModel: $editorModel, scale: $scale)
                    .onGeometryChange(for: ContentGeometry.self) { proxy in
                        .init(proxy)
                    } action: { geometry in
                        editorModel.contentGeometry = geometry
                    }
                    .geometryGroup()
                    .freeDistort(
                        p0: editorModel.p0,
                        p1: editorModel.p1,
                        p2: editorModel.p2,
                        p3: editorModel.p3,
                        isEnabled: configuration.isEditing
                    )
            }
        }
        .editorToolOverlay(editorModel: $editorModel, configuration: $configuration)
        .gesture(magnification)
    }

    var magnification: some Gesture {
        MagnifyGesture()
            .updating($magnifyBy) { value, gestureState, _ in
                gestureState = value.magnification
                scale = value.magnification
            }.onEnded { _ in }
    }
}

private extension TransformEditorView {
    var containsContent: Bool {
        switch editorModel.contentType {
        case .animation:
            return true
        case .image, .coreImage:
            return editorModel.image != nil
        }
    }
}

private extension TransformEditorView {
    struct EditedContent: View {
        @Binding var editorModel: TransformEditorModel
        @Binding var scale: CGFloat

        var body: some View {
            switch editorModel.contentType {
            case .animation:
                AnimatedPlaceholder(scale: $scale)
            case .image, .coreImage:
                editorModel.image
           
            }
        }
    }
}

#Preview {
    @Previewable @State var editorModel: TransformEditorModel = .init(contentType: .animation)
    @Previewable @State var configuration: TransformEditorConfiguration = .init()
    TransformEditorView(editorModel: $editorModel, configuration: $configuration)
}
