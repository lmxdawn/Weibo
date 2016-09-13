//
//  WBNetworkManager+Extension.swift
//  微博
//
//  Created by lk on 16/9/5.
//  Copyright © 2016年 lk. All rights reserved.
//

import Foundation


/// MARK - 封装新浪微博的网络请求方法
extension WBNetworkManager{
    
    /// 加载微博数组
    // - parameter completion : 完成回调[list:结果字典数组/是否成功]
    func statusList(since_id:Int64 = 0,max_id:Int64 = 0,completion:(list:[[String:AnyObject]]?,isSuccess:Bool)->()){
        
        let urlString = "https://api.weibo.com/2/statuses/friends_timeline.json"
        
        let params = ["since_id":"\(since_id)","max_id":"\(max_id > 0 ? max_id - 1 : 0)"]
        
        
        tokenRequset(URLString: urlString, parameters: params) { (json, isSuccess) in
            if(!isSuccess){
                print("网络错误")
                return
            }
            
            // 从json中回去 statuses 字典数组
            let result = json?["statuses"] as? [[String:AnyObject]]
            
            completion(list: result, isSuccess: true)
            
        }
        
    }
    
    
    /// 返回微博的未读数量
    func unreadCount(completion:(count:Int)->()){
        
        guard let uid = userAccount.uid else {
            return
        }
        
        let urlString = "https://rm.api.weibo.com/2/remind/unread_count.json"
        
        let params = ["uid":uid]
        
        tokenRequset(URLString: urlString, parameters: params) { (json, isSuccess) in
            
            let dict = json as? [String:AnyObject]
            let count = dict?["status"] as? Int
            
            completion(count: count ?? 0)
            
        }
        
    }
    
    
}

// MARK: - 发布微博
extension WBNetworkManager{
    
    func postStuatus(status:String,image:UIImage? = nil,completion: (result:[String:AnyObject]?,isSuccess:Bool) -> () ) -> (){
        // url
        var urlString:String
        // 需要上传的文件字段
        var name:String?
        // 文件流
        var data:Data?
        if image == nil {
            urlString = "https://api.weibo.com/2/statuses/update.json"
        }else{
            
            urlString = "https://api.weibo.com/2/statuses/upload.json"
            name = "pic"
            data = UIImagePNGRepresentation(image!)
        }
        
        let params = ["status":status]
        
        // 如果图像不为空
        
        // 发起网络请求
        tokenRequset(method: .POST,URLString: urlString,parameters: params,name:name,data:data) { (json, isSuccess) in
            
            completion(result: json as? [String:AnyObject], isSuccess: isSuccess)
            
        }
        
        
    }
    
}


/// MARK: - 用户信息
extension WBNetworkManager{
    
    // 加载用户信息
    func loadUserInfo(completion:(dict:[String:AnyObject])->()){
        
        guard let uid = userAccount.uid else {
            return
        }
        
        let urlString = "https://api.weibo.com/2/users/show.json"
        let params = ["uid":uid]
        //发起网络请求
        tokenRequset(URLString: urlString, parameters: params) { (json, isSuccess) in
            //print("用户信息:\(json)")
            completion(dict: json as? [String:AnyObject] ?? [:])
        }
    
    }
    
    
}


/// MARK: - OAuth 相关方法
extension WBNetworkManager{
    
    //加载 AccessToken
    func loadAccessToken(code:String,completion:(json:AnyObject?,isSuccess:Bool)->()){
        
        let urlString = "https://api.weibo.com/oauth2/access_token"
        
        let params = ["client_id":WBAppKey,
                      "client_secret":WBAppSecret,
                      "grant_type":"authorization_code",
                      "code":code,
                      "redirect_uri":WBRedirectURI
                      ]
        request(method:.POST,URLString: urlString, parameters: params) { (json, isSuccess) in
            //print("授权信息:\(json)")
            // 直接用字典设置 userAccount 的属性
            // [:] 代表空字典
            self.userAccount.yy_modelSet(with: (json as? [String:AnyObject]) ?? [:])
            print(self.userAccount)
            
            //加载用户信息
            self.loadUserInfo(completion: { (dict) in
                // 使用用户信息字典设置用户账户信息
                self.userAccount.yy_modelSet(with: dict)
                
                completion(json: json, isSuccess: isSuccess)
                
                // 保存模型
                self.userAccount.saveAccount()
                
            })
            
            
        }
        
        
    }
    
    
}

