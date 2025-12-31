//
//  WebsiteFaviconFinder.swift
//  FocusGuardian
//
//  Created by Maximiliaen Schwehr on 12/30/25.
//

import SwiftUI
import AppKit
import Combine
import FaviconFinder


final class ImageLoader: ObservableObject {
    @Published private(set) var image: NSImage? = nil
    
    func load(url: URL) async throws {
        let favicon = try await FaviconFinder(
            url: url,
            configuration: .init(
                preferredSource: .html,
                preferences: [
                    .html: FaviconFormatType.appleTouchIcon.rawValue,
                    .ico: "favicon.ico",
                ],
                acceptHeaderImage: false
            )
        )
            .fetchFaviconURLs()
            .download()
            .largest()

        DispatchQueue.main.async {
            self.image = favicon.image?.image
        }
    }
    
}
