//
//  AppDelegate.swift
//  微博
//
//  Created by lk on 16/8/29.
//  Copyright © 2016年 lk. All rights reserved.
//

import UIKit

// ios 10 的设置通知
import UserNotifications

import SVProgressHUD
import AFNetworking

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // 设置应用程序额外信息
        setupAdditions()
        
        
        //sleep(2)
        
        window = UIWindow();
        window?.backgroundColor = UIColor.white();
        
        window?.rootViewController = WBMainViewController();
        window?.makeKeyAndVisible();
        
        
        
        return true
    }


}

// MARK: - 设置应用程序额外信息
extension AppDelegate{
    private func setupAdditions(){
        // 1.设置 SVProgressHUD 最小解除时间
        SVProgressHUD.setMinimumDismissTimeInterval(1.0)
        
        // 2.设置网络加载指示器
        AFNetworkActivityIndicatorManager.shared().isEnabled = true
        
        // 3.设置用户授权显示通知
        if #available(iOSApplicationExtension 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization([.alert,.badge,.carPlay,.sound]) { (success, error) in
                //print("授权"+(success ? "成功" : "失败"))
            }
            
        }else{
            // 取得用户授权显示通知[上方的提示条/声音/BadgeNumber]
            let notifySettings = UIUserNotificationSettings(types: [.alert,.badge,.sound], categories: nil)
            UIApplication.shared().registerUserNotificationSettings(notifySettings)
            
        }
        
        
    }
}



