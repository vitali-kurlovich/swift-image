//
//  Created by Vitali Kurlovich on 24.12.25.
//

import Foundation
import Testing
@testable import WrapEditor
internal import CoreGraphics

private let tolerance: Double = 0.0000001

@Suite("CoordinateSpace")
struct CoordinateSpaceTests {
    typealias SpaceDesc = (local: CGRect, global: CGRect)

    @Test("Local/Global ", arguments: [
        (
            local: CGRect(x: 326, y: 289, width: 452, height: 372),
            global: CGRect(x: 326, y: 289, width: 452, height: 372)
        ),
        (
            local: CGRect(x: 0, y: 0, width: 452, height: 372),
            global: CGRect(x: 326, y: 289, width: 452, height: 372)
        ),
        (
            local: CGRect(x: 0, y: 0, width: 452, height: 372),
            global: CGRect(x: 326, y: 289, width: 452 * 3, height: 372 * 4)
        ),

    ])
    func localAndGlobal(_ rects: SpaceDesc) throws {
        let local = rects.local
        let global = rects.global

        let space = CoordinateSpace(local: local, global: global)

        #expect(
            space.transform(global)
                .isEqual(to: local, tolerance: tolerance)
        )

        #expect(
            space.transform(global.origin)
                .isEqual(to: local.origin, tolerance: tolerance)
        )

        #expect(
            space.inverseTransform(local)
                .isEqual(to: global, tolerance: tolerance)
        )

        #expect(
            space.inverseTransform(local.origin)
                .isEqual(to: global.origin, tolerance: tolerance)
        )
    }

    @Test("Convert")
    func convert() {
        let sourceSpace = CoordinateSpace(local: CGPoint(x: 0, y: 0), global: CGPoint(x: 326, y: 289))
        let targetSpace = CoordinateSpace(local: CGPoint(x: 0, y: 0), global: CGPoint(x: 0, y: 0))

        let space = CoordinateSpace(from: sourceSpace, to: targetSpace)

        #expect(
            space.transform(CGPoint(x: 0, y: 0)) == CGPoint(x: 326, y: 289)
        )

        #expect(
            space.inverseTransform(CGPoint(x: 326, y: 289)) == CGPoint(x: 0, y: 0)
        )
    }

    @Test("Convert")
    func convert_1() {
        let sourceSpace = CoordinateSpace(local: CGPoint(x: 0, y: 0), global: CGPoint(x: 326, y: 289))
        let targetSpace = CoordinateSpace(local: CGPoint(x: 0, y: 0), global: CGPoint(x: 20, y: 30))

        let space = CoordinateSpace(from: sourceSpace, to: targetSpace)

        #expect(
            space.transform(CGPoint(x: 0, y: 0)) == CGPoint(x: 326 - 20, y: 289 - 30)
        )

        #expect(
            space.inverseTransform(CGPoint(x: 326 - 20, y: 289 - 30)) == CGPoint(x: 0, y: 0)
        )
    }
}
