//
//  WebsiteBlockerSession.swift
//  FocusGuardian
//
//  Created by Maximiliaen Schwehr on 12/29/25.
//

import Foundation
import Combine
import AppKit
import SwiftUI

// This is also used in the views
var blockedWebsites : [String] = []


@MainActor
final class WebsiteBlockerSession: ObservableObject {

    @Published private(set) var isRunning: Bool = false

    private var timer: DispatchSourceTimer?

    func start() {
        guard timer == nil else { return }

        isRunning = true

        let t = DispatchSource.makeTimerSource(queue: .global(qos: .background))
        t.schedule(deadline: .now(), repeating: .seconds(5), leeway: .seconds(1))

        t.setEventHandler { [weak self] in
            guard let self else { return }
            Task { @MainActor in
                guard self.isRunning else { return }
                self.runWebsiteBlocker()
            }
        }

        t.resume()
        timer = t

        print("✅ WebsiteBlockerSession started:", ObjectIdentifier(self))
    }

    func stop() {
        isRunning = false
        timer?.cancel()
        timer = nil

        print("🛑 WebsiteBlockerSession stopped:", ObjectIdentifier(self))
    }

    deinit {
        timer?.cancel()
    }

    // MARK: - Identify which app to block

    func getFrontMostApp() -> (name: String?, bundleID: String?) {
        let app = NSWorkspace.shared.frontmostApplication
        return (app?.localizedName, app?.bundleIdentifier)
    }

    func runWebsiteBlocker() {
        guard let frontMostAppBundleID = getFrontMostApp().bundleID else { return }

        if frontMostAppBundleID == "com.apple.Safari" {
            blockWebsitesOnSafari()
        } else if frontMostAppBundleID == "com.google.Chrome" {
            blockWebsitesOnGoogleChrome()
        } else if frontMostAppBundleID == "company.thebrowser.Browser" {
            blockWebsitesOnArc()
        }
    }
}
