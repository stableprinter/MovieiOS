//
//  MovieiOSApp.swift
//  MovieiOS
//
//  Hybrid native + Flutter app. Hosts Flutter views in Browse and Favorite tabs.
//

import SwiftUI

@main
struct MovieiOSApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView(appState: appState)
        }
    }
}
