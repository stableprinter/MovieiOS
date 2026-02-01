//
//  MethodChannelHandler.swift
//  MovieiOS
//
//  Handles method calls from Flutter (Browse, Favorite, and Extra engines).
//  Channel name must match Android: com.movie.android/channel
//

import Flutter
import UIKit

final class MethodChannelHandler: NSObject {
    private let engineId: String
    private let onNavigateToMovieDetail: ((Int) -> Void)?

    init(engineId: String, onNavigateToMovieDetail: ((Int) -> Void)? = nil) {
        self.engineId = engineId
        self.onNavigateToMovieDetail = onNavigateToMovieDetail
    }

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getEngineId":
            result(engineId)
        case "getPlatformVersion":
            result(UIDevice.current.systemVersion)
        case "navigateToMovieDetail":
            if engineId == Constants.Engine.favorite {
                let movieId = parseMovieId(from: call.arguments)
                guard let movieId else {
                    result(FlutterError(code: "INVALID_ARG", message: "movieId must be an Int", details: nil))
                    return
                }
                if let callback = onNavigateToMovieDetail {
                    DispatchQueue.main.async { callback(movieId) }
                }
                result(nil)
            } else {
                result(FlutterMethodNotImplemented)
            }
        case "broadcastFavList":
            if engineId == Constants.Engine.favorite {
                let movieIds = parseMovieIds(from: call.arguments)
                EventChannelRegistry.send(engineId: Constants.Engine.browse, method: "broadcastFavList", param: movieIds)
                result(nil)
            } else {
                result(FlutterMethodNotImplemented)
            }
        case "onToggleFavorite":
            if engineId == Constants.Engine.browse || engineId.hasPrefix(Constants.Engine.extraPrefix) {
                let movieId = parseMovieId(from: call.arguments)
                guard let movieId else {
                    result(FlutterError(code: "INVALID_ARG", message: "movieId must be an Int", details: nil))
                    return
                }
                EventChannelRegistry.send(engineId: Constants.Engine.favorite, method: Constants.EventChannel.shouldReloadFavorite, param: movieId)
                result(nil)
            } else {
                result(FlutterMethodNotImplemented)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func parseMovieId(from arguments: Any?) -> Int? {
        if let int = arguments as? Int { return int }
        if let num = arguments as? NSNumber { return num.intValue }
        return nil
    }

    private func parseMovieIds(from arguments: Any?) -> [Int] {
        guard let list = arguments as? [Any] else { return [] }
        return list.compactMap { item in
            if let int = item as? Int { return int }
            if let num = item as? NSNumber { return num.intValue }
            return nil
        }
    }

    static func register(
        messenger: FlutterBinaryMessenger,
        engineId: String,
        onNavigateToMovieDetail: ((Int) -> Void)? = nil
    ) {
        let handler = MethodChannelHandler(engineId: engineId, onNavigateToMovieDetail: onNavigateToMovieDetail)
        FlutterMethodChannel(name: Constants.MethodChannel.name, binaryMessenger: messenger)
            .setMethodCallHandler(handler.handle)
    }
}
