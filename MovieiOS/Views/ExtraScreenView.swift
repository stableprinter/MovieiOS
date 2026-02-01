//
//  ExtraScreenView.swift
//  MovieiOS
//
//  Full-screen Flutter view (movie detail). No tab bar. Back button returns to Favorite.
//

import Flutter
import SwiftUI

struct ExtraScreenView: View {
    let engine: FlutterEngine
    let onDismiss: () -> Void

    var body: some View {
        FlutterViewControllerRepresentable(engine: engine)
            .ignoresSafeArea()
    }
}
