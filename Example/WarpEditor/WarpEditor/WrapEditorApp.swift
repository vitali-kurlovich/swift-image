//
//  Created by Vitali Kurlovich on 26.02.26.
//

import SwiftUI
import WarpMetal

@main
struct WrapEditorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    do {
                        try await FreeDistortShader().compile()
                    } catch {
                        assertionFailure(error.localizedDescription)
                    }
                }
        }
    }
}
