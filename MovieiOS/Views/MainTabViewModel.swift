//
//  MainTabViewModel.swift
//  MovieiOS
//
//  View model for MainTabView. Manages Flutter engines and navigation to Extra screen.
//

import Combine
import Flutter
import SwiftUI

@MainActor
final class MainTabViewModel: ObservableObject {
    @Published var selectedTab: MainTab = .browse
    @Published var presentedExtraEngineId: String?
    @Published var presentedMovieId: Int?

    private let engineManager: FlutterEngineManager

    var browseEngine: FlutterEngine { engineManager.browseEngine }
    var favoriteEngine: FlutterEngine { engineManager.favoriteEngine }

    var isPresentingExtra: Bool { presentedExtraEngineId != nil }

    func engine(for id: String) -> FlutterEngine? {
        engineManager.engine(for: id)
    }

    init(engineManager: FlutterEngineManager) {
        self.engineManager = engineManager
    }

    func navigateToMovieDetail(movieId: Int) {
        let engineId = "\(Constants.Engine.extraPrefix)_\(Int64(Date().timeIntervalSince1970 * 1_000_000))"
        let engine = engineManager.createExtraEngine(
            engineId: engineId,
            entrypoint: Constants.Navigation.entryBrowse,
            initRoute: "\(Constants.Navigation.movieDetailRoutePrefix)\(movieId)",
            args: [AppConfig.apiToken, AppConfig.userId]
        )

        MethodChannelHandler.register(
            messenger: engine.binaryMessenger,
            engineId: engineId
        )
        EventChannelRegistry.register(engine: engine, engineId: engineId)

        presentedExtraEngineId = engineId
        presentedMovieId = movieId
    }

    func dismissExtraScreen() {
        guard let engineId = presentedExtraEngineId else { return }
        engineManager.removeEngine(engineId)
        EventChannelRegistry.unregister(engineId: engineId)
        presentedExtraEngineId = nil
        presentedMovieId = nil
    }
}
