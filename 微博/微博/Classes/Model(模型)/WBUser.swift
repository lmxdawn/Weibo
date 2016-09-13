//
//  WBUser.swift
//  微博
//
//  Created by lk on 16/9/8.
//  Copyright © 2016年 lk. All rights reserved.
//

import UIKit


/// 微博用户模型
class WBUser: NSObject {
    
    // 用户ID
    var id:Int64 = 0
    
    // 用户昵称
    var screen_name:String?
    
    // 用户头像地址（中图），50×50像素
    var profile_image_url:String?
    
    // 认证类型
    var verified_type:Int = 0
    
    // 会员等级 0-6
    var mbrank:Int = 0
    
    override var description: String{
        return yy_modelDescription()
    }
    
    
}
