//
//  Created by Vitali Kurlovich on 8.01.26.
//

import SwiftUI

extension View {
    func toolbar(_ editorModel: Binding<TransformEditorModel>,
                 _ configuration: Binding<TransformEditorConfiguration>) -> some View
    {
        return toolbar {
            ToolbarItemGroup(placement: gridConfigurationToolbarPlacement) {
                Group {
                    Toggle(isOn: configuration.showControlPoints) {
                        Image(systemName: "skew")
                    }

                    Toggle(isOn: configuration.showOutline) {
                        Image(systemName: "rectangle.dashed")
                    }

                    Toggle(isOn: configuration.showOrigin) {
                        Image(systemName: "dot.squareshape.split.2x2")
                    }

                    Toggle(isOn: configuration.showGrid) {
                        Image(systemName: "squareshape.split.3x3")
                    }
                }.toggleStyle(.button)
            }

            ToolbarItem(placement: .cancellationAction) {
                Button("Reset", systemImage: "square.dashed") {
                    editorModel.wrappedValue.reset()
                }
            }

            ToolbarItem(placement: .confirmationAction) {
                Toggle(isOn: configuration.isEditing) {
                    Label("Show Original", systemImage: "perspective")
                }.toggleStyle(.button)
            }
        }
    }

    private var gridConfigurationToolbarPlacement: ToolbarItemPlacement {
        #if os(iOS)
            return .bottomBar
        #else
            return .status
        #endif
    }
}
