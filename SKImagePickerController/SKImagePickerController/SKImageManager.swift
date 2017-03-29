//
//  SKImageManager.swift
//  SKImagePickerController
//
//  Created by nachuan on 2017/3/15.
//  Copyright © 2017年 nachuan. All rights reserved.
//
//  相册管理类.处理相册相关的业务

import UIKit
import Photos


/// 拉取相册后回调, 成功回调, 并返回相册数组
typealias fetchAlbumCompletionClosure = (_: [SKAlbumModel]) -> Void

/// 拉取相片后回调, 成功回调, 并返回相册数组
typealias fetchAssetCompletionClosure = (_: [SKAssetModel]) -> Void

/// 拉取资源后回调, 只返回布尔值, 不传递数组
typealias fetchCompletionClosure = (_: Bool) -> Void

typealias requestImageCompletionClosure = (_ image: UIImage?, _ info: [AnyHashable : Any]?) -> Void
/// 自定义裁剪框属性
typealias cropViewClosure = (_ corpView: UIView) -> Void

class SKImageManager: NSObject {

    var maxImageCount: Int = 9  ///👈 可选中最大的相片数量, 默认9张, 也是可设置的最大值
    
    var columnNumber: Int = 4   ///👈 相片展示时的列数, 最好设为4
    
    var sortAscendingByModificationDate: Bool = true    ///👈 获取时是否按修改日期升序排列
    
    var isShouldFixOrientation: Bool = false    ///👈 是否处理图片方向, 默认是false, 不进行修正

    var photoWidth: CGFloat = 828   ///👈 图片宽度
    
    var photoPreviewMaxWidth: CGFloat = 600 ///👈 预览图最大尺寸, 默认600像素宽, 即300点
    
    var timeout: TimeInterval = 15  ///👈 拉取图片超时时间, 默认15秒, 当超过15秒自动dismiss HUD
    
    var allowPickingOriginalPhoto: Bool = true  ///👈 默认为true, 如果设置为false, 原图按钮将隐藏, 用户不能选择发送原图
    
    var allowPickingVideo: Bool = true  ///👈 默认为true, 如果设置为false, 用户将不能选择视频
    
    var allowPickingGif: Bool = false   ///👈 默认为false, 如果设置为true, 用户可以选择gif图片
    
    var allowPickingImage: Bool = true  ///👈 默认为true, 如果设置为false, 用户将不能选择发送图片
    
    var allowTakePickture: Bool = true  ///👈 默认为true, 如果设置为false, 拍照按钮将隐藏, 用户将不能选择照片
    
    var allowPreview: Bool = true   ///👈 默认为true, 如果设置为false, 预览按钮将隐藏, 用户将不能去预览照片
    
    var autoDismiss: Bool = true    ///👈 默认为true, 如果设置为false, 选择器将不会自己dismiss
    
    var isHiddenAlbumWhenNotHaveAsset: Bool = false ///👈 当相册无资源时是否将其隐藏, 默认false, 不隐藏

    var hideWhenCanNotSelect: Bool = false  ///👈 隐藏不可以选中的图片, 默认是false, 不推荐将其设置为true
    
    var minPhotoWidthSelectable: Int = 0    ///👈 最小可选中的图片宽度, 默认是0, 小于这个宽度的图片不可选中
    
    var minPhotoHeightSelectable: Int = 0   ///👈 最小可选中的图片高度, 默认是0, 小于这个高度的图片不可选中
    
    ///👇 单选模式, maxImageCount为1时才生效
    var showSelectButton: Bool = false  ///👈 在单选模式下, 照片列表页中, 显示选择按钮, 默认为false
    
    var allowCrop: Bool = true  ///👈 允许裁剪,默认为true，showSelectBtn为false才生效
    
    var needCircleCrop: Bool = false    ///👈 需要圆形裁剪框
    
    var cropRect: CGRect = .zero    ///👈 裁剪框的尺寸
    
    var circleCropRadius: CGFloat = 0   ///👈 裁剪框半径大小
    
    var cropViewSettingClosure: cropViewClosure?    ///👈 自定义裁剪框的其他属性

    lazy var albumModels = [SKAlbumModel]() ///👈 相册模型数组
    
    lazy var assetModels = [SKAssetModel]() ///👈 资源模型数组(所有的资源, 相机胶卷)
    
    lazy var selectedAssetModels = [SKAssetModel]() ///👈 已选择的资源的模型数组
    
    
    
    /// 单例.私有化初始化方法
    static let defaultManager = SKImageManager()
    private override init() {}
    
    ///👇 判断是否已经授权
    func authorizationStatusAuthorized() -> Bool {
        let status: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        if status == .notDetermined {
            DispatchQueue.global().async {
                PHPhotoLibrary.requestAuthorization({ (status) in
                    DispatchQueue.main.async {}
                })
            }
        }
        return status == .authorized
    }
    
    
    ///👇 拉取所有的相册
    ///
    /// - parameter completion: 成功拉取时回调
    func fetchAllAlbums(completion: fetchCompletionClosure?) -> Void {
        
        let options = PHFetchOptions()
        if !allowPickingVideo {
            options.predicate = NSPredicate(format: "mediaType == %ld", PHAssetMediaType.image as! CVarArg)
        }
        if !allowPickingImage {
            options.predicate = NSPredicate(format: "mediaType == %ld", PHAssetMediaType.video as! CVarArg)
        }
        if !sortAscendingByModificationDate {
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: sortAscendingByModificationDate)]
        }
        
        let myPhotoStreamAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumMyPhotoStream, options: nil)
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        let topLevelUserCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        let syncedAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumSyncedAlbum, options: nil)
        let sharedAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumCloudShared, options: nil)
        ///👇 将所有相册存储在数组中
        let resultArray: [PHFetchResult<AnyObject>] = [myPhotoStreamAlbums  as! PHFetchResult<AnyObject>,
                                                       smartAlbums  as! PHFetchResult<AnyObject>,
                                                       syncedAlbums as! PHFetchResult<AnyObject>,
                                                       sharedAlbums as! PHFetchResult<AnyObject>,
                                                       topLevelUserCollections as! PHFetchResult<AnyObject>]
        
        albumModels.removeAll() ///👈 清空原有的内容, 防止重复添加
        ///👇 手机相册
        for result: PHFetchResult in resultArray {
            result.enumerateObjects({ (collection, index, pointer) in
                ///👇 过滤掉不是PHAssetCollection类的数据
                guard collection.isKind(of: PHAssetCollection.self) else {
                    return
                }
                let fetchResult: PHFetchResult = PHAsset.fetchAssets(in: collection as! PHAssetCollection, options: options)
                if fetchResult.count > 0 || self.isHiddenAlbumWhenNotHaveAsset == false {
                    ///👇 去掉"最近删除"的相册和照片
                    if collection.localizedTitle?.range(of: "Delete") == nil
                        && collection.localizedTitle != "最近删除"
                         {
                        
                        let albumModel = SKAlbumModel.model(with: fetchResult as! PHFetchResult<AnyObject> , name: collection.localizedTitle)
                        if SKImageManager.defaultManager.isCameraRollAlbum(with: albumModel.name) {
                            self.albumModels.insert(albumModel, at: 0)
                        }else{
                            self.albumModels.append(albumModel)
                        }
                    }
                }
            })
        }
        guard completion != nil && self.albumModels.count > 0 else { return }
        completion!(true)
    }
    
    ///👇 拉取所有相册
    ///
    /// - parameter completion: 成功拉取时回调
    func fetchAllAlbumsWithAlbumModels(completion: fetchAlbumCompletionClosure?) -> Void {
        
        fetchAllAlbums { (isFinish: Bool) in
            guard completion != nil && self.albumModels.count > 0 else { return }
            completion!(self.albumModels)
        }
    }
       
    ///👇 获取相机胶卷相册
    ///
    /// - parameter completion: 回调
    func fetchCameraRollAlbum(completion: ((_ model: SKAlbumModel)->Void)?) -> Void {
        
        let options = PHFetchOptions()
        if !allowPickingVideo {
            options.predicate = NSPredicate(format: "mediaType == %ld", PHAssetMediaType.image as! CVarArg)
        }
        if !allowPickingImage {
            options.predicate = NSPredicate(format: "mediaType == %ld", PHAssetMediaType.video as! CVarArg)
        }
        if !sortAscendingByModificationDate {
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: sortAscendingByModificationDate)]
        }
        
        let smartAlbums: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        
        smartAlbums.enumerateObjects({ (collection: PHAssetCollection, index: Int, pointer: UnsafeMutablePointer<ObjCBool>) in
            ///👇 过滤掉不是PHAssetCollection类的数据
            guard collection.isKind(of: PHAssetCollection.self) else {
                return
            }
            if self.isCameraRollAlbum(with: collection.localizedTitle) {
                let fetchResult: PHFetchResult<PHAsset> = PHAsset.fetchAssets(in: collection, options: options)
                let albumModel: SKAlbumModel = SKAlbumModel.model(with: fetchResult as! PHFetchResult<AnyObject>, name: collection.localizedTitle)
                SKImageManager.defaultManager.assetModels.removeAll()   ///👈 清空数组, 防止重复加载
                DispatchQueue.global().async {
                    SKImageManager.defaultManager.fetchAssets(from: albumModel, completion: { (assetModels: [SKAssetModel]) in
                        SKImageManager.defaultManager.assetModels.append(contentsOf: assetModels)
                    })
                    guard let completion = completion else {
                        return
                    }
                    albumModel.assetModels = SKImageManager.defaultManager.assetModels
                    completion(albumModel)
                }
            }
        })
    }
    
    ///👇 为所有的albumModel获取对应的assetModels
    ///
    /// - parameter completion: 完成后回调
    func fetchAssetsForAllAlbums(_ completion: () -> Void) -> Void {
        for albumModel in SKImageManager.defaultManager.albumModels {
            SKImageManager.defaultManager.fetchAssets(from: albumModel, completion: { (assetModels: [SKAssetModel]) in
                albumModel.assetModels = assetModels
                //取消菊花
            })
        }
        completion()
    }
    
    ///👇 同步拉取指定相册里的相片
    ///
    /// - parameter fetchResult: 指定相册模型
    /// - parameter completion:  拉取完成回调
    func fetchAssets(from albumModel: SKAlbumModel, completion: fetchAssetCompletionClosure?) -> Void {
        guard let result = albumModel.result else { return }
        
        var assetModels: [SKAssetModel]
        if self.assetModels.count > 0 {
            if SKImageManager.defaultManager.isCameraRollAlbum(with: albumModel.name) {
                assetModels = self.assetModels
            }else{
                assetModels = [SKAssetModel]()
                result.enumerateObjects( { (obj: AnyObject, index: Int, pointer: UnsafeMutablePointer<ObjCBool>) in
                    guard obj is PHAsset else {
                        return
                    }
                    var assetModelTemp: SKAssetModel?
                    for assetModel: SKAssetModel in self.assetModels {
                        if assetModel.asset?.localIdentifier == (obj as! PHAsset).localIdentifier {
                            assetModelTemp = assetModel
                        }
                    }
                    if assetModelTemp == nil {
                        assetModelTemp = SKAssetModel.model(with: obj as! PHAsset)
                    }
                    assetModels.append(assetModelTemp!)
                })
            }
        }else{
            assetModels = [SKAssetModel]()
            result.enumerateObjects( { (obj: AnyObject, index: Int, pointer: UnsafeMutablePointer<ObjCBool>) in
                guard obj is PHAsset else {
                    return
                }
                let model: SKAssetModel = SKAssetModel.model(with: obj as! PHAsset)
                assetModels.append(model)
            })
        }
        guard let completion = completion else { return }
        completion(assetModels)
    }
    
    ///👇 获取资源对应图片
    ///
    /// - parameter assetModel: 资源模型
    /// - parameter photoWidth: 相片宽度
    /// - parameter completion: 完成回调
    ///
    /// - returns: 图片请求ID
    func requestImage(from assetModel: SKAssetModel, photoWidth: CGFloat, completion: @escaping requestImageCompletionClosure) -> PHImageRequestID {
        guard let asset: PHAsset = assetModel.asset else { return 0 }
        let options = PHImageRequestOptions()
        options.resizeMode = .fast
        let aspectRatio: CGFloat = CGFloat(asset.pixelWidth) / CGFloat(asset.pixelHeight)
        let pixelWidth: CGFloat = photoWidth * UIScreen.main.scale
        let pixelHeight: CGFloat = pixelWidth / aspectRatio
        let targetSize: CGSize = CGSize(width: pixelWidth, height: pixelHeight)
        return PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options, resultHandler: completion)
        
    }
    
    ///👇 判断该相册是不是相机胶卷, 是否包含所有照片
    ///
    /// - parameter albumName: 相册名字
    func isCameraRollAlbum(with albumName: String?) -> Bool {
        guard let albumName = albumName else { return false }
        var version: String = UIDevice.current.systemVersion.replacingOccurrences(of: ".", with: "")
        if version.characters.count <= 1 {
            version.append("00")
        } else if version.characters.count <= 2{
            version.append("0")
        }
        if version >= "800" && version <= "802" {
            return albumName == "Recently Added" || albumName == "最近添加"
        } else {
            return albumName == "Camera Roll" || albumName == "相机胶卷" || albumName == "All Photos" || albumName == "所有照片"
        }   
    }
    
    
    
    deinit {
        print(("\(#file)" as NSString).lastPathComponent +   "--" + "\(#function)")
    }
    
    
}
