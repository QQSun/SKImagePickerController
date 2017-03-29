//
//  SKAlbumPickerController.swift
//  SKImagePickerController
//
//  Created by nachuan on 2017/3/14.
//  Copyright © 2017年 nachuan. All rights reserved.
//

import UIKit

extension SKAlbumPickerController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SKImageManager.defaultManager.albumModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = SKImageManager.defaultManager.albumModels[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: SKAlbumPickerController.identifier) as? SKAlbumCell
        if cell == nil {
            cell = SKAlbumCell(style: .default, reuseIdentifier: SKAlbumPickerController.identifier)
        }
        cell!.setInfo(with: model)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let albumModel = SKImageManager.defaultManager.albumModels[indexPath.row]
        let picker = SKPhotoPickerController()
        picker.albumModel = albumModel
        picker.isFirstPushed = false
        self.navigationController?.pushViewController(picker, animated: true)
        
        
    }
    
    
}


class SKAlbumPickerController: UIViewController {

    static let identifier = "cell"  ///👈 cell的复用标识
    var isFirstAppear: Bool!
    
    
    lazy open var tableView: UITableView = {[unowned self] in
        let tableView = UITableView(frame: self.view.bounds)
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        return tableView;
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .green
        self.navigationItem.title = Bundle.sk_localizedString(for: "Photos")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: Bundle.sk_localizedString(for: "Cancel"), style: .plain, target: self, action: #selector(cancelButtonClicked))
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: Bundle.sk_localizedString(for: "Back"), style: .plain, target: nil, action: nil)
        self.view.addSubview(tableView)

        configTableView()
    }

    func cancelButtonClicked() -> Void {
        (self.navigationController as! SKImagePickerController).cancelButtonClicked()
    }

    /// 配置tableView数据
    private func configTableView() -> Void {
        SKImageManager.defaultManager.fetchAllAlbumsWithAlbumModels(completion: { (albumModels: [SKAlbumModel]) in
            self.tableView.reloadData()
        })
        
        
        //MARK:此处加入菊花
        DispatchQueue.global().async {
            SKImageManager.defaultManager.fetchAssetsForAllAlbums {
                //取消菊花转动
            }
        }
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    deinit {
        print(("\(#file)" as NSString).lastPathComponent + "--" + "\(#function)")
    }
    
}
