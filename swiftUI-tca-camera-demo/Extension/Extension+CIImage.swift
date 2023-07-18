//
//  Extension+CIImage.swift
//  swiftUI-tca-camera-demo
//
//  Created by youtak on 2023/07/17.
//

import SwiftUI

extension CIImage {
    var image: Image? {
        let ciContext = CIContext()
        guard let cgImage = ciContext.createCGImage(self, from: self.extent) else { return nil }
        return Image(decorative: cgImage, scale: 1, orientation: .up)
    }
}
