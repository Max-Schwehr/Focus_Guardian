//
//  AppBlockingView.swift
//  FocusGuardian
//
//  Created by Maximiliaen Schwehr on 1/1/26.
//

import SwiftUI
import AppKit
import UniformTypeIdentifiers

struct AppBlockingView: View {
    @State private var apps: [AppInfo] = []
    @State private var showingPicker = false
    @State private var showingQuestionMarkDetailView = false
    private let adaptiveColumn = [
            GridItem(.adaptive(minimum: 80))
        ]
    @State private var selectedApps : [String] = []
    @State private var searchText: String = ""
    
    private var filteredApps: [AppInfo] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return apps }
        return apps.filter { $0.name.localizedCaseInsensitiveContains(query) }
    }

    var body: some View {
        VStack {
            Text("Select an App to Block")
                .padding(.top, 10)
                .bold()
                .onAppear {
                    loadApplications()
                }
                .onDisappear {
                    blockedApps = selectedApps
                }
            HStack(spacing: 4) {
                Text("Apps must be in the Applications Folder")
                Image(systemName: "questionmark.circle")
                    .onTapGesture {
                        showingQuestionMarkDetailView = true
                    }
                    .popover(isPresented: $showingQuestionMarkDetailView) {
                        Text("Focus Guardian retrieves these apps from the /Applications and /System/Applications folders on your Mac. And filters out apps with no found names.")
                            .padding()
                            .frame(width: 300)
                    }
            }  .foregroundStyle(.secondary)
            
            HStack {
                Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
                TextField("Search apps", text: $searchText)
                    .textFieldStyle(.roundedBorder)
            }
            .padding(.horizontal)

            ScrollView {
                LazyVGrid(columns: adaptiveColumn, spacing: 10) {
                    ForEach (filteredApps) { app in
                        let idOrPath = app.bundleID ?? app.url.path
                        AppCell(
                            isSelected: Binding<Bool>(
                                get: { selectedApps.contains(idOrPath) },
                                set: { newValue in
                                    if newValue {
                                        if !selectedApps.contains(idOrPath) {
                                            selectedApps.append(idOrPath)
                                        }
                                    } else {
                                        selectedApps.removeAll { $0 == idOrPath }
                                    }
                                }
                            ),
                            icon: NSWorkspace.shared.icon(forFile: app.url.path),
                            title: app.name
                        )
                        
                    }
                }
            }
        }
        
//        VStack(alignment: .leading, spacing: 12) {
//            Text("Apps in /Applications")
//                .font(.headline)
//                .padding(.top, 10)
//
//            Button("Load from /Applications") {
//                loadApplications()
//            }
//
//            if apps.isEmpty {
//                Text("No apps loaded")
//                    .foregroundColor(.secondary)
//            } else {
//                List(apps) { app in
//                    HStack(spacing: 8) {
//                        Image(nsImage: NSWorkspace.shared.icon(forFile: app.url.path))
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 20, height: 20)
//                        VStack(alignment: .leading, spacing: 2) {
//                            Text(app.name)
//                            Text(app.bundleID ?? "(no bundle id)")
//                                .foregroundColor(.secondary)
//                                .font(.caption)
//                        }
//                    }
//                }
//                .frame(minHeight: 200)
//            }
//        }
        .padding()
    }

    private func loadApplications() {
        apps = AppDiscoveryService.discoverTopLevelApps()
    }
}

#Preview {
    AppBlockingView()
        .frame(width: 500, height: 550)
}
