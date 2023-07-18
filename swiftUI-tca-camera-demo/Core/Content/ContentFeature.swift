//
//  ContentFeature.swift
//  swiftUI-tca-camera-demo
//
//  Created by youtak on 2023/07/17.
//

import SwiftUI

import ComposableArchitecture

struct ContentFeature: ReducerProtocol {
    
    struct State: Equatable {
        @PresentationState var usingCamera: CameraFeature.State?
        var image: Image?
        var disableDismissAnimation: Bool = false
    }
    
    enum Action: Equatable {
        case cameraButtonTapped
        case usingCamera(PresentationAction<CameraFeature.Action>)
    }

    var body: some ReducerProtocolOf<Self> {
        Reduce { state, action in
            switch action {
            case .cameraButtonTapped:
                state.disableDismissAnimation = false
                state.usingCamera = CameraFeature.State()
                
                return .none
                
            case let .usingCamera(.presented(.delegate(.savePhoto(image)))):
                state.disableDismissAnimation = true
                state.image = image
                return .none
                
            case .usingCamera:
                return .none
            }
        }
        .ifLet(\.$usingCamera, action: /Action.usingCamera) {
            CameraFeature()
        }


    }
    
}
