//
//  WBTitleButton.swift
//  微博
//
//  Created by lk on 16/9/7.
//  Copyright © 2016年 lk. All rights reserved.
//

import UIKit

class WBTitleButton: UIButton {

    /// 重载构造函数
    init(title:String?){
        super.init(frame:CGRect())
        
        // 设置标题
        if title == nil {
            setTitle("首页", for: [])
        }else{
            setTitle(title! + "  ", for: [])
            setImage(UIImage(named: "navigationbar_arrow_down"), for: [])
            setImage(UIImage(named: "navigationbar_arrow_up"), for: .selected)
        }
        // 设置字体和颜色
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        setTitleColor(UIColor.darkGray(), for: [])
        
        // 设置大小
        sizeToFit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 重写布局子视图
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 判断 label 和imageView 是否同时存在
        guard let titleLabel = titleLabel,imageView = imageView else {
            return
        }
        
        // 将 label 的 x 向左移动 imageView 的宽度
        titleLabel.frame.origin.x = 0
        // 将 imageView 的 x 向右移动 label 的宽度
        imageView.frame.origin.x = titleLabel.bounds.width
        
        
    }
    

}
