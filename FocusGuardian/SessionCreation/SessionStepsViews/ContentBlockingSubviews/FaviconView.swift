//
//  FaviconView.swift
//  FocusGuardian
//
//  Created by Maximiliaen Schwehr on 12/30/25.
//

import SwiftUI
import AppKit
import Combine
import FaviconFinder


struct FaviconView: View {

    @State var url = "https://www.tiktok.com"
    @ObservedObject var imageLoader = ImageLoader()

    var body: some View {
        VStack {
            Image(nsImage: self.imageLoader.image ?? NSImage())
                .resizable()
                .aspectRatio(contentMode: .fill)
                .cornerRadius(16)
                .padding(3)
                .glassEffect(.regular.tint(.white), in: .rect(cornerRadius: 16.0))

//                .frame(width: 20, height: 20, alignment: .center)

                .onAppear {
                    guard let url = URL(string: self.url) else {
                        print("Not a valid URL: \(self.url)")
                        return
                    }
                    
                    Task { try await self.imageLoader.load(url: url) }
                }
//            if false {
//                
//                TextField("Enter URL", text: $url)
//                    .border(Color.black)
//                    .autocorrectionDisabled()
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .padding(25.0)
//                
//                Button(action: {
//                    guard let url = URL(string: self.url) else {
//                        print("Not a valid URL: \(self.url)")
//                        return
//                    }
//                    
//                    Task { try await self.imageLoader.load(url: url) }
//                    
//                }, label: {
//                    Text("Download Favicon")
//                }).padding(50.0)
//                
//                Spacer()
//            }
        }
    }
}


#Preview {
    FaviconView()
        .frame(width: 50, height: 50)
        .padding()
}

