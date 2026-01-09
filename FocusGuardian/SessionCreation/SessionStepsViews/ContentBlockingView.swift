//
//  ContentBlockingView.swift
//  FocusGuardian
//
//  Created by Maximiliaen Schwehr on 12/29/25.
//

import SwiftUI

struct ContentBlockingView: View {
    @State private var showingWebsiteBlocker = true
    var body: some View {
        VStack(spacing: 10) {
            VStack(spacing: 3) {
                
                GlassSegmentedPicker(isWebSelected: $showingWebsiteBlocker)
                    .frame(height: 30)
                    .padding(.top, 5)
                
                Divider()
                    .padding(.top, 12)
                    .frame(width: 400)
            }
            .padding(.top, 30)
            
            Spacer()

            if showingWebsiteBlocker {
                WebsiteBlockingView()
            } else {
                AppBlockingView()
            }
            
            Spacer()
            
        }
    }
}

#Preview {
    ContentBlockingView()
        .padding()
        .background(Color.gray.opacity(0.1))
}

