//
//  RunAppleScript.swift
//  FocusGuardian
//
//  Created by Maximiliaen Schwehr on 12/28/25.
//

import Foundation

func runAppleScript(_ source: String) {
    DispatchQueue.global(qos: .background).async {
        let script = NSAppleScript(source: source)
        var error: NSDictionary?

        script?.executeAndReturnError(&error)

        if let error = error {
            print("AppleScript error:", error)
        }
    }
}
