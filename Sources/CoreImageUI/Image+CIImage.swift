//
//  Created by Vitali Kurlovich on 24.03.26.
//

import CoreImage
import SwiftUI

public extension Image {
    init(ciImage: CIImage) {
        #if canImport(UIKit)
            let image = UIImage(ciImage: ciImage)
            self.init(uiImage: image)
        #endif

        #if canImport(AppKit)
            let rep = NSCIImageRep(ciImage: ciImage)
            let image = NSImage(size: rep.size)
            image.addRepresentation(rep)
            self.init(nsImage: image)
        #endif
    }
}
