//
//  WBWebViewController.swift
//  微博
//
//  Created by lk on 16/9/11.
//  Copyright © 2016年 lk. All rights reserved.
//

import UIKit
import SVProgressHUD

class WBWebViewController: WBBaseViewController {

    private lazy var webView = UIWebView(frame: UIScreen.main().bounds)

    // 需要加载的页面
    var urlString:String?{
        didSet{
            
            guard let urlString = urlString,
                url = URL(string:urlString) else {
                return
            }
            //加载
            webView.loadRequest(URLRequest(url: url))
        }
        
    }
    
}

extension WBWebViewController{
    
    override func setupTableView() {
        
        // 设置标题
        navItem.title = "网页"
        
        // 设置webView
        view.insertSubview(webView, belowSubview: navigationBar)
        
        webView.backgroundColor = UIColor.white()
        
        // 设置 contentInset
        webView.scrollView.contentInset.top = navigationBar.bounds.height
        
        // 设置代理
        webView.delegate = self
        
    }
    
}

// MARK: - UIWebViewDelegate 代理
extension WBWebViewController:UIWebViewDelegate{
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
}


