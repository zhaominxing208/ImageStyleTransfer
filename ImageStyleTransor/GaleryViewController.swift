//
//  GaleryViewController.swift
//  ImageStyleTransor
//
//  Created by zmx on 2018/10/19.
//  Copyright © 2018 ChenFeng. All rights reserved.
//

import UIKit
import Gallery

class GaleryViewController: GalleryController, GalleryControllerDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //异步预加载CoreML Model，提高编辑页打开速度
        DispatchQueue.global().async {
            _ = StyleTransferManager.sharedInstance.modelList
        }
    }
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        images.first?.resolve(completion: { (uiImage) in
            DispatchQueue.main.async {
                let editor = EditorViewController()
                editor.unStyliedImage = uiImage!
                self.present(editor, animated: true) {
                    
                }
            }
        })
   
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
    }

}
