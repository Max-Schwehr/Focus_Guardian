//
//  WebsiteFormatter.swift
//  FocusGuardian
//
//  Created by Maximiliaen Schwehr on 12/30/25.
//

import Foundation

enum WebsiteFormatType {
    case bareDomain
    case fullURL
}

func formatURL(url : String, to formatOutputType: WebsiteFormatType) -> String {
    var urlInstance = url
    
    urlInstance = urlInstance.lowercased()
    
    if formatOutputType == .fullURL {
        let fullURLVersion = "https://www." + urlInstance // Note: This always assumes the website is https, which may be incorrect, but is generally standardized.
        
        urlInstance = fullURLVersion
    }
    
    return urlInstance
}
