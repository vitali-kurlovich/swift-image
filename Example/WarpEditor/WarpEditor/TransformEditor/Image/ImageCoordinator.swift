//
//  ImageCoordinator.swift
//  WarpEditor
//
//  Created by Vitali Kurlovich on 11.03.26.
//

import Observation
import SwiftUI

enum ImageCoordinatorState {
    case ready(Image)
    case inProgress(Image?)
    case error(error: Error, Image?)
    case noImage
}

@Observable
final class ImageCoordinator {
    var state: ImageCoordinatorState = .noImage
}

extension ImageCoordinator {
    var image: Image? {
        switch state {
        case let .ready(image):
            return image
        case let .inProgress(image):
            return image
        case let .error(_, image):
            return image
        case .noImage:
            return nil
        }
    }

    var inProgress: Bool {
        switch state {
        case .inProgress:
            return true
        case .error, .noImage, .ready:
            return false
        }
    }
}

extension ImageCoordinator {
    func update(with image: Image?) {
        if let image {
            state = .ready(image)
        } else {
            state = .noImage
        }
    }

    func clear() {
        state = .noImage
    }

    func catchError(error: Error) {
        state = .error(error: error, image)
        debugPrint(error)
    }

    func load(imageURL: URL) {
        state = .inProgress(image)
        Task {
            do {
                guard imageURL.startAccessingSecurityScopedResource() else { return }

                let image = try await Image(importing: imageURL, contentType: nil)
                update(with: image)

                imageURL.stopAccessingSecurityScopedResource()
            } catch {
                catchError(error: error)
            }
        }
    }
}
