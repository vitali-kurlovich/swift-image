//
//  Created by Vitali Kurlovich on 7.01.26.
//

import SwiftUI
import SwiftUIComponents

struct ImageDropPlaceholder: View {
    @Binding var isDropTargeted: Bool

    let action: @MainActor () -> Void

    init(isDropTargeted: Binding<Bool>, action: @escaping () -> Void = {}) {
        _isDropTargeted = isDropTargeted
        self.action = action
    }

    var body: some View {
        Button {
            action()
        } label: {
            VStack(spacing: 8) {
                Image(systemName: "photo.badge.arrow.down")
                    .symbolRenderingMode(.hierarchical)
                    .font(
                        .largeTitle
                    )

                Text("Drag an image here!")
                    .font(.headline)
                    .foregroundColor(.gray)
            }
            .padding()
            .frame(aspectRatio: 1)
        }
        .buttonStyle(.borderless)
        .background {
            RoundedRectangle(cornerRadius: 42)

                .fill(isDropTargeted ? Color.accentColor.gradient.quaternary : Color.clear.gradient.quaternary)
                .stroke(isDropTargeted ?
                    Color.accentColor :
                    Color.secondary,
                    lineWidth: isDropTargeted ? 3 : 1)
        }
    }
}

#Preview {
    @Previewable @State var isDropTargeted = true
    VStack {
        ImageDropPlaceholder(isDropTargeted: $isDropTargeted)
        Button("Toggle") {
            isDropTargeted.toggle()
        }
    }
}
