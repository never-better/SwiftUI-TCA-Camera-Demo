//
//  CameraFeature.swift
//  swiftUI-tca-camera-demo
//
//  Created by youtak on 2023/07/17.
//

import Combine
import SwiftUI

import ComposableArchitecture

struct CameraFeature: ReducerProtocol {
    
    struct State: Equatable {
        @PresentationState var cameraResult: CameraResultFeature.State?
        var viewFinderImage: Image?
        var disableDismissAnimation: Bool = true
        
        var isFlipped: Bool = false
        var flipDegree: Double = 0.0
        var flipImage: Image?
    }
    
    enum Action: Equatable {
        case viewWillAppear
        
        case viewFinderUpdate(Image?)
        case flipImageRemove
        case moveToCameraResult(Image)
        
        case shutterTapped
        case switchButtonTapped
        case cancelButtonTapped
        
        case flipDegreeUpdate
        
        case cameraResult(PresentationAction<CameraResultFeature.Action>)
        case delegate(Delegate)
        
        enum Delegate:Equatable {
            case savePhoto(Image)
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.cameraService) var cameraService
    
    var body: some ReducerProtocolOf<Self> {
        Reduce { state, action in
            
            switch action {
            
            // MARK: View Life Cycle
                
            case .viewWillAppear:
                
                return .run { send in
                    await cameraService.start()
                    
                    let imageStream = cameraService.previewStream()
                        .map { $0.image }
                    
                    for await image in imageStream {
                        Task { @MainActor in
                            send(.viewFinderUpdate(image))
                        }
                    }
                }
                
            // MARK: - Image
            
            case let .viewFinderUpdate(image):
                state.viewFinderImage = image
                return .none
                
            case .flipImageRemove:
                state.flipImage = nil
                return .none
            
            case let .moveToCameraResult(image):
                state.cameraResult = CameraResultFeature.State(resultImage: image)
                return .none
                
            // MARK: - Button Tapped
                
            case .shutterTapped:
                return .run { send in
                    let resultImage = await cameraService.takePhoto()
                    await send(.moveToCameraResult(resultImage))
                }
                
            case .switchButtonTapped:
                state.flipImage = state.viewFinderImage
                state.viewFinderImage = nil
                
                return .run { send in
                    await cameraService.switchCaptureDevice()
                    await send(.flipImageRemove)
                }

            case .cancelButtonTapped:
                cameraService.stop()
                return .run { _ in await self.dismiss() }
            
            case .flipDegreeUpdate:
                state.flipDegree += 180
                return .none
                
            // MARK: - Delegate
                
            case .delegate:
                return .none
                
            case let .cameraResult(.presented(.delegate(.savePhotos(image)))):
                return .run { send in
                    await send(.delegate(.savePhoto(image)))
                    await self.dismiss()
                }
                
            case .cameraResult:
                return .none
            }
        }
        .ifLet(\.$cameraResult, action: /Action.cameraResult) {
            CameraResultFeature()
        }
    
    }
}
