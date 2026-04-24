//
//  Created by Vitali Kurlovich on 12.01.26.
//

import SwiftUI

extension View {
    func editorToolOverlay(editorModel: Binding<TransformEditorModel>,
                           configuration: Binding<TransformEditorConfiguration>) -> some View
    {
        modifier(EditorToolOverlayModifier(editorModel: editorModel, configuration: configuration))
    }
}

struct EditorToolOverlayModifier: ViewModifier {
    @Binding var editorModel: TransformEditorModel
    @Binding var configuration: TransformEditorConfiguration

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay {
                if containsContent {
                    TransformEditorGrid(editorModel: $editorModel,
                                        configuration: $configuration)
                        .onGeometryChange(for: ContentGeometry.self) { proxy in
                            .init(proxy)
                        } action: { geometry in
                            editorModel.gridGeometry = geometry
                        }
                }
            }
            .overlay {
                if containsContent, configuration.showControlPoints {
                    TransformToolHandles(editorModel: self.$editorModel)
                        .onGeometryChange(for: ContentGeometry.self) { proxy in
                            .init(proxy)
                        } action: { geometry in
                            editorModel.controlsGeometry = geometry
                        }
                }
            }.overlay {
                if editorModel.contentType == .image {
                    ImageDropContainer(imageCoordinator: editorModel.imageCoordinator)
                }
            }
    }

    private var containsContent: Bool {
        switch editorModel.contentType {
        case .animation:
            return true
        case .image:
            return editorModel.image != nil
        case .coreImage:
            return false
        }
    }
}
