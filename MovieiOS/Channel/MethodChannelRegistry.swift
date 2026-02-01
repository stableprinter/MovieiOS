//
//  MethodChannelRegistry.swift
//  MovieiOS
//
//  Registers MethodChannel with each Flutter engine for native communication.
//

import Flutter

enum MethodChannelRegistry {
    static func register(
        engine: FlutterEngine,
        engineId: String,
        onNavigateToMovieDetail: ((Int) -> Void)? = nil
    ) {
        MethodChannelHandler.register(
            messenger: engine.binaryMessenger,
            engineId: engineId,
            onNavigateToMovieDetail: onNavigateToMovieDetail
        )
    }

    static func registerAll(
        browseEngine: FlutterEngine,
        favoriteEngine: FlutterEngine,
        onNavigateToMovieDetail: @escaping (Int) -> Void
    ) {
        register(engine: browseEngine, engineId: Constants.Engine.browse)
        register(engine: favoriteEngine, engineId: Constants.Engine.favorite, onNavigateToMovieDetail: onNavigateToMovieDetail)
    }
}
