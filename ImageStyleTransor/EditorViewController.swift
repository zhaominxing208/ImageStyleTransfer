//
//  FirstViewController.swift
//  ImageStyleTransor
//
//  Created by zmx on 2018/10/17.
//  Copyright © 2018 ChenFeng. All rights reserved.
//

import UIKit
import SnapKit
import Accelerate
import ViewAnimator
import NVActivityIndicatorView


class EditorViewController: UIViewController{
    //Property
    let loading = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30), type:.ballGridBeat, color: UIColor.white, padding: 0)

    open var unStyliedImage : UIImage = UIImage.init(){
        didSet{
            self.editedImage = unStyliedImage.scaled(to: CGSize(width: 1000, height: 1000))
            self.view.layoutIfNeeded()
        }
    }
    
    var editedImage : UIImage = UIImage.init(){
        didSet {
            self.editor.image  = editedImage
            self.background.image = editedImage
            self.view.layoutIfNeeded()
        }
    }
    
    var isProcessing : Bool  = false {
        didSet {
            if self.isProcessing {
                self.loading.startAnimating()
            }else{
                self.loading.stopAnimating()
            }
            self.view.layoutIfNeeded()
        }
    }
    
    var background = UIImageView.init()
    let editor = UIImageView.init()
    
    //method
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setUpGaussianBlurBg()
        self.setUpEditor()
        self.setUpUICollectionView()
    }
    
    private func setUpUICollectionView(){
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = .init(width: 80, height: 80)
        
        let styleList = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: flowLayout)
        styleList.collectionViewLayout = flowLayout
        
        self.view.addSubview(styleList)

        styleList.snp.makeConstraints { (make) in
            make.width.equalTo(self.view)
            make.height.equalTo(flowLayout.itemSize)
            make.bottom.equalTo(self.view).offset(-29)
        }
        styleList.delegate = self
        styleList.dataSource = self
        styleList.register(StyleCollectionCell.self, forCellWithReuseIdentifier: "cell")
        styleList.backgroundColor = UIColor.clear
        styleList.showsHorizontalScrollIndicator = false

        // 练习动画使用
        styleList.performBatchUpdates({
            let zoomAnimation = AnimationType.zoom(scale: 0.2)
            let rotateAnimation = AnimationType.rotate(angle: CGFloat.pi/6)
            UIView.animate(views: styleList.visibleCells,
                           animations: [zoomAnimation, rotateAnimation],
                           duration: 0.5)
        }, completion: nil)
    }
    
    private func setUpGaussianBlurBg() {
        self.view.addSubview(background)
        
        //毛玻璃
        let blurEffect = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
        self.view.addSubview(blurView)
        
        //底图
        background.image = editedImage
        background.snp.makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.width.height.equalTo(self.view)
        }
    }

    private func setUpEditor() {
        self.view.addSubview(editor)
        editor.contentMode = .scaleAspectFit
        editor.image = editedImage
        editor.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(64 + 20)
            make.width.equalTo(self.view)
            make.height.equalTo(self.view).multipliedBy(0.65)
        }
        
        self.view.setNeedsLayout()
        
        editor.addSubview(loading)
        loading.snp.makeConstraints { (make) in
            make.center.equalTo(editor)
        }
    }
}

extension EditorViewController:  UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return StyleTransferManager.sharedInstance.modelList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : StyleCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! StyleCollectionCell
        let data : STModel = StyleTransferManager.sharedInstance.modelList[indexPath.item]
        cell.setBackgroundImage(backgroundImage: UIImage.init(named: data.thumbnailName)!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("select \(indexPath)")
        self.isProcessing = true

        DispatchQueue.global(qos: .userInteractive).async {
            let data : STModel = StyleTransferManager.sharedInstance.modelList[indexPath.item]
            let stylized = self.unStyliedImage.stylizeImage(stModel: data, width: Int(data.size.width), height: Int(data.size.height))
            DispatchQueue.main.async {
                self.isProcessing = false
                self.editedImage = UIImage(cgImage: stylized).resize(to: self.editedImage.size)
            }
        }
    }
}

class StyleCollectionCell: UICollectionViewCell {
    var imageView : UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.imageView = UIImageView.init(frame: self.bounds)
        self.contentView.addSubview(self.imageView)
    }
    
    func setBackgroundImage(backgroundImage : UIImage) {
        self.imageView.image = backgroundImage
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
