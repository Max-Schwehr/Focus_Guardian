import Foundation
import AppKit

/// Contains information about an application.
struct AppInfo: Identifiable {
    /// Unique identifier for the app instance.
    let id: UUID
    /// Filesystem URL to the application bundle.
    let url: URL
    /// Display name of the application.
    let name: String
    /// The bundle identifier of the app, if available.
    let bundleID: String?
}

/// Service responsible for discovering installed applications.
/// 
/// Discovers top-level applications located in /Applications and /System/Applications.
/// Skips nested folders by using directory enumeration options to avoid descending into subdirectories.
/// Deduplicates apps by bundle identifier or app path, and returns the results sorted by app name.
final class AppDiscoveryService {
    
    /// Discovers top-level applications in standard application folders.
    /// - Returns: An array of `AppInfo` representing discovered applications.
    static func discoverTopLevelApps() -> [AppInfo] {
        let roots = ["/Applications", "/System/Applications"].compactMap { URL(string: "file://\($0)") }
        var apps: [AppInfo] = []
        var seenBundleIDs = Set<String>()
        var seenPaths = Set<URL>()
        
        // Enumeration options to skip hidden files and subdirectories
        let options: FileManager.DirectoryEnumerationOptions = [.skipsHiddenFiles, .skipsSubdirectoryDescendants]
        let resourceKeys: [URLResourceKey] = [.isDirectoryKey]
        let fileManager = FileManager.default
        
        for root in roots {
            guard let enumerator = fileManager.enumerator(at: root, includingPropertiesForKeys: resourceKeys, options: options) else {
                continue
            }
            
            for case let url as URL in enumerator {
                // Only consider directories ending with .app
                guard url.pathExtension == "app" else { continue }
                
                // Exclude Safari browser extensions packaged inside Safari.app
                let path = url.path
                if path.contains("Safari.app/Contents/PlugIns/") {
                    continue
                }
                
                // Skip if URL is already processed
                if seenPaths.contains(url) { continue }
                
                // Load bundle to get app info
                guard let bundle = Bundle(url: url) else { continue }
                let bundleID = bundle.bundleIdentifier
                
                // Deduplicate by bundleID if available, else by path
                if let id = bundleID {
                    if seenBundleIDs.contains(id) {
                        continue
                    } else {
                        seenBundleIDs.insert(id)
                    }
                } else {
                    if seenPaths.contains(url) {
                        continue
                    }
                }
                
                // Get app name, fallback to last path component
                let name = bundle.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ??
                    bundle.object(forInfoDictionaryKey: "CFBundleName") as? String ??
                    url.deletingPathExtension().lastPathComponent
                
                // Skip items with no name or blank/whitespace-only names
                if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    continue
                }
                
                // Add app info
                apps.append(AppInfo(id: UUID(), url: url, name: name, bundleID: bundleID))
                seenPaths.insert(url)
            }
        }
        
        // Sort apps by name
        return apps.sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
    }
}

