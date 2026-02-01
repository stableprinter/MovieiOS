//
//  ContentView.swift
//  MovieiOS
//
//  Root content: MainTabView with Browse and Favorite tabs.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var appState: AppState

    var body: some View {
        MainTabView(viewModel: appState.mainTabViewModel)
    }
}

#Preview {
    ContentView(appState: AppState())
}
