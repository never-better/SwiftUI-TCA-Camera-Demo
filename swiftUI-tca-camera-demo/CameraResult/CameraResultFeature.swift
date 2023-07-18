//
//  CameraResultFeature.swift
//  swiftUI-tca-camera-demo
//
//  Created by youtak on 2023/07/17.
//

import SwiftUI

import ComposableArchitecture

struct CameraResultFeature: ReducerProtocol {
    
    struct State: Equatable {
        var resultImage: Image
    }
    
    enum Action: Equatable {
        case cancelButtonTapped
        case saveButtonTapped
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case savePhotos(Image)
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .cancelButtonTapped:
            return .run { _ in await self.dismiss() }
            
        case .saveButtonTapped:
            return .run { [resultImage = state.resultImage ] send in
                await send(.delegate(.savePhotos(resultImage)))
                await self.dismiss()
            }
            
        case .delegate:
            return .none
        }
    }
}
