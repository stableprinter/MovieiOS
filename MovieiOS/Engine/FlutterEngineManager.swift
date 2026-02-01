//
//  FlutterEngineManager.swift
//  MovieiOS
//
//  Manages Flutter engine lifecycle: initialization, creation, and caching.
//  Uses FlutterEngineGroup for multiple engines with shared resources.
//

import Flutter
import UIKit

final class FlutterEngineManager {
    private var engineGroup: FlutterEngineGroup!
    private var cachedEngines: [String: FlutterEngine] = [:]
    private let lock = NSLock()

    var browseEngine: FlutterEngine {
        lock.lock()
        defer { lock.unlock() }
        return cachedEngines[Constants.Engine.browse]!
    }

    var favoriteEngine: FlutterEngine {
        lock.lock()
        defer { lock.unlock() }
        return cachedEngines[Constants.Engine.favorite]!
    }

    func engine(for id: String) -> FlutterEngine? {
        lock.lock()
        defer { lock.unlock() }
        return cachedEngines[id]
    }

    /// Initializes Flutter and creates both Browse and Favorite engines.
    /// Must be called before using engines.
    func initialize(apiToken: String, userId: String) {
        engineGroup = FlutterEngineGroup(name: "movie_group", project: nil)

        let browseEngine = createEngine(
            entrypoint: Constants.Navigation.entryBrowse,
            initRoute: "/",
            args: [apiToken, userId]
        )
        let favoriteEngine = createEngine(
            entrypoint: Constants.Navigation.entryFavorite,
            initRoute: "/",
            args: [apiToken, userId]
        )

        lock.lock()
        cachedEngines[Constants.Engine.browse] = browseEngine
        cachedEngines[Constants.Engine.favorite] = favoriteEngine
        lock.unlock()
    }

    /// Creates and caches an engine for Extra (movie detail) screen.
    /// Engine is displayed based on initRoute (e.g. /movie:true:123).
    /// Must use unique engineId per navigation to avoid race conditions.
    func createExtraEngine(
        engineId: String,
        entrypoint: String,
        initRoute: String,
        args: [String]
    ) -> FlutterEngine {
        let engine = createEngine(entrypoint: entrypoint, initRoute: initRoute, args: args)
        lock.lock()
        cachedEngines[engineId] = engine
        lock.unlock()
        return engine
    }

    /// Removes engine from cache. Call when Extra screen is dismissed.
    func removeEngine(_ engineId: String) {
        lock.lock()
        let engine = cachedEngines.removeValue(forKey: engineId)
        lock.unlock()
        engine?.destroyContext()
    }

    private func createEngine(
        entrypoint: String,
        initRoute: String,
        args: [String]
    ) -> FlutterEngine {
        let options = FlutterEngineGroupOptions()
        options.entrypoint = entrypoint
        options.initialRoute = initRoute
        options.entrypointArgs = args

        return engineGroup.makeEngine(with: options)
    }
}
