//
//  ContentBlockingView.swift
//  FocusGuardian
//
//  Created by Maximiliaen Schwehr on 12/29/25.
//

import SwiftUI

struct ContentBlockingView: View {
    @State private var showingWebsiteBlocker = true
    @State private var blockedWebsites : [String] = []
    @State private var textField : String = ""
    var body: some View {
        VStack(spacing: 10) {
            VStack(spacing: 3) {
                Text("Content Blocking")
                    .bold()
                    .font(.title3)
                
                Text("Block websites or apps for the duration of your focus!")
                    .foregroundStyle(.secondary)
                
                Picker("", selection: $showingWebsiteBlocker) {
                    Text("Websites")
                        .tag(true)
                    Text("Apps")
                        .tag(false)
                }
                .pickerStyle(.segmented)
                .padding(.top, 5)
                
                Divider()
                    .padding(.top, 8)
                    .frame(width: 400)
            }
            
            
            Text("Enter a website to block")
                .padding(.top, 10)
                .bold()
            
            TextField("example.com", text: $textField)
                .onSubmit {
                    blockedWebsites.append(textField)
                }
                .frame(width: 400)
            
            HStack {
                VStack {
                    ScrollView {
                        ForEach(blockedWebsites, id: \.self) { website in
                            Text(website)
                                .padding(.vertical, 3)
                        }
                    }
                }
            }
            
            
        }
    }
}

#Preview {
    ContentBlockingView()
        .padding()
        .background(Color.gray.opacity(0.1))
}
