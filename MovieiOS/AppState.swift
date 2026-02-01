//
//  AppState.swift
//  MovieiOS
//
//  Central app state: Flutter engine manager, channels, and main view model.
//

import Combine
import Flutter
import SwiftUI

@MainActor
final class AppState: ObservableObject {
    let engineManager: FlutterEngineManager
    let mainTabViewModel: MainTabViewModel

    init() {
        let manager = FlutterEngineManager()
        manager.initialize()  // Reads config from ci_brand.xcconfig via Info.plist

        let viewModel = MainTabViewModel(engineManager: manager)

        MethodChannelRegistry.registerAll(
            browseEngine: manager.browseEngine,
            favoriteEngine: manager.favoriteEngine,
            onNavigateToMovieDetail: { [weak viewModel] movieId in
                viewModel?.navigateToMovieDetail(movieId: movieId)
            }
        )
        EventChannelRegistry.register(engine: manager.browseEngine, engineId: Constants.Engine.browse)
        EventChannelRegistry.register(engine: manager.favoriteEngine, engineId: Constants.Engine.favorite)

        self.engineManager = manager
        self.mainTabViewModel = viewModel
    }
}
