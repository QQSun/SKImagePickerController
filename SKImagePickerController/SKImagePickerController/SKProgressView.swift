//
//  SKProgressView.swift
//  SKImagePickerController
//
//  Created by nachuan on 2017/3/17.
//  Copyright © 2017年 nachuan. All rights reserved.
//

import UIKit

class SKProgressView: UIView {

    ///👇 设置进度条线宽
    var lineWidth: CGFloat = 2 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    ///👇 设置进度条背景色
    var progressBackgroundColor: UIColor = UIColor.white {
        didSet {
            setNeedsDisplay()
        }
    }
    
    ///👇 设置进度条颜色
    var progressColor: UIColor = UIColor.white {
        didSet {
            setNeedsDisplay()
        }
    }
    
    ///👇 设置进度
    var progress: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    ///👇 进度条贝塞尔路径
    lazy var path: UIBezierPath = {[unowned self] in
        let width = self.bounds.width - self.lineWidth * 2
        let rect = CGRect(x: self.lineWidth, y: self.lineWidth, width: width, height: width)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: rect.width / 2.0)
        return path
    }()
    
    ///👇 进度条背景
    lazy var backgroundLayer: CAShapeLayer = {[unowned self] in
        let backgroundLayer = CAShapeLayer()
        backgroundLayer.lineWidth = self.lineWidth
        backgroundLayer.fillColor = self.progressBackgroundColor.cgColor
        backgroundLayer.strokeColor = self.progressBackgroundColor.cgColor
        backgroundLayer.opacity = 0.1
        backgroundLayer.path = self.path.cgPath
        backgroundLayer.strokeStart = 0
        backgroundLayer.strokeEnd = 1
        return backgroundLayer
        
    }()
    
    ///👇 进度条
    lazy var progressLayer: CAShapeLayer = {[unowned self] in
        let progressLayer = CAShapeLayer()
        progressLayer.frame = self.bounds
        progressLayer.lineWidth = self.lineWidth
        progressLayer.fillColor = self.progressColor.cgColor
        progressLayer.strokeColor = self.progressColor.cgColor
        progressLayer.isOpaque = false
        progressLayer.lineCap = kCALineCapRound
        progressLayer.path = self.path.cgPath
        progressLayer.strokeStart = 0
        return progressLayer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.layer.addSublayer(backgroundLayer)
        self.layer.addSublayer(progressLayer)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        progressLayer.strokeEnd = progress
    }
    

}
