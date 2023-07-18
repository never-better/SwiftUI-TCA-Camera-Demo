//
//  ContentView.swift
//  swiftUI-tca-camera-demo
//
//  Created by youtak on 2023/07/17.
//

import SwiftUI

import ComposableArchitecture

struct ContentView: View {
    
    let store: StoreOf<ContentFeature>
    
    var body: some View {
        
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            
            GeometryReader { geometry in
                
                NavigationStack {
                    
                    
                    ZStack {
                        
                        if let image = viewStore.image {
                            image
                                .resizable()
                                .scaledToFit()
                        }
                        
                    }
                    .frame(width: geometry.size.width, height: geometry.size.width * CameraSetting.ratio)
                    .background(Color.gray)
                    
                    Button {
                        viewStore.send(.cameraButtonTapped)
                    } label: {
                        Text("Using Camera")
                            .font(.title)
                            .padding()
                            .buttonStyle(.borderedProminent)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .fullScreenCover(store: self.store.scope(
                state: \.$usingCamera,
                action: { .usingCamera($0)})
            ) { cameraStore in
                NavigationStack {
                    CameraView(store: cameraStore)
                }
            }
            .transaction { transaction in
                transaction.disablesAnimations = viewStore.disableDismissAnimation
            }
            
        }
        
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            store: Store(
                initialState: ContentFeature.State(
                    image: Image(systemName: "person.3")
                ),
                reducer: ContentFeature()
            )
        )
    }
}
