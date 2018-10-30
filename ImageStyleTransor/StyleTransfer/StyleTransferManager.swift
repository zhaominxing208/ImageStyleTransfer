//
//  StyleTransferManager.swift
//  ImageStyleTransor
//
//  Created by zmx on 2018/10/18.
//  Copyright © 2018 ChenFeng. All rights reserved.
//

import Foundation
import UIKit
import CoreML

class StyleTransferManager{
    static let sharedInstance = StyleTransferManager()
    private init() {}
    static let size_720x720 = CGSize.init(width: 720, height: 720)
    static let size_480x640 = CGSize.init(width: 480, height: 640)
    
    static let inputImage = "inputImage"
    static let outputImage = "outputImage"

    var modelList: Array<STModel> = {
        
        var list =  Array<STModel>();
        list.append(STModel(model: STMuseMLModel().model, thumbnailName: "muse", size:size_480x640))
        list.append(STModel(model: STPrincessMLModel().model, thumbnailName: "princess",size:size_480x640))
        list.append(STModel(model: STShipwreckMLModel().model, thumbnailName: "shipwreck",size:size_480x640))
        list.append(STModel(model: STUdnieMLModel().model, thumbnailName: "udnie",size:size_480x640))
        list.append(STModel(model: STWaveMLModel().model, thumbnailName: "wave",size:size_480x640))
        list.append(STModel(model: STScreamMLModel().model, thumbnailName: "scream",size:size_480x640))
        
        list.append(STModel(model: STCandy().model, thumbnailName: "muse", size:size_720x720, inputName:inputImage, outputName:outputImage))
        list.append(STModel(model: STMosaic().model, thumbnailName: "muse", size:size_720x720, inputName:inputImage, outputName:outputImage))
        list.append(STModel(model: STUdnie().model, thumbnailName: "muse", size:size_720x720, inputName:inputImage, outputName:outputImage))
        list.append(STModel(model: STStarryNight().model, thumbnailName: "muse" , size:size_720x720, inputName:inputImage, outputName:outputImage))
        
        return list
    }()
    
}
