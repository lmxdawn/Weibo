//
//  WBStatusPicture.swift
//  微博
//
//  Created by lk on 16/9/8.
//  Copyright © 2016年 lk. All rights reserved.
//

import UIKit

/// 微博配图模型
class WBStatusPicture: NSObject {
    
    /// 缩略图地址
    var thumbnail_pic:String?{
        didSet{
            
            // 中等图
            largePic = thumbnail_pic?.replacingOccurrences(of: "/thumbnail/", with: "/large/")
            
            // 更改缩略图地址
            thumbnail_pic = thumbnail_pic?.replacingOccurrences(of: "/thumbnail/", with: "/wap360/")
        }
        
    }
    
    /// 中等图
    var largePic:String?
    
    override var description: String{
        return yy_modelDescription()
        
    }
}
