//
//  AppConfig.swift
//  MovieiOS
//
//  App configuration loaded from ci_brand.xcconfig via Info.plist.
//  Values are injected at build time through INFOPLIST_KEY_* settings.
//

import Foundation

enum AppConfig {
    // MARK: - Auth (TODO: Replace with proper auth flow e.g., Keychain)
    static let apiToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2OGYxNTcxMzMxODkwMDUwYzhhNGQ0NTE0NDM1OTYxNiIsIm5iZiI6MTc2OTgyOTAyMS4wODYwMDAyLCJzdWIiOiI2OTdkNzI5ZGI4YmJhMTgxMDIxNWUyMGEiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.garhbAHms5Jl-D5aqGJ2F-ZQsiqr7TEUP6H-gyKGORU"
    static let userId = "21712006"
    
    // MARK: - Brand Config (from ci_brand.xcconfig via Info.plist)
    
    /// App display name from APP_DISPLAY_NAME in xcconfig
    static var appName: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
        ?? Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
        ?? "MovieiOS"
    }
    
    /// Base URL for API requests from BASE_URL in xcconfig
    static var baseUrl: String {
        Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String
        ?? "https://api.themoviedb.org/3"
    }
    
    /// Base URL for images from IMAGE_BASE_URL in xcconfig
    static var imageBaseUrl: String {
        Bundle.main.object(forInfoDictionaryKey: "IMAGE_BASE_URL") as? String
        ?? "https://image.tmdb.org/t/p/w500"
    }
    
    /// WebSocket URL from WEBSOCKET_URL in xcconfig
    static var websocketUrl: String {
        Bundle.main.object(forInfoDictionaryKey: "WEBSOCKET_URL") as? String
        ?? ""
    }
    
    /// Deep link scheme from DEEP_LINK_SCHEME in xcconfig
    static var deepLinkScheme: String {
        Bundle.main.object(forInfoDictionaryKey: "DEEP_LINK_SCHEME") as? String
        ?? ""
    }
    
    /// Support email from SUPPORT_EMAIL in xcconfig
    static var supportEmail: String {
        Bundle.main.object(forInfoDictionaryKey: "SUPPORT_EMAIL") as? String
        ?? ""
    }
    
    // MARK: - Flutter Engine Args
    
    /// Arguments to pass to Flutter engine, matching Android pattern:
    /// [apiToken, userId, baseUrl, appName, imageBaseUrl]
    static var flutterEngineArgs: [String] {
        [apiToken, userId, baseUrl, appName, imageBaseUrl]
    }
}
