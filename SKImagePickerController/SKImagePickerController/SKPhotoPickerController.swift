//
//  SKPhotoPickerController.swift
//  SKImagePickerController
//
//  Created by nachuan on 2017/3/15.
//  Copyright © 2017年 nachuan. All rights reserved.
//

import UIKit

extension SKPhotoPickerController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model: SKAssetModel = albumModel!.assetModels[indexPath.row]
        switch model.mediaType {
        case .image:
            let preview = SKPhotoPreviewController()
            self.navigationController?.pushViewController(preview, animated: true)
        default:
            return
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let model: SKAssetModel = albumModel!.assetModels[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SKPhotoPickerController.identifier, for: indexPath) as! SKAssetCell
        cell.setInfo(with: model)
        cell.selectedButtonClickedClosure = { (sender: UIButton) in
            if sender.isSelected == false {
                if SKImageManager.defaultManager.selectedAssetModels.count < SKImageManager.defaultManager.maxImageCount {
                    sender.isSelected = !sender.isSelected
                    cell.assetModel!.isSelected = sender.isSelected
                    SKImageManager.defaultManager.selectedAssetModels.append(cell.assetModel!)
                }else{
                    //MARK:提示框
                    self.showAlertController()
                }
            }else{
                guard SKImageManager.defaultManager.selectedAssetModels.count > 0 else {
                    return  ///👈 此处一般不会进来.数组为空时.没有选中的按钮
                }
                guard let index = SKImageManager.defaultManager.selectedAssetModels.index(of: cell.assetModel!) else { return }
                sender.isSelected = !sender.isSelected
                cell.assetModel!.isSelected = sender.isSelected
                SKImageManager.defaultManager.selectedAssetModels.remove(at: index)
            }
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let albumModel = albumModel else { return 0 } ///👈 解包.防止albumModel意外为空
        return albumModel.assetModels.count
    }
}

class SKPhotoPickerController: UIViewController {

    
    static let identifier: String = "cell"  ///👈 cell复用标识
    static let margin: CGFloat = 4   ///👈 cell的外部间隔
    var albumModel: SKAlbumModel?   ///👈 用于获取指定相册相片的相册模型, 没有意外情况不会为nil的
    var configuration: Configuration?   ///👈 配置信息
    var isFirstPushed: Bool!   ///👈 进入imagePickerController时首先被push出来的
    
    private var isShowTakePhotoButton: Bool = false   ///👈 是否显示拍照按钮
    ///👇 以下两行计算cell的宽度
    lazy var columnNumber: CGFloat = CGFloat(SKImageManager.defaultManager.columnNumber)
    lazy var cellWidth: CGFloat = (UIScreen.main.bounds.width - ((self.columnNumber + 1) * 5)) / self.columnNumber

    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.cellWidth, height: self.cellWidth)
        layout.minimumInteritemSpacing = margin
        layout.minimumLineSpacing = margin
        layout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin)
        return layout
    }()
    
    lazy var collectionView: SKCollectionView = {[unowned self] in
        let collectionView = SKCollectionView(frame: self.view.bounds, collectionViewLayout: self.layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceHorizontal = false
        collectionView.register(SKAssetCell.self, forCellWithReuseIdentifier: SKPhotoPickerController.identifier)
        return collectionView
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.title = albumModel?.name ?? Bundle.sk_localizedString(for: "Photos")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: configuration?.cancelButtonTitle, style: .plain, target: self, action: #selector(cancelButtonClicked))
        self.view.addSubview(self.collectionView)
        
        /// 首先被推出, 需要获取相机胶卷
        if isFirstPushed == true {
            SKImageManager.defaultManager.fetchCameraRollAlbum { (albumModel: SKAlbumModel) in
                self.albumModel = albumModel
                self.collectionView.reloadData()
                
                /// 加载所有的
                
                
            }
        }else{
            checkSelectedModels()
        }
        
        setupBottomToolbar()

    
    }
    
    /// 检测已经选中的资源
    func checkSelectedModels() -> Void {
        
    }
    
    /// 设置底部的工具条
    func setupBottomToolbar() -> Void {
        
    }
    
    /// 显示提示框(超过允许选中的最大张数时)
    func showAlertController() -> Void {
        let alertController = UIAlertController(title: nil, message: "你最多只能选择\(SKImageManager.defaultManager.maxImageCount)张图片", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "我知道了", style: .cancel) { (alertAction: UIAlertAction) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(alertAction)
        self.navigationController?.present(alertController, animated: true, completion: nil)
        
    }
    
    /// 取消按钮响应事件
    func cancelButtonClicked() -> Void {
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    deinit {
        print(("\(#file)" as NSString).lastPathComponent +   "--" + "\(#function)")
    }
}

class SKCollectionView: UICollectionView {

    open override func touchesShouldCancel(in view: UIView) -> Bool {
        if view.isKind(of: UIControl.self) {
            return true
        }
        return super.touchesShouldCancel(in: view)
    }

}




