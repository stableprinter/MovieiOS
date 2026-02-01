//
//  Constants.swift
//  MovieiOS
//
//  Application-wide constants. Must match Android: com.movie.android/channel, com.movie.android/events
//

import Foundation

enum Constants {
    enum Engine {
        static let browse = "browse_engine"
        static let favorite = "favorite_engine"
        static let extraPrefix = "extra_engine"
    }

    enum MethodChannel {
        static let name = "com.movie.android/channel"
    }

    enum EventChannel {
        static let name = "com.movie.android/events"
        static let shouldReloadFavorite = "shouldReloadFavorite"
    }

    enum Navigation {
        static let entryBrowse = "mainBrowse"
        static let entryFavorite = "mainFavorite"
        static let movieDetailRoutePrefix = "/movie:true:"
    }
}
