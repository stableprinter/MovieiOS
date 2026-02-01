//
//  EventChannelRegistry.swift
//  MovieiOS
//
//  Registers EventChannel with every Flutter engine. Use send() to push events from native to Flutter.
//  Channel name must match Android: com.movie.android/events
//

import Flutter
import Foundation

final class EventChannelRegistry {
    private static var sinks: [String: FlutterEventSink] = [:]
    private static let lock = NSLock()

    static func register(engine: FlutterEngine, engineId: String) {
        let channel = FlutterEventChannel(name: Constants.EventChannel.name, binaryMessenger: engine.binaryMessenger)
        channel.setStreamHandler(EventStreamHandler(engineId: engineId))
    }

    static func send(engineId: String, method: String, param: Any? = nil) {
        lock.lock()
        defer { lock.unlock() }
        var payload: [String: Any] = ["method": method]
        if let param {
            payload["param"] = param
        } else {
            payload["param"] = NSNull()
        }
        sinks[engineId]?(payload)
    }

    static func unregister(engineId: String) {
        lock.lock()
        defer { lock.unlock() }
        sinks.removeValue(forKey: engineId)
    }

    static func setSink(_ sink: @escaping FlutterEventSink, for engineId: String) {
        lock.lock()
        defer { lock.unlock() }
        sinks[engineId] = sink
    }

    static func removeSink(for engineId: String) {
        lock.lock()
        defer { lock.unlock() }
        sinks.removeValue(forKey: engineId)
    }
}

private final class EventStreamHandler: NSObject, FlutterStreamHandler {
    private let engineId: String

    init(engineId: String) {
        self.engineId = engineId
    }

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        EventChannelRegistry.setSink(events, for: engineId)
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        EventChannelRegistry.removeSink(for: engineId)
        return nil
    }
}
