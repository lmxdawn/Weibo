//
//  WBUserAccount.swift
//  微博
//
//  Created by lk on 16/9/7.
//  Copyright © 2016年 lk. All rights reserved.
//

import UIKit

private let accountFile:NSString = "useraccount.json"

/// MARK: - 用户账户信息
class WBUserAccount: NSObject {
    
    /// 访问令牌
    var access_token:String? //= "2.00iL4NPG0HWzLc2c8ead97fe0Aj37f"
    
    /// 用户UID
    var uid:String? //= "5721629434"
    
    // access_token的生命周期
    var expires_in:TimeInterval = 0.0 {
        didSet{
            expiresDate = Date(timeIntervalSinceNow: expires_in)
        }
    }
    
    //过期日期
    var expiresDate:Date?
    
    
    // 用户昵称
    var screen_name:String?
    
    //用户头像地址（大图），180×180像素
    var avatar_large:String?
    
    
    override var description: String{
        return yy_modelDescription()
    }
    
    
    override init() {
        super.init()
        
        //从磁盘加载保存文件 -> 字典
        guard let path = accountFile.cz_appendDocumentDir(),
                data = NSData(contentsOfFile: path),
        dict = try? JSONSerialization.jsonObject(with: (data as Data), options: []) as? [String:AnyObject] else {
            return
        }
        
        // 使用字典设置属性值
        yy_modelSet(with: dict ?? [:])
        
        
        // 判断 token 是否过期
        if expiresDate?.compare(Date()) != .orderedDescending {
            print("access_token 过期")
            // 清空token
            access_token = nil
            uid = nil
            
            // 删除文件
            _ = try? FileManager.default().removeItem(atPath: path)
            
        }
        print("账户正常:\(self)")
        
        
    }
    
    /**
     1.偏好设置(小) - Xocde 8 beta 无效
     2.沙盒- 归档/plist/json
     3.数据库(FMDB/CoreData)
     4.钥匙串访问(小/自动加密 - 需要使用框架 SSKeychain)
     
     //  这里用 json
     
     */
    func saveAccount(){
        
        // 模型转字典
        var dict = self.yy_modelToJSONObject() as? [String:AnyObject] ?? [:]
        
        // 删除 expires_in 的值
        dict.removeValue(forKey: "expires_in")
        
        // 字典序列化 data
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []),
                filePath = accountFile.cz_appendDocumentDir()
                else {
            return
        }
        
        // 写入磁盘
        (data as NSData).write(toFile: filePath, atomically: true)
        print("路径:\(filePath)")
    }
    
}
