//
//  STModel.swift
//  ImageStyleTransor
//
//  Created by zmx on 2018/10/22.
//  Copyright © 2018 ChenFeng. All rights reserved.
//

import Foundation
import UIKit
import CoreML

class STModel{
    var model : MLModel
    var thumbnailName : String
    var size : CGSize
    var inPutFeatureName : String
    var outPutFeatureName : String

    init(model: MLModel, thumbnailName: String) {
        self.model = model
        self.thumbnailName = thumbnailName
        self.size = CGSize.zero
        self.inPutFeatureName = "input1"
        self.outPutFeatureName = "output1"
    }
    
    init(model: MLModel, thumbnailName: String, size: CGSize) {
        self.model = model
        self.thumbnailName = thumbnailName
        self.size = size
        self.inPutFeatureName = "input1"
        self.outPutFeatureName = "output1"
    }
    
    init(model: MLModel, thumbnailName: String, size: CGSize, inputName:String, outputName:String) {
        self.model = model
        self.thumbnailName = thumbnailName
        self.size = size
        self.inPutFeatureName = inputName
        self.outPutFeatureName = outputName
    }
}
