//
//  MainTabView.swift
//  MovieiOS
//
//  Root view with bottom tab bar (Browse, Favorite). Each tab hosts full-screen Flutter view.
//

import SwiftUI

struct MainTabView: View {
    @ObservedObject var viewModel: MainTabViewModel

    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            FlutterViewControllerRepresentable(engine: viewModel.browseEngine)
                .tabItem {
                    Label("Browse", systemImage: "film.stack")
                }
                .tag(MainTab.browse)

            FlutterViewControllerRepresentable(engine: viewModel.favoriteEngine)
                .tabItem {
                    Label("Favorite", systemImage: "heart.fill")
                }
                .tag(MainTab.favorite)
        }
        .fullScreenCover(isPresented: Binding(
            get: { viewModel.isPresentingExtra },
            set: { if !$0 { viewModel.dismissExtraScreen() } }
        )) {
            if let engineId = viewModel.presentedExtraEngineId,
               let engine = viewModel.engine(for: engineId) {
                ExtraScreenView(engine: engine) {
                    viewModel.dismissExtraScreen()
                }
            }
        }
    }
}

enum MainTab: Int {
    case browse = 0
    case favorite = 1
}
