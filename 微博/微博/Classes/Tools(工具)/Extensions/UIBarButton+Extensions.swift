//
//  UIBarButton+Extensions.swift
//  微博
//
//  Created by lk on 16/9/2.
//  Copyright © 2016年 lk. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    
    //便利构造函数
    convenience init(title:String,fontSize:CGFloat = 16,target:AnyObject?,action:Selector,isBack:Bool = false) {
        
        let btn:UIButton = UIButton.cz_textButton(title, fontSize: fontSize, normalColor: UIColor.darkGray(), highlightedColor: UIColor.orange())
        
        if isBack{
            let imageName = "navigationbar_back_withtext"
            btn.setImage(UIImage(named: imageName), for: UIControlState(rawValue: 0))
            btn.setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
            //重新调整大小
            btn.sizeToFit()
            
        }
        
        btn.addTarget(target, action: action, for: .touchUpInside)
        
        //实例化 UIBarButtonItem
        self.init(customView:btn)
        
    }
    
}
