//
//  WBStatusListDAL.swift
//  微博
//
//  Created by lk on 16/9/13.
//  Copyright © 2016年 lk. All rights reserved.
//

import Foundation

/// DAL - Data Access Layer 数据访问层
/// 使命:负责处理数据库和网络数据,给 LlistViewModel 返回微博的 字典数组

class WBStatusListDAL {
    
    /// 从本地数据库或者网络加载数据
    class func loadStatus(since_id:Int64 = 0,max_id:Int64 = 0,completion:(list:[[String:AnyObject]]?,isSuccess:Bool)->()){
        
        guard let userId = WBNetworkManager.shared.userAccount.uid else{
            return
        }
        // 检查本地数据,如果有直接返回
        let array = CZSQLiteManager.shared.loadStatus(userId: userId, since_id: since_id, max_id: max_id)
        // 判断数组的数量
        if array.count > 0 {
            completion(list: array, isSuccess: true)
            return
        }
        
        // 加载网络数据
        WBNetworkManager.shared.statusList(since_id: since_id, max_id: max_id) { (list, isSuccess) in
            
            if !isSuccess{
                completion(list: nil, isSuccess: isSuccess)
                return
            }
            
            guard let list = list else{
                completion(list: nil, isSuccess: isSuccess)
                return
            }
            
            // 加载完成,将网络数据写入数据库
            CZSQLiteManager.shared.updateStatus(userId: userId, array: list)
            
            // 返回网络数据
            completion(list: list, isSuccess: isSuccess)
        }
        
        
        
    }
    
}
