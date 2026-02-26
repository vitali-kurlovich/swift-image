//
//  UVGrid.swift
//  wrap-transform
//
//  Created by Vitali Kurlovich on 26.02.26.
//

import SwiftUI

struct UVGrid: View {
    let spacing: CGFloat

    init(spacing: CGFloat = 8) {
        self.spacing = spacing
    }

    var body: some View {
        ZStack {
            UVSubGrid()
        }.overlay {
            VStack(spacing: spacing) {
                HStack(spacing: spacing) {
                    UVSubGrid(spacing: spacing, first: .red.secondary, second: .blue.secondary)

                    UVSubGrid(spacing: spacing, first: .green.secondary, second: .yellow.secondary)
                }

                HStack(spacing: spacing) {
                    UVSubGrid(spacing: spacing, first: .mint.secondary, second: .indigo.secondary)

                    UVSubGrid(spacing: spacing, first: .teal.secondary, second: .purple.secondary)
                }
            }
            .padding(spacing / 2)
            .opacity(0.8)
        }
    }
}

private struct UVSubGrid<First: ShapeStyle, Second: ShapeStyle>: View {
    let spacing: CGFloat
    let first: First
    let second: Second

    init(spacing: CGFloat = 2, first: First, second: Second) {
        self.spacing = spacing
        self.first = first
        self.second = second
    }

    init(spacing: CGFloat = 2, first: Color = .primary, second: Color = .secondary) where First == Color, Second == Color {
        self.spacing = spacing
        self.first = first
        self.second = second
    }

    var body: some View {
        ZStack {
            VStack(spacing: spacing) {
                HStack(spacing: spacing) {
                    Rectangle().fill(first)
                    Rectangle().fill(second)
                }

                HStack(spacing: spacing) {
                    Rectangle().fill(second)
                    Rectangle().fill(first)
                }
            }
        }
    }
}

#Preview {
    UVGrid()
        .frame(width: 200, height: 200)
}
