//
//  ViewController.swift
//  SKImagePickerController
//
//  Created by nachuan on 2017/3/14.
//  Copyright © 2017年 nachuan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SKImagePickerControllerDelegate {

    var progressView: SKProgressView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "hhh"
        let button: UIButton = UIButton()
        button.setTitle("click me", for: .normal)
        button.backgroundColor = .red
        button.frame = CGRect(x: 100, y: 100, width: 50, height: 50);
        button.addTarget(self, action: #selector(clicked(_:)), for: .touchUpInside)
        self.view.addSubview(button)
        
        progressView = SKProgressView(frame: CGRect(x: 100, y: 200, width: 50, height: 50))
        progressView!.progress = 0.5
        self.view.addSubview(progressView!)
    }

    
    func clicked(_ button: UIButton) -> Void {
        let picker = SKImagePickerController(3, columnNumber: 4, pickerDelegate: self, pushPhotoPickerController: true)
        picker.navigationBarBackgroundColor = .red
//        picker.sortAscendingByModificationDate = false
        picker.isHiddenAlbumWhenNotHaveAsset = true
        self.present(picker, animated: true, completion: nil)
//        progressView!.progress = CGFloat(arc4random_uniform(10)) / 10.0
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

