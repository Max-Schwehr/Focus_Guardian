//
//  KoreanMom_Iteration_2App.swift
//  KoreanMom Iteration 2
//
//  Created by Maximiliaen Schwehr on 10/17/25.
//

import SwiftUI
import SwiftData

@main
struct KoreanMom_Iteration_2App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [FocusSession.self])
    }
}
