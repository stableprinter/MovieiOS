//
//  FlutterViewControllerRepresentable.swift
//  MovieiOS
//
//  SwiftUI wrapper for FlutterViewController. Hosts a full-screen Flutter view.
//

import Flutter
import SwiftUI
import UIKit

struct FlutterViewControllerRepresentable: UIViewControllerRepresentable {
    let engine: FlutterEngine

    func makeUIViewController(context: Context) -> FlutterViewController {
        FlutterViewController(engine: engine, nibName: nil, bundle: nil)
    }

    func updateUIViewController(_ uiViewController: FlutterViewController, context: Context) {}
}
