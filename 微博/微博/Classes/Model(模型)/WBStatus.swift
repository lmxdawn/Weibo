//
//  WBStatus.swift
//  微博
//
//  Created by lk on 16/9/5.
//  Copyright © 2016年 lk. All rights reserved.
//

import UIKit
import YYModel

/// 微博数据模型
class WBStatus: NSObject {

    /// Int类型,在64位的机器是 64 位,在 32位机器是 32位
    /// 如果不写 Int64 在低端的应用上无法正常运行
    // 微博ID
    var id:Int64 = 0
    // 微博信息内容
    var text:String?
    
    /// 微博创建时间
    var created_at:String?{
        didSet{
            created_data  = Date.cz_sinaDate(string: created_at ?? "")
        }
    }
    var created_data:Date?
    
    
    
    /// 微博来源
    var source:String?{
        didSet{
            /// 重新计算来源并且保存
            source = "来自于 " + (source?.cz_href()?.text ?? "")
        }
    }
    
    /// 微博模型配图数组
    var pic_urls:[WBStatusPicture]?
    
    /// 转发数
    var reposts_count:Int = 0
    
    /// 评论数
    var comments_count = 0
    
    /// 点赞数
    var attitudes_count = 0
    
    
    // 微博作者的用户信息
    var user:WBUser?
    
    // 被转发的原微博信息
    var retweeted_status:WBStatus?
    
    
    // 重写 description 计算型属性
    override var description: String{
        return yy_modelDescription()
    }
    
    /// 类方法 -> 告诉第三方框架 YY_Model 如果遇到数组类型的属性,数组中存放的对象时什么类?
    class func modelContainerPropertyGenericClass() -> [String:AnyClass]{
        return ["pic_urls":WBStatusPicture.self]
    }
    
    
}
