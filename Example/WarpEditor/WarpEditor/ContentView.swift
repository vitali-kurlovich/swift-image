//
//  Created by Vitali Kurlovich on 24.12.25.
//

import SwiftUI

struct ContentView: View {
    @State var animationEditorModel: TransformEditorModel = .init(contentType: .animation)
    @State var imageEditorModel: TransformEditorModel = .init(contentType: .image)

    @State var selection: TransformEditorModel.ContentType = .animation

    @State var configuration: TransformEditorConfiguration = .init()

    var body: some View {
        TabView(selection: $selection) {
            Tab("Amimation", systemImage: "heart.rectangle.fill", value: .animation) {
                TransformEditorView(editorModel: $animationEditorModel, configuration: $configuration)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
            }
            Tab("Photo", systemImage: "photo", value: .image) {
                TransformEditorView(editorModel: $imageEditorModel, configuration: $configuration)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
            }

            Tab("Core Image", systemImage: "camera.filters", value: .coreImage) {
                //  TransformEditorView(editorModel: $imageEditorModel, configuration: $configuration)
                //      .frame(maxWidth: .infinity, maxHeight: .infinity)
                //      .padding()
            }

            // camera.filters
        }
        .toolbar(
            selection == .animation ? $animationEditorModel : $imageEditorModel,
            $configuration
        )
    }
}

#Preview {
    ContentView()
}
