//
//  CameraResultView.swift
//  swiftUI-tca-camera-demo
//
//  Created by youtak on 2023/07/17.
//

import SwiftUI

import ComposableArchitecture

struct CameraResultView: View {
    
    typealias CameraResultViewStore = ViewStore<CameraResultFeature.State, CameraResultFeature.Action>
    
    let store: StoreOf<CameraResultFeature>
    
    var body: some View {
        
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            
            GeometryReader { geometry in
                
                VStack {
                    
                    Spacer()
                    Spacer()
                    
                    viewStore.resultImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width, height: geometry.size.width * CameraSetting.ratio)
                        .background(Color.gray)
                    
                    Spacer()
                    
                    buttonsView(viewStore: viewStore)
                    
                    Spacer()
                }
                .background(Color.black)
                
            }
        }
    }
    
    private func buttonsView(viewStore: CameraResultViewStore) -> some View {
        HStack {
            
            Button {
                viewStore.send(.cancelButtonTapped)
            } label: {
                Spacer()
                
                Text("Cancel")
                    .font(.largeTitle)
                    .padding()
                
                Spacer()
            }
            .tint(.red)
            .buttonStyle(.borderedProminent)
            
            
            Button {
                viewStore.send(.saveButtonTapped)
            } label: {
                
                Spacer()
                
                Text("Save")
                    .font(.largeTitle)
                    .padding()
                
                Spacer()
            }
            .buttonStyle(.borderedProminent)
            
        }
    }
}

struct CameraResultView_Previews: PreviewProvider {
    static var previews: some View {
        CameraResultView(
            store: Store(
                initialState: CameraResultFeature.State(resultImage: Image(systemName: "camera")),
                reducer: CameraResultFeature())
        )
    }
}
