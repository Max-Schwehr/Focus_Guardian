//
//  getFrontMostApp.swift
//  FocusGuardian
//
//  Created by Maximiliaen Schwehr on 12/29/25.
//

import Foundation
import AppKit

func getFrontMostApp() -> (name: String?, bundleID: String?) {
    let app = NSWorkspace.shared.frontmostApplication
    return (app?.localizedName, app?.bundleIdentifier)
}
