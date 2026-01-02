//
//  RunAppleScript.swift
//  FocusGuardian
//
//  Created by Maximiliaen Schwehr on 12/28/25.
//

import Foundation
import AppKit

// This is also used in the views
var blockedWebsites : [String] = []
var blockedApps : [String] = []



/// `runAppleScript` executes and apple script code given by the first parameter using the input of list.
/// - Parameters:
///   - source: Represents the apple script code to be ran. I
func runAppleScript(_ source: String) {
    if let script = NSAppleScript(source: source) {
        var error: NSDictionary?
        script.executeAndReturnError(&error)

        if let error = error {
            print("AppleScript Error:", error)
        }
    }
}

func getFrontMostApp() -> (name: String?, bundleID: String?) {
    let app = NSWorkspace.shared.frontmostApplication
    return (app?.localizedName, app?.bundleIdentifier)
}

