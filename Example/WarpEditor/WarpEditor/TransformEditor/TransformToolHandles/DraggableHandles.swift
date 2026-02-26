//
//  Created by Vitali Kurlovich on 1.01.26.
//

import SwiftUI

enum DragState {
    case inactive
    case pressing
    case dragging(translation: CGSize)

    var translation: CGSize {
        switch self {
        case .inactive, .pressing:
            return .zero
        case let .dragging(translation):
            return translation
        }
    }

    var isActive: Bool {
        switch self {
        case .inactive:
            return false
        case .pressing, .dragging:
            return true
        }
    }

    var isDragging: Bool {
        switch self {
        case .inactive, .pressing:
            return false
        case .dragging:
            return true
        }
    }
}

struct DraggableHandles: View {
    @Binding
    var location: CGPoint

    @State var isDragging = false

    @GestureState private var dragState = DragState.inactive

    init(_ location: Binding<CGPoint>) {
        _location = location
    }

    var body: some View {
        let minimumLongPressDuration = 0.06
        let longPressDrag = LongPressGesture(minimumDuration: minimumLongPressDuration)
            .sequenced(before: DragGesture())
            .updating($dragState) { value, state, _ in
                switch value {
                // Long press begins.
                case .first:
                    state = .pressing

                // Long press confirmed, dragging may begin.
                case let .second(_, drag):
                    let translation = drag?.translation ?? .zero
                    state = .dragging(translation: translation)

                    var newLocation = location
                    newLocation.x += translation.width
                    newLocation.y += translation.height
                    location = newLocation

                // Dragging ended or the long press cancelled.
                default:
                    state = .inactive
                }
            }.onEnded { value in
                guard case .second(true, let drag?) = value else { return }

                var newLocation = location
                newLocation.x += drag.translation.width
                newLocation.y += drag.translation.height
                location = newLocation
            }

        return Image(systemName: "circle.fill")
            .foregroundStyle(dragState.isActive ? Color.red.gradient : Color.accentColor.gradient)
            .gesture(longPressDrag)
    }
}
