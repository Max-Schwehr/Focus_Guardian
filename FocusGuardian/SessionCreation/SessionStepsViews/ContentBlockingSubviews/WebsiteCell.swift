//
//  WebsiteCell.swift
//  FocusGuardian
//
//  Created by Maximiliaen Schwehr on 12/30/25.
//

import SwiftUI

struct WebsiteCell: View {
    var url : String
    @State private var formattedURL : String = ""
    var body: some View {
        HStack {
            FaviconView(url: formatURL(url: url, to: .fullURL))
                .frame(width: 20, height: 20)
                .onAppear {
                    print("FormattedURL: \(formatURL(url: url, to: .fullURL))")
                }
            Text(formatURL(url: url, to: .bareDomain))
        }
        .padding(7)
        .glassEffect(in: .rect(cornerRadius: 16.0))
    }
}

#Preview {
    WebsiteCell(url: "tiktok.com")
        .padding()
}
