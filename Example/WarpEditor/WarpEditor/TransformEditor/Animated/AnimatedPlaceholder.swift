//
//  Created by Vitali Kurlovich on 7.01.26.
//

import SwiftUI

struct AnimatedPlaceholder: View {
    @State private var animationScale = 1.0

    @Binding var scale: CGFloat

    var body: some View {
        RoundedRectangle(cornerRadius: 150 * scale)
            .fill(.indigo.gradient.quaternary)
            .frame(width: 420 * scale, height: 340 * scale)
            .overlay {
                RoundedRectangle(cornerRadius: 140 * scale)

                    .fill(.indigo.gradient.secondary)
                    .frame(width: 400 * scale, height: 320 * scale)
                    .scaleEffect(animationScale)
            }
            .overlay {
                Image(systemName: "heart.circle.fill")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.yellow.gradient, .green, .red.gradient)
                    .font(.system(size: 220 * scale, weight: .semibold))
                    .symbolEffect(.breathe)
                    .shadow(radius: 6, y: 3)
            }
            .padding()
            .animation(
                .easeInOut(duration: 0.9)
                    .repeatForever(autoreverses: true),
                value: animationScale
            )
            .onAppear {
                animationScale = 0.96
            }
    }
}

#Preview {
    @Previewable @State var scale: CGFloat = 1
    AnimatedPlaceholder(scale: $scale)
}
