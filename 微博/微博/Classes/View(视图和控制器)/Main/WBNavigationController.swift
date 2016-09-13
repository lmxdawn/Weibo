//
//  WBNavigationController.swift
//  微博
//
//  Created by lk on 16/8/29.
//  Copyright © 2016年 lk. All rights reserved.
//

import UIKit

class WBNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        /// 隐藏默认的 NanigationBar
        navigationBar.isHidden = true;
    }

    //重写 push 方法,所有的 push 操作都会执行此方法
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        //判断,如果不是底部控制器才需要隐藏,根控制器不需要处理
        if childViewControllers.count > 0{
            
            //隐藏底部的 tabBar
            viewController.hidesBottomBarWhenPushed = true
            
            //判断 控制器的类型
            if let vc = viewController as? WBBaseViewController {
                
                var title = "返回";
                //判断控制器级数
                if childViewControllers.count == 1{
                    //title 显示 首页的标题
                    title = childViewControllers.first?.title ?? "返回"
                }
                
                //取出自定义的 navItem
                vc.navItem.leftBarButtonItem = UIBarButtonItem(title: title, target: self, action: #selector(popToParent),isBack:true)
            }
        }
        
        
        super.pushViewController(viewController, animated: true)
    }
    
    //pop 返回按钮点击事件(返回上一级控制器)
    @objc private func popToParent(){
        popViewController(animated: true)
    }

}
