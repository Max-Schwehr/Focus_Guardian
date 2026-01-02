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


@MainActor
final class BlockerSession: ObservableObject {
    
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
                self.runAppBlocker()
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
    
    
    func hideFrontMostApp() {
        NSWorkspace.shared.frontmostApplication?.hide()
    }

    // MARK: - Identify when to block / where to block
    
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
    
    func runAppBlocker() {
        guard let frontMostAppName = getFrontMostApp().name else { return }
        if blockedApps.contains(frontMostAppName) {
            hideFrontMostApp()
        }
    }
    
}
