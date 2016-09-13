//
//  WBComposeTypeButton.swift
//  微博
//
//  Created by lk on 16/9/10.
//  Copyright © 2016年 lk. All rights reserved.
//

import UIKit

class WBComposeTypeButton: UIControl {
    // 图标
    @IBOutlet weak var imageView: UIImageView!
    // 底部文字
    @IBOutlet weak var titleLabel: UILabel!

    // 点击按钮要展现控制器的类型
    var clsName:String?
    
    class func composeTypeButton(imageName:String,title:String) -> WBComposeTypeButton{
        
        let nib = UINib(nibName: "WBComposeTypeButton", bundle: nil)
        
        let btn = nib.instantiate(withOwner: nil, options: nil)[0] as! WBComposeTypeButton
        
        btn.imageView.image = UIImage(named: imageName)
        btn.titleLabel.text = title
        
        return btn
        
        
    }
    
}
