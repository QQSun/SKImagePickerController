//
//  Bundle+SoKon.swift
//  SKImagePickerController
//
//  Created by nachuan on 2017/3/14.
//  Copyright © 2017年 nachuan. All rights reserved.
//

import UIKit
import Foundation

var bundle: Bundle?
var skBundle: Bundle?

extension Bundle {
    class func sk_localizedString(for key: String, with value: String?) -> String {
        if bundle == nil {
            var language: String? = NSLocale.preferredLanguages.first
            if (language?.range(of: "zh-Hans") != nil) {
                language = "zh-Hans"
            }else{
                language = "en"
            }
            bundle = Bundle(path: Bundle.sk_bundle(for: "TZImagePickerController").path(forResource: language, ofType: "lproj")!)
        }
        return bundle!.localizedString(forKey: key, value: value, table: nil)
    }
    
    class func sk_localizedString(for key: String) -> String {
        return sk_localizedString(for: key, with: nil)
    }
    
    class func sk_bundle(for resource: String?) -> Bundle {
        if skBundle == nil {
            var path = Bundle.main.path(forResource: resource, ofType: "bundle")
            if path == nil {
                path = Bundle.main.path(forResource: resource, ofType: "bundle", inDirectory: "Frameworks/\(resource).framework/")
            }
            skBundle = Bundle(path: path!)
        }
        return skBundle!
    }
    
    class func sk_image(with named: String) -> UIImage? {
        guard let path = Bundle.sk_bundle(for: "TZImagePickerController").path(forResource: named, ofType: "png") else {
            return nil
        }
        let image = UIImage(contentsOfFile: path)?.withRenderingMode(.alwaysOriginal)
        return image
    }
    
}
