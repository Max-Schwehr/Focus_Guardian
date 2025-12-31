//
//  WebsiteBlockingView.swift
//  FocusGuardian
//
//  Created by Maximiliaen Schwehr on 12/30/25.
//

import SwiftUI
internal import System

struct WebsiteBlockingView: View {
    @State private var blockedWebsitesLocal : [String] = []
    @State private var textField: String = ""
    var body: some View {
        Text("Enter a website to block")
            .padding(.top, 10)
            .bold()
            .onDisappear {
                blockedWebsites = blockedWebsitesLocal
            }
        
        TextField("example.com", text: $textField)
            .onSubmit {
                blockedWebsitesLocal.append(textField)
            }
            .font(.title2)
            .bold()
            .fontDesign(.monospaced)
            .padding(6)
            .background(Color.white)
            .cornerRadius(10)
            .frame(width: 300)
        
        
        WebsiteCell(url: "apple.com")
        WebsiteCell(url: "instagram.com")
        WebsiteCell(url: "youtube.com")


        
        HStack {
            VStack {
                    ForEach(blockedWebsitesLocal, id: \.self) { website in
                        Text(website)
                            .padding(.vertical, 3)
                    }
                
            }
        }

    }
}

#Preview {
    SessionCreationView(step: .contentBlockingInput)
        .frame(width: 517, height: 573)
}
