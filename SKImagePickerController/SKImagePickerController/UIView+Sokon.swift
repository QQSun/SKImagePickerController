//
//  UIView+Sokon.swift
//  SKImagePickerController
//
//  Created by nachuan on 2017/3/14.
//  Copyright © 2017年 nachuan. All rights reserved.
//
import UIKit
import Foundation
extension UIView {

    var sk_origin: CGPoint {
        get {
            return self.frame.origin
        }
        set {
            self.frame.origin = newValue
        }
    }
    
    var sk_originX: CGFloat {
        get {
            return self.sk_origin.x
        }
        set {
            self.sk_origin.x = newValue
        }
    }
    
    var sk_originY: CGFloat {
        get {
            return self.sk_origin.y
        }
        set {
            self.sk_origin.y = newValue
        }
    }
    
    var sk_width: CGFloat {
        get {
            return self.frame.size.width;
        }
        set {
            self.frame.size.width = newValue
        }
    }
    
    var sk_height: CGFloat {
        get {
            return frame.size.height
        }
        set {
            frame.size.height = newValue
        }
    }
    
    var sk_centerX: CGFloat {
        get {
            return self.center.x
        }
        set {
            self.center.x = newValue
        }
    }
    
    var sk_centerY: CGFloat {
        get {
            return self.center.y
        }
        set {
            self.center.y = newValue
        }
    }

    var sk_left: CGFloat {
        get {
            return self.sk_originX
        }
        set {
            self.sk_originX = newValue
        }
    }
    
    var sk_right: CGFloat {
        get {
            return self.sk_originX + self.sk_width
        }
        set {
            self.sk_originX = newValue - self.sk_width
        }
    }
    
    var sk_top: CGFloat {
        get {
            return self.sk_originY
        }
        set {
            self.sk_originY = newValue
        }
    }
    
    var sk_bottom: CGFloat {
        get {
            return self.sk_originY + self.sk_height
        }
        set {
            self.sk_originY = newValue - self.sk_height
        }
    }
    
}
