//
//  Configuration.swift
//  SKImagePickerController
//
//  Created by nachuan on 2017/3/15.
//  Copyright © 2017年 nachuan. All rights reserved.
//
//  全局图片, 导航栏文字, 颜色 以及按钮相关配置
import Foundation
import UIKit
public struct Configuration {
    
    //MARK: 文字颜色,大小相关
    public var navigationBarTitleColor = UIColor.white  ///👈 导航栏标题颜色
    public var navigationBarBackgroundColor = UIColor.black    ///👈 导航栏背景色
    public var navigationBarTintColor = UIColor.white   ///👈 导航栏tintColor
    public var navigationBarTitleFont = UIFont.systemFont(ofSize: 17)   ///👈 导航栏标题字体
    public var barItemTextFont = UIFont.systemFont(ofSize: 15)  ///👈 导航栏相关barItem文本字体
    public var barItemTextColor = UIColor.white ///👈 导航栏相关barItem文本颜色
    public var videoLabelFont = UIFont.systemFont(ofSize: 10)   ///👈 cell上显示时长的字体
    public var settingButtonFont = UIFont.boldSystemFont(ofSize: 18)    ///👈 设置按钮Font

    
    //MARK: 图片相关
    public var takePictureImageName = "takePicture.png" ///👈 拍照的提示图片
    public var photoSelectedImageName = "photo_sel_photoPickerVc.png" ///👈 cell上选择按钮选中的图片
    public var photoDefaultImageName = "photo_def_photoPickerVc.png"    ///👈 cell上选择按钮未选中的图片
    public var photoNumberIconImageName = "photo_number_icon.png"   ///👈 选择数量的图标
    public var photoPreviewOriginalDefaultImageName = "preview_original_def.png"    ///👈 相片预览原始图默认的图片
    public var photoOriginalDefaultImageName = "photo_original_def.png" ///👈 相片原始图默认图片
    public var photoOriginalSelectedImageName = "photo_original_sel.png"  ///👈 相片原始图选中时图片
    
    //MARK: 文字内容相关
    public var doneButtonTitle = Bundle.sk_localizedString(for: "Done") ///👈 完成按钮标题
    public var cancelButtonTitle = Bundle.sk_localizedString(for: "Cancel") ///👈 取消按钮标题
    public var previewButtonTitle = Bundle.sk_localizedString(for: "Preview")   ///👈 预览按钮标题
    public var fullImageButtonTitle = Bundle.sk_localizedString(for: "Full image")  ///👈 全图按钮标题
    public var settingButtonTitle = Bundle.sk_localizedString(for: "Setting")   ///👈 设置按钮标题
    public var processHintTitle = Bundle.sk_localizedString(for: "Processing...")   ///👈 进度条提示文字
    public var tipLabelText = Bundle.sk_localizedString(for: "Allow %@ to access your album in \"Settings -> Privacy -> Photos\"")  ///👈 提示用户需要如何打开相册权限提示文字
}









