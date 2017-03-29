//
//  SKAlbumCell.swift
//  SKImagePickerController
//
//  Created by nachuan on 2017/3/16.
//  Copyright © 2017年 nachuan. All rights reserved.
//

import UIKit

class SKAlbumCell: UITableViewCell {

    lazy var tipButton: UIButton = {[unowned self] in
        let tipButton = UIButton()
        tipButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        tipButton.frame = CGRect(x: self.contentView.sk_right, y: 0, width: 20, height: 20)
        tipButton.sk_centerY = self.contentView.center.y
        tipButton.setBackgroundImage(Bundle.sk_image(with: "preview_number_icon@2x"), for: .normal)
        tipButton.setTitle("2", for: .normal)
//        tipButton.backgroundColor = .red
        return tipButton
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.accessoryType = .disclosureIndicator
        self.contentView.addSubview(tipButton)
        self.imageView?.image = Bundle.sk_image(with: "takePicture@2x")
        self.imageView?.contentMode = .scaleToFill
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setInfo(with model: SKAlbumModel) -> Void {
//        self.imageView?.image = model.image
        self.textLabel?.attributedText = model.title
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
