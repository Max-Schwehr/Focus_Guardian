//
//  ContentView.swift
//  KoreanMom Iteration 2
//
//  Created by Maximiliaen Schwehr on 10/17/25.
//

import SwiftUI

struct ContentView: View {
    private let minWindowWidth: CGFloat = 500
    private let maxWindowWidth: CGFloat = 400
    private let minWindowHeight: CGFloat = 450
    private let maxWindowHeight: CGFloat = 600

    enum Route: Hashable {
        case home
        case sessions
        case settings
    }

    @State private var path = NavigationPath()
    @State var selection: Route = .home

   
    var body: some View {
        NavigationStack(path: $path) {
            Group { // Switch the view based on the users selected page
                switch selection {
                case .home:
                    SessionCreationView()
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
        .frame(
            minWidth: minWindowWidth,
            idealWidth: maxWindowWidth,
            maxWidth: maxWindowWidth,
            minHeight: minWindowHeight,
            idealHeight: maxWindowHeight,
            maxHeight: maxWindowHeight
        )
    }
}

#Preview {
    ContentView()
}
