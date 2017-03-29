//
//  SKAssetModel.swift
//  SKImagePickerController
//
//  Created by nachuan on 2017/3/16.
//  Copyright © 2017年 nachuan. All rights reserved.
//

import UIKit
import Photos
class SKAssetModel: NSObject {

    var asset: PHAsset? ///👈 相片的原始类
    var isSelected: Bool = false    ///👈 标识该图片是否被选中
    var mediaType: PHAssetMediaType = .unknown  ///👈 资源类型(图片, 视频...)
    var image: UIImage? ///👈 相片
    var requestID: PHImageRequestID?    ///👈 相册的请求ID
    var isHiddenSelectedButton = false  ///👈 是否隐藏选择按钮
    
//    var timeLength: String?
    
    ///👇 创建SKAssetModel模型
    ///
    /// - parameter asset: 指定相片
    ///
    /// - returns: SKAssetModel模型
    class public func model(with asset: PHAsset) -> SKAssetModel {
        let model = SKAssetModel()
        model.asset = asset
        model.mediaType = asset.mediaType
        switch model.mediaType {
        case .video:
            model.isHiddenSelectedButton = true
        case .image:
            model.isHiddenSelectedButton = false
        default:
            model.isHiddenSelectedButton = false
        }
        model.requestID = SKImageManager.defaultManager.requestImage(from: model, photoWidth: SKImageManager.defaultManager.photoWidth) { (image: UIImage?, info: [AnyHashable : Any]?) in
            model.image = image
        }
        return model
    }
    
}
