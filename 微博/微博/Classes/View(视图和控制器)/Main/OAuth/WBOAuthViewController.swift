//
//  WBOAuthViewController.swift
//  微博
//
//  Created by lk on 16/9/5.
//  Copyright © 2016年 lk. All rights reserved.
//

import UIKit

// 提示
import SVProgressHUD

class WBOAuthViewController: UIViewController {
    
    private lazy var webView = UIWebView()
    
    override func loadView() {
        view = webView
        // 设置背景
        view.backgroundColor = UIColor.white()
        // 取消滚动
        webView.scrollView.isScrollEnabled = false
        
        
        // 设置代理
        webView.delegate = self
        
        //设置导航栏
        title = "登录新浪微博"
        //导航按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", target: self, action: #selector(close),isBack:true)
        //自动填充按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", target: self, action: #selector(autoFill))
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //加载授权页面的
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(WBAppKey)&redirect_uri=\(WBRedirectURI)"
        
        guard let url = URL(string:urlString) else {
            return
        }
        
        let result = URLRequest(url: url)
        
        //加载请求
        webView.loadRequest(result)
        
        
    }

    
    // 监听返回按钮(关闭控制器)
    @objc private func close(){
        
        // 关闭加载图标
        SVProgressHUD.dismiss()
        
        dismiss(animated: true, completion: nil)
    }
    
    // 监听自动填充按钮
    @objc private func autoFill(){
        // 准备 js
        let jsString = "document.getElementById('userId').value = '15213230873';" +
                       "document.getElementById('passwd').value = '19941225';"
        
        webView.stringByEvaluatingJavaScript(from: jsString)
    }

}

/// MARK: - UIWebViewDelegate代理
extension WBOAuthViewController:UIWebViewDelegate{
    
    /// webView 将要加载请求
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        // 如果请求地址中包含 http://baidu.com 就不加载页面
        if request.url?.absoluteString?.hasPrefix(WBRedirectURI) == false {
            return true
        }
        
        if request.url?.query?.hasPrefix("code=") == false {
            print("取消授权")
            //返回
            close()
            return false
        }
        
        // 获取授权码
        let code = request.url?.query?.substring(from: "code=".endIndex) ?? ""
        
        print("获取授权码:\(code)")
        
        //使用授权码获取 AccessToken
        WBNetworkManager.shared.loadAccessToken(code: code) { (json, isSuccess) in
            //print("授权信息:\(json)")
            
            if !isSuccess{
                SVProgressHUD.showInfo(withStatus: "网络请求失败")
                
            }else{
                SVProgressHUD.showInfo(withStatus: "登录成功")
                
                // 下一步 跳转页面
                // 发送登录成功通知
                NotificationCenter.default().post(name: NSNotification.Name(WBUserLoginSuccessNotification), object: nil)
                
                // 关闭窗口
                self.close()
            }
            
        }
        
        
        return false
    }
        
    // 开始加载
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    // 完成加载
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
}

