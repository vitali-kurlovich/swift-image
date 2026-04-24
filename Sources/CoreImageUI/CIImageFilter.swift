//
//  CIImageFilter.swift
//  swift-image
//
//  Created by Vitali Kurlovich on 24.03.26.
//

import CoreImage

import SwiftUI

struct FilterPanel: View {
    let filter: CIFilter

    var body: some View {
        DisclosureGroup {} label: {
            Text(filter.name)
        }
    }
}

public protocol CIInputImage: AnyObject {
    var inputImage: CIImage? { get set }
}

public protocol CIOutputImage: AnyObject {
    var outputImage: CIImage? { get }
}

public typealias CIImageFilter = CIInputImage & CIOutputImage

class CIFilterNode: CIOutputImage {
    let filter: CIFilter

    init(filter: CIFilter) {
        self.filter = filter
    }

    var outputImage: CIImage? {
        filter.outputImage
    }

    func dd() {}
}

// CICheckerboardGenerator

extension CIFilterNode {
    func foo() {}
}

class InputFilterNode: CIFilterNode, CIInputImage {
    var inputImage: CIImage?
}

final class InputFilterNodeAdapter: InputFilterNode {
    let getter: (CIFilterNode) -> CIImage?
    let setter: (CIImage?, CIFilterNode) -> Void

    override var inputImage: CIImage? {
        get {
            getter(self)
        }
        set {
            setter(newValue, self)
        }
    }

    init(filter: CIFilter, getter: @escaping (CIFilterNode) -> CIImage?, setter: @escaping (CIImage?, CIFilterNode) -> Void) {
        self.getter = getter
        self.setter = setter
        super.init(filter: filter)
    }
}

// CIFilter

final class OutputFilterNode<Filter: CIFilterProtocol>: CIFilterNode {
    var outputFilter: Filter {
        filter as! Filter
    }
}
