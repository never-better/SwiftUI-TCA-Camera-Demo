//
//  swiftUI_tca_camera_demoApp.swift
//  swiftUI-tca-camera-demo
//
//  Created by youtak on 2023/07/17.
//

import SwiftUI

import ComposableArchitecture

@main
struct swiftUI_tca_camera_demoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                store: Store(
                    initialState: ContentFeature.State(),
                    reducer: ContentFeature()
                )
            )
        }
    }
}
