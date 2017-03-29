//
//  SKAssetCell.swift
//  SKImagePickerController
//
//  Created by nachuan on 2017/3/16.
//  Copyright © 2017年 nachuan. All rights reserved.
//

import UIKit

extension SKAssetCell {
    func setupConstraints() -> Void {
        ///👇 约束imageView
        for attribute: NSLayoutAttribute in [.width, .height, .centerX, .centerY] {
            addConstraint(NSLayoutConstraint(item: imageView, attribute: attribute, relatedBy: .equal, toItem: self, attribute: attribute, multiplier: 1, constant: 0))
        }
        ///👇 约束selectedButton
        var multipliers:[CGFloat] = [0.35, 0.35, 1, 1]
        var attributes: [NSLayoutAttribute] = [.width, .height, .top, .right]
        for index: Int in 0...3 {
            addConstraint(NSLayoutConstraint(item: selectedButton, attribute: attributes[index], relatedBy: .equal, toItem: imageView, attribute: attributes[index], multiplier: multipliers[index], constant: 0))
        }
        ///👇 约束videoImageView
        multipliers = [1, 1, 0.3, 0.25]
        attributes = [.left, .bottom, .width, .height]
        for index: Int in 0...3 {
            addConstraint(NSLayoutConstraint(item: videoImageView, attribute: attributes[index], relatedBy: .equal, toItem: imageView, attribute: attributes[index], multiplier: multipliers[index], constant: 0))
        }
        ///👇 约束videoLabel
        multipliers = [1, 1, 0.7, 0.25]
        attributes = [.right, .bottom, .width, .height]
        for index: Int in 0...3 {
            addConstraint(NSLayoutConstraint(item: videoLabel, attribute: attributes[index], relatedBy: .equal, toItem: imageView, attribute: attributes[index], multiplier: multipliers[index], constant: 0))
        }
    }
}

class SKAssetCell: UICollectionViewCell {
    
    
    var assetModel: SKAssetModel?
    var selectedButtonClickedClosure:((_ sender: UIButton) -> Void)?
    
    
    ///👇 显示主图片的imageView
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    ///👇 用于选中的按钮
    lazy var selectedButton: UIButton = {
        let selectedButton = UIButton()
        selectedButton.translatesAutoresizingMaskIntoConstraints = false
        selectedButton.setImage(Bundle.sk_image(with: "photo_def_photoPickerVc@2x"), for: .normal)
        selectedButton.setImage(Bundle.sk_image(with: "photo_sel_photoPickerVc@2x"), for: .selected)
        selectedButton.addTarget(self, action: #selector(selectedButtonClicked(sender:)), for: .touchUpInside)
        return selectedButton
    }()
    
    ///👇 显示视频小图标的imageView
    lazy var videoImageView: UIImageView = {
        let videoImageView = UIImageView()
        videoImageView.image = Bundle.sk_image(with: "VideoSendIcon@2x")
        videoImageView.translatesAutoresizingMaskIntoConstraints = false
        videoImageView.contentMode = .scaleAspectFit
        return videoImageView
    }()
    
    ///👇 显示视频时长的label
    lazy var videoLabel: UILabel = {
        let videoLabel = UILabel()
        videoLabel.text = "00:00"
        videoLabel.textColor = .white
        videoLabel.font = UIFont.systemFont(ofSize: 10)
        videoLabel.translatesAutoresizingMaskIntoConstraints = false
        return videoLabel
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        imageView.addSubview(selectedButton)
        imageView.addSubview(videoImageView)
        imageView.addSubview(videoLabel)
        self.contentView.addSubview(imageView)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    ///👇 设置cell的信息
    ///
    /// - parameter assetModel: 相片数据模型
    func setInfo(with assetModel: SKAssetModel) -> Void {
        self.assetModel = assetModel
        imageView.image = assetModel.image
        selectedButton.isSelected = assetModel.isSelected
        setSelectedButton(is: assetModel.isHiddenSelectedButton)
    }
    
    ///👇 是否隐藏选择按钮
    func setSelectedButton(is hidden: Bool) -> Void {
        selectedButton.isHidden = hidden
        videoImageView.isHidden = !hidden
        videoLabel.isHidden = !hidden
    }
    
    ///👇 选择按钮触发事件
    func selectedButtonClicked(sender: UIButton) -> Void {
        guard let assetModel = assetModel else { return }
        guard let selectedButtonClickedClosure = selectedButtonClickedClosure else { return }
        selectedButtonClickedClosure(sender)
    }
    
    
    
}
