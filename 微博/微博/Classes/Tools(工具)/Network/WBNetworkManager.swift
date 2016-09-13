//
//  WBNetworkManager.swift
//  微博
//
//  Created by lk on 16/9/5.
//  Copyright © 2016年 lk. All rights reserved.
//

import UIKit
import AFNetworking


/// swift 的枚举
enum WBHTTPMethod{
    case GET
    case POST
}

class WBNetworkManager: AFHTTPSessionManager {

    /// 静态区/常量/闭包 ( 单例 )
    /// 在第一次访问时,执行闭包,并且将结果保存在 shared 常量中
    static let shared:WBNetworkManager = {
        // 实例化对象
        let instance = WBNetworkManager()
        // 设置响应反序列化支持的数据类型
        instance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
        return instance
        
    }()
    
    // 用户信息的懒加载
    lazy var userAccount = WBUserAccount()
    
    // 登录标记
    var userLogin:Bool{
        return userAccount.access_token != nil
    }
    
    
    /// 专门负责拼接 token 的网络请求方法
    func tokenRequset(method:WBHTTPMethod = .GET,URLString:String,parameters:[String:AnyObject]?,name:String? = nil,data:Data? = nil,competion:(json:AnyObject?,isSuccess:Bool)->()){
        
        //处理 token 字典
        // 判断 token 是否为nil 为 nil 返回
        guard let token = userAccount.access_token else {
            print("没有 token! 需要登录")
            // 发送通知,提示用户登录
            NotificationCenter.default().post(name: NSNotification.Name(WBUserShouldLoginNotification), object: "bad token")
            
            competion(json: nil, isSuccess: false)
            return
        }
        
        // 判断 参数字典是否存在,如果为 nil ,应该新建
        var parameters = parameters
        if parameters == nil{
            //实例化字典
            parameters = [String:AnyObject]()
        }
        
        // 设置参数字典
        parameters!["access_token"] = token
        
        // 判断是否是要上传文件
        if let name = name,data = data {
            // 上传文件
            upload(URLString: URLString, parameters: parameters, name: name, data: data, competion: competion)
            
        }else{
            
            request(method: method, URLString: URLString, parameters: parameters, competion: competion)
            
        }
        
        
    }
    
    
    /// 封装 AFN 的上传文件方法
    func upload(URLString:String,parameters:[String:AnyObject]?,name:String,data:Data,competion:(json:AnyObject?,isSuccess:Bool)->()){
        
        
        post(URLString, parameters: parameters, constructingBodyWith: { (formData) in
            
            // FIXME: - 创建formData
            
            formData.appendPart(withFileData: data, name: name, fileName: "", mimeType: "application/octet-stream")
            
            
            
            }, progress: nil, success: { (_, json) in
                
                competion(json:json,isSuccess:true)
                
            }) { (task, error) in
                // 针对 403 处理用户 token 过期
                if (task?.response as? HTTPURLResponse)?.statusCode == 403 {
                    print("Token 过期了")
                    
                    //  发送通知,提示用户再次登录(本方法不知道被谁调用,谁接收到,谁处理)
                    NotificationCenter.default().post(name: NSNotification.Name(WBUserShouldLoginNotification), object: nil)
                }
                
                competion(json: nil, isSuccess: false)
        }
        
        
    }
    
    
    /// 使用一个函数封装 AFN 的 GET / POST 请求
    func request(method:WBHTTPMethod = .GET,URLString:String,parameters:[String:AnyObject]?,competion:(json:AnyObject?,isSuccess:Bool)->()){
        
        /// 成功回调
        let success = { (task:URLSessionDataTask,json:AnyObject?)->() in
            competion(json:json,isSuccess:true)
        }
        
        /// 失败回调
        let failure = { (task:URLSessionDataTask?,json:NSError)->() in
            
            // 针对 403 处理用户 token 过期
            if (task?.response as? HTTPURLResponse)?.statusCode == 403 {
                print("Token 过期了")
                
                //  发送通知,提示用户再次登录(本方法不知道被谁调用,谁接收到,谁处理)
                NotificationCenter.default().post(name: NSNotification.Name(WBUserShouldLoginNotification), object: nil)
            }
            
            competion(json: nil, isSuccess: false)
        }
        
        if method == .GET{
            
            get(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        }else{
            
            post(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        }
        
        
    }
    
}
