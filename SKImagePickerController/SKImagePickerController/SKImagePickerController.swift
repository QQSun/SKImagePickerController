//
//  SKImagePickerController.swift
//  SKImagePickerController
//
//  Created by nachuan on 2017/3/14.
//  Copyright © 2017年 nachuan. All rights reserved.
//

import UIKit



class SKImagePickerController: UINavigationController {

    convenience init(_ maxImageCount: Int, pickerDelegate: SKImagePickerControllerDelegate) {
        self.init(maxImageCount, columnNumber: 4, pickerDelegate: pickerDelegate)
    }
    
    convenience init(_ maxImageCount: Int, columnNumber: Int, pickerDelegate: SKImagePickerControllerDelegate) {
        self.init(maxImageCount, columnNumber: columnNumber, pickerDelegate: pickerDelegate, pushPhotoPickerController: true)
    }
    
    convenience init(_ maxImageCount: Int, columnNumber: Int, pickerDelegate: SKImagePickerControllerDelegate, pushPhotoPickerController: Bool) {
        let albumPicker = SKAlbumPickerController()
        self.init(rootViewController: albumPicker)
        self.pushPhotoPickerController = pushPhotoPickerController
        self.maxImageCount = (maxImageCount < 9 && maxImageCount > 0) ? maxImageCount : 9
        self.columnNumber = columnNumber
        SKImageManager.defaultManager.maxImageCount = maxImageCount
        SKImageManager.defaultManager.columnNumber = columnNumber
        if SKImageManager.defaultManager.authorizationStatusAuthorized() {
            pushPickerController()
        }else{
            showSettingButtonForPhotoLibrary()
        }
        
        
        
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    weak var pickerDelegate: SKImagePickerControllerDelegate?   ///👈代理
    var pushPhotoPickerController: Bool = true  ///👈是否推出相片页
    
    var tipLabel: UILabel?  ///👈 未授权获取相册时提示的文字
    var settingButton: UIButton?    ///👈 未授权获取相册时跳转'设置'选项的按钮
    var timer: Timer?   ///👈 定时器, 实时监听是否已经授权
    var configuration = Configuration() ///👈 配置信息
    ///👇 可选中最大的相片数量, 默认9张, 也是可设置的最大值
    var maxImageCount: Int = 9 {
        willSet {
            SKImageManager.defaultManager.maxImageCount = newValue
        }
    }
    ///👇 相片展示时的列数, 最好设为4
    var columnNumber: Int = 4{
        willSet {
            SKImageManager.defaultManager.columnNumber = newValue
        }
    }
    
    ///👇 navigationBar背景色
    var navigationBarBackgroundColor: UIColor = UIColor(white: 34/255, alpha: 1) {
        willSet {
            self.navigationBar.barTintColor = newValue
        }
    }
    
    ///👇 navigationBar相关组件(item)颜色
    var navigationBarTintColor: UIColor = .white {
        willSet {
            self.navigationBar.tintColor = newValue
        }
    }
    
    ///👇 navigationBar样式
    var navigationBarStyle: UIBarStyle = .black {
        willSet {
            self.navigationBar.barStyle = newValue
        }
    }
    
    ///👇 获取时是否按修改日期升序排列
    var sortAscendingByModificationDate: Bool = true {
        willSet {
            SKImageManager.defaultManager.sortAscendingByModificationDate = newValue
        }
    }
    
    ///👇 是否处理图片方向, 默认是false, 不进行修正
    var isShouldFixOrientation: Bool = false {
        willSet {
            SKImageManager.defaultManager.isShouldFixOrientation = newValue
        }
    }

    ///👇 已选择的资源的模型数组
    var selectedAssetModels: [SKAssetModel]? {
        willSet {
            guard let newValue = newValue else { return SKImageManager.defaultManager.selectedAssetModels.removeAll() }
            SKImageManager.defaultManager.selectedAssetModels.append(contentsOf: newValue)
        }
    }
    
    ///👇 当相册无资源时是否将其隐藏, 默认false, 不隐藏
    var isHiddenAlbumWhenNotHaveAsset: Bool = false {
        willSet {
            SKImageManager.defaultManager.isHiddenAlbumWhenNotHaveAsset = newValue
        }
    }

    
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
    
    var hideWhenCanNotSelect: Bool = false  ///👈 隐藏不可以选中的图片, 默认是false, 不推荐将其设置为true
        
    var minPhotoWidthSelectable: Int = 0    ///👈 最小可选中的图片宽度, 默认是0, 小于这个宽度的图片不可选中
    
    var minPhotoHeightSelectable: Int = 0   ///👈 最小可选中的图片高度, 默认是0, 小于这个高度的图片不可选中
    
    ///👇 单选模式, 以下6个属性maxImageCount为1时才生效
    var showSelectButton: Bool = false  ///👈 在单选模式下, 照片列表页中, 显示选择按钮, 默认为false

    var allowCrop: Bool = true  ///👈 允许裁剪,默认为true，showSelectBtn为false才生效
    
    var needCircleCrop: Bool = false    ///👈 需要圆形裁剪框
    
    var cropRect: CGRect = .zero    ///👈 裁剪框的尺寸
    
    var circleCropRadius: CGFloat = 0   ///👈 裁剪框半径大小
    
    var cropViewSettingClosure: cropViewClosure?    ///👈 自定义裁剪框的其他属性
    
    private var didPushPhotoPickerController: Bool = false  /// 是否已经push到PickerController页
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationBar.isTranslucent = true
        self.navigationBar.barStyle = .black
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationBar.barTintColor = configuration.navigationBarBackgroundColor
        self.navigationBar.tintColor = configuration.navigationBarTintColor
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func pushPickerController() -> Void {
        didPushPhotoPickerController = false
        guard didPushPhotoPickerController == false && pushPhotoPickerController == true else {
            return
        }
        let picker = SKPhotoPickerController()
        picker.isFirstPushed = true
        self.pushViewController(picker, animated: true)
        self.didPushPhotoPickerController = true
        
    }
    
    private func showSettingButtonForPhotoLibrary() -> Void {
        
        var appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName")
        appName = appName ?? Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName")
        let tipLabel = UILabel()
        tipLabel.frame = CGRect(x: 40, y: 120, width: self.view.sk_width - 80, height: 60)
        tipLabel.textAlignment = .center
        tipLabel.font = UIFont.systemFont(ofSize: 16)
        tipLabel.textColor = .black
        tipLabel.numberOfLines = 2
        tipLabel.text = configuration.tipLabelText.replacingOccurrences(of: "%@", with: appName as! String)
        self.view.addSubview(tipLabel)
        self.tipLabel = tipLabel
        
        let settingButton = UIButton(type: .system)
        settingButton.setTitle(configuration.settingButtonTitle, for: .normal)
        settingButton.frame = CGRect(x: tipLabel.sk_left, y: tipLabel.sk_bottom, width: tipLabel.sk_width, height: 44)
        settingButton.titleLabel?.font = configuration.settingButtonFont
        settingButton.addTarget(self, action: #selector(settingButtonClicked), for: .touchUpInside)
        self.view.addSubview(settingButton)
        self.settingButton = settingButton
        
        let timer = Timer(timeInterval: 0.2, target: self, selector: #selector(observeAuthorizationStatusChange), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .commonModes)
        
    }
    
    //MARK: - 定时器回调事件
    func observeAuthorizationStatusChange() -> Void {
        if SKImageManager.defaultManager.authorizationStatusAuthorized() {
            tipLabel?.removeFromSuperview()
            settingButton?.removeFromSuperview()
            timer?.invalidate()
            timer = nil
            tipLabel = nil
            settingButton = nil
            pushPickerController()
        }
    }
    
    //MARK: - 按钮点击事件
    
    @objc private func settingButtonClicked() -> Void {
        UIApplication.shared.open(NSURL.init(string: UIApplicationOpenSettingsURLString) as! URL, options: [:], completionHandler: nil)
    }
    
    @objc open func cancelButtonClicked() -> Void {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print(("\(#file)" as NSString).lastPathComponent + "--" + "\(#function)")
    }
    
    
}

public protocol SKImagePickerControllerDelegate: NSObjectProtocol {
    
}

