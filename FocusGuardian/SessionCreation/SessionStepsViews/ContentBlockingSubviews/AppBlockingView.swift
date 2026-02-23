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
    // MARK: - State
    
    @State private var apps: [AppInfo] = []
    @State private var showingPicker = false
    @State private var showingQuestionMarkDetailView = false
    @State private var selectedApps : [String] = []
    @State private var searchText: String = ""
    
    // MARK: - Computed Properties
    
    private var filteredApps: [AppInfo] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return apps }
        return apps.filter { $0.name.localizedCaseInsensitiveContains(query) }
    }

    // MARK: - Body
    
    var body: some View {
        VStack {
            // MARK: - Title/Header

            Text("Select an App to Block")
                .padding(.top, 10)
                .bold()
                .onAppear {
                    loadApplications()
                }
                .onDisappear {
                    blockedApps = selectedApps
                }
            
            // MARK: - Info/Help Section

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
            
            // MARK: - Search Bar

            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary.opacity(0.9))

                TextField("Search apps", text: $searchText)
                    .textFieldStyle(.plain)
                    .font(.title3.weight(.semibold))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 11)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(.thinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.55),
                                Color.white.opacity(0.12)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 4)
            .padding(.horizontal)
            
            // MARK: - App List

            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(filteredApps) { app in
                        let idOrPath = app.bundleID ?? app.url.path
                        let isSelected = selectedApps.contains(idOrPath)

                        HStack(spacing: 12) {
                            Image(nsImage: NSWorkspace.shared.icon(forFile: app.url.path))
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 34, height: 34)

                            Text(app.name)
                                .font(.body.weight(.semibold))
                                .lineLimit(1)

                            Spacer(minLength: 8)

                            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                                .font(.title3)
                                .foregroundStyle(isSelected ? Color.accentColor : Color.secondary)
                        }

                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .glassEffect(.regular.tint(isSelected ? .blue.opacity(0.05) : nil))
                        .padding(.horizontal)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation {
                                if isSelected {
                                    selectedApps.removeAll { $0 == idOrPath }
                                } else {
                                    selectedApps.append(idOrPath)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 2)
                .padding(.bottom, 4)
            }
            .frame(maxHeight: .infinity)
            .mask(
                LinearGradient(
                    stops: [
                        .init(color: .clear, location: 0),
                        .init(color: .black, location: 0.06),
                        .init(color: .black, location: 0.94),
                        .init(color: .clear, location: 1)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }

    // MARK: - Private Methods
    
    private func loadApplications() {
        apps = AppDiscoveryService.discoverTopLevelApps()
    }
}

 // MARK: - Preview

#Preview {
    AppBlockingView()
        .frame(width: 500, height: 550)
}
