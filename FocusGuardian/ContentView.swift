//
//  ContentView.swift
//  KoreanMom Iteration 2
//
//  Created by Maximiliaen Schwehr on 10/17/25.
//

import SwiftUI

struct ContentView: View {
    enum Route: Hashable {
        case home
        case sessions
        case settings
    }

    @State private var path = NavigationPath()
    @State private var selection: Route = .home

   
    var body: some View {
        NavigationStack(path: $path) {
            Group { // Switch the view based on the users selected page
                switch selection {
                case .home:
                    HomeView()
                case .sessions:
                    SessionsView()
                case .settings:
                    SettingsView()
                }
            }
            .navigationTitle("")
            .toolbarBackgroundVisibility(.hidden) // Note does not show in Previews
            .toolbar {
                ToolbarItemGroup {
                    Picker("", selection: $selection) {
                        Label("Home", systemImage: "house").tag(Route.home)
                        Label("Sessions", systemImage: "list.bullet").tag(Route.sessions)
                        Label("Settings", systemImage: "gear").tag(Route.settings)
                    }
                    .pickerStyle(.segmented)
                    .controlSize(.extraLarge)
                }
            }
           
        }
    }
}

#Preview {
    ContentView()
}
