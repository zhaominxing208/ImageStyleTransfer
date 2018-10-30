//
//  StyleTransferInput.swift
//  StyleTransfer
//
//  Created by Oleg Poyaganov on 29/08/2017.
//  Copyright © 2017 Prisma Labs, Inc. All rights reserved.
//

import CoreML
import CoreVideo

class StyleTransferInput : MLFeatureProvider {
    
    /// input as color (kCVPixelFormatType_32BGRA) image buffer, 720 pixels wide by 720 pixels high
    var input: CVPixelBuffer
    var inputName: String

    var featureNames: Set<String> {
        get {
            return [self.inputName]
        }
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == self.inputName) {
            return MLFeatureValue(pixelBuffer: input)
        }
        return nil
    }
    
    init(input: CVPixelBuffer, inputName:String) {
        self.input = input
        self.inputName = inputName
    }
}
