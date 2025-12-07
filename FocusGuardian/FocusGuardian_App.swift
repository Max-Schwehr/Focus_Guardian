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
        .modelContainer(for: [FocusSession.self])
    }
}
