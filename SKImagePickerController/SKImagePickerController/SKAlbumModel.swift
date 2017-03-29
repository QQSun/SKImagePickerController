//
//  SKAlbumModel.swift
//  SKImagePickerController
//
//  Created by nachuan on 2017/3/15.
//  Copyright © 2017年 nachuan. All rights reserved.
//

import UIKit
import Photos
class SKAlbumModel: NSObject {

    var result: PHFetchResult<AnyObject>?  ///👈 相册原始模型
    var title: NSMutableAttributedString?   ///👈 相册标题
    var image: UIImage? ///👈 相册封面图
    lazy var assetModels = [SKAssetModel]() ///👈 存放该相册的资源数组
    ///👇 相册名字
    var name: String? {
        willSet {
            if let newValue = newValue {
                title = getMutableAttributedString(title: newValue, subTitle: "\(count)")
            }
        }
    }
    ///👇 相册图片数量
    var count: Int = 0 {
        willSet {
            if let name = name {
                title = getMutableAttributedString(title: name, subTitle: "\(newValue)")
            }
        }
    }
    
    ///👇 创建SKAlbumModel模型
    ///
    /// - parameter result: 指定相册
    /// - parameter name:   相册名字
    ///
    /// - returns: SKAlbumModel模型
    class public func model(with result: PHFetchResult<AnyObject>, name: String?) -> SKAlbumModel {
        let model = SKAlbumModel()
        if let name = name {
            model.name = Bundle.sk_localizedString(for: name)
        }else{
            model.name = name
        }
        model.result = result
        model.count = result.count
        return model
    }


    
    ///👇 获取多属性字符串
    ///
    /// - parameter title:    主标题
    /// - parameter subTitle: 副标题
    private func getMutableAttributedString(title: String, subTitle: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: "\(title) (\(subTitle))")
        attributedString.addAttributes([NSForegroundColorAttributeName : UIColor.gray, NSFontAttributeName : UIFont.systemFont(ofSize: 14)], range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttributes([NSForegroundColorAttributeName : UIColor.black, NSFontAttributeName : UIFont.systemFont(ofSize: 14)], range: NSRange(location: 0, length: title.characters.count))
        return attributedString
    }
    
}

