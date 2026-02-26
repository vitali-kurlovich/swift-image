//
//  Created by Vitali Kurlovich on 7.01.26.
//

import SwiftUI

struct ImageDropPlaceholder: View {
    @Binding var isDropTargeted: Bool

    var body: some View {
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
        .frame(minWidth: 200, minHeight: 200)
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
