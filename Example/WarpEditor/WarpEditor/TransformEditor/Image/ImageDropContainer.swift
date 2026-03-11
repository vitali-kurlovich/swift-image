//
//  Created by Vitali Kurlovich on 7.01.26.
//

import SwiftUI
import UniformTypeIdentifiers

struct ImageDropContainer: View {
    let imageCoordinator: ImageCoordinator

    @State private var isDropTargeted: Bool = false

    @State private var animationScale = 1.0
    @State private var animationOpacity = 0.0

    @State private var fileImporterPresented: Bool = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.accentColor.gradient.tertiary.opacity(animationOpacity))
                .overlay {
                    if imageCoordinator.image == nil {
                        ImageDropPlaceholder(isDropTargeted: $isDropTargeted) {
                            fileImporterPresented.toggle()
                        }
                        .scaleEffect(animationScale)
                    }
                }
        }
        .fileImporter(
            isPresented: $fileImporterPresented,
            allowedContentTypes: [.image]
        ) { result in
            switch result {
            case let .success(file):
                imageCoordinator.load(imageURL: file)
            case let .failure(error):
                imageCoordinator.catchError(error: error)
            }
        }
        .dropDestination(
            for: Image.self
        ) { receivedImages, _ in
            imageCoordinator.update(with: receivedImages.first)
        }
        #if os(macOS)
        .dropConfiguration { dropSession in
            isDropTargeted = dropSession.phase == .active

            if dropSession.suggestedOperations.contains(.move) {
                return DropConfiguration(operation: .move)
            }
            return DropConfiguration(operation: .copy)
        }
        #endif // os(macOS)
        .onChange(of: isDropTargeted) { oldValue, newValue in
            guard oldValue != newValue else { return }
            animationScale = newValue ? 1.1 : 1.0
            animationOpacity = newValue ? 1.0 : 0.0
        }
        .animation(.bouncy,
                   value: animationScale)
        .animation(.snappy,
                   value: animationOpacity)
    }
}
