//
//
//  Created by Maximiliaen Schwehr on 10/17/25.
//

import SwiftUI
import SwiftData

@main
struct FocusGuardian_App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .defaultSize(width: 300, height: 400)
        .windowResizability(.contentSize)
        .modelContainer(for: [FocusSession.self])
    }
}
