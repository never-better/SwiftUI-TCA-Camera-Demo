//
//  Extension+ViewStore.swift
//  swiftUI-tca-camera-demo
//
//  Created by youtak on 2023/07/18.
//

import SwiftUI

import ComposableArchitecture

extension ViewStore {
    func send(_ action: ViewAction, animation: Animation) {
      withAnimation(animation) {
          _ = self.send(action)
      }
    }
}


