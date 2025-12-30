//
//  WebsiteBlockerSession.swift
//  FocusGuardian
//
//  Created by Maximiliaen Schwehr on 12/29/25.
//

import Foundation
import Combine
import AppKit

final class WebsiteBlockerSession : ObservableObject {
    // Start Function -> Run Website Blocker -> Identifies app & Runs -> Runs Blocker (Found in other file)
    
    
    let blockedWebsites = ["youtube.com", "instagram.com"]

    // Optional: expose state to your UI safely
    @Published private(set) var isRunning: Bool = false
    
    private var websiteBlockerTimer: DispatchSourceTimer?

    
    // MARK: - Timer / Loop
    
    private var timer: DispatchSourceTimer?
    
    /// Start calling `runWebsiteBlocker()` every 5 seconds.
    /// Safe to call multiple times (won't double-start).
    func start() {
        guard timer == nil else { return }
        
        isRunning = true
        
        let t = DispatchSource.makeTimerSource(queue: DispatchQueue.global(qos: .background))
        t.schedule(deadline: .now(), repeating: .seconds(5), leeway: .seconds(1))
        
        // IMPORTANT:
        // Timer fires on background queue.
        // We hop to MainActor before calling `runWebsiteBlocker()` so any UI/@Published updates are safe.
        t.setEventHandler { [weak self] in
            guard let self else { return }
            Task { @MainActor in
                guard self.isRunning else { return }
                self.runWebsiteBlocker()
            }
        }
        
        t.resume()
        timer = t
    }
    
    /// Stop the repeating calls immediately.
    func stop() {
        isRunning = false
        timer?.cancel()
        timer = nil
    }
    
    deinit {
        timer?.cancel()
        timer = nil
    }
    
    // MARK: - Identify which app to block
    
    func getFrontMostApp() -> (name: String?, bundleID: String?) {
        let app = NSWorkspace.shared.frontmostApplication
        return (app?.localizedName, app?.bundleIdentifier)
    }
    
    func runWebsiteBlocker() {
        guard let frontMostAppBundleID = getFrontMostApp().bundleID else {
            return
        }
        
        if frontMostAppBundleID == "com.apple.Safari" {
            print("Apple Safari In Focus")
            blockWebsitesOnSafari()
        } else if frontMostAppBundleID == "com.google.Chrome" {
            print("Google Crome In Focus")
            blockWebsitesOnGoogleChrome()
        } else {
            print("No browser in focus")
        }
    }
}





//    func startWebsiteBlocker() {
//        // Prevent double-start
//            if websiteBlockerTimer != nil { return }
//
//            let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global(qos: .background))
//
//            timer.schedule(
//                deadline: .now(),
//                repeating: .seconds(5),
//                leeway: .seconds(1)
//            )
//
//            timer.setEventHandler {
//                // Any SwiftUI/ObservableObject/SwiftData updates must happen on main
//                DispatchQueue.main.async {
//                    self.runWebsiteBlocker()
//                }
//            }
//
//            timer.resume()
//            websiteBlockerTimer = timer
//    }


//

//
//func stopWebsiteBlocker() {
//    if let t = websiteBlockerTimer {
//            t.setEventHandler {}   // avoid any last-second handler running
//            t.cancel()
//            websiteBlockerTimer = nil
//    }
//}
