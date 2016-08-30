//
//  WBMainViewController.swift
//  微博
//
//  Created by lk on 16/8/29.
//  Copyright © 2016年 lk. All rights reserved.
//

import UIKit

class WBMainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChildControllers();

    }


}


// extension 类似于 OC 中的分类,在swift 中还可以用来切分代码块
// 可以吧相近功能的函数,放在一个 extension 中
// 这样可以便于代码的维护

// 注意: 和OC 的分类一样 extension 中不能定义属性

// MARK: - 设置界面
extension WBMainViewController {
    
    //设置所有自控制器
    private func setupChildControllers() {
        
        let array = [
            ["clsName":"WBHomeViewController","title":"首页","imageName":"home"],
            ["clsName":"WBMessageViewController","title":"消息","imageName":"message_center"],
            ["clsName":"WBDiscoverViewController","title":"发现","imageName":"discover"],
            ["clsName":"WBProfileViewController","title":"我","imageName":"profile"],
        ]
        
        var arrayM = [UIViewController]();
        for dict in array {
            arrayM.append(controller(dict: dict));
        }
        
        viewControllers = arrayM;
        
    }
    
    /// 使用字典创建一个子控制器
    /// dict[clsName,title,imageName]
    private func controller(dict:[String:String]) -> UIViewController{
        
        //1.取得字典内容
        guard let clsNmae = dict["clsName"],
            title = dict["title"],
            imageName = dict["imageName"],
            cls = NSClassFromString(Bundle.main().namespace + "." + clsNmae) as? UIViewController.Type
                else {
                    return UIViewController();
        }
        
        // 2.创建视图控制器
        // 1>将clsName 转成 cls
        let vc = cls.init()
        vc.title = title;
        // 设置图片
        vc.tabBarItem.image = UIImage(named: "tabbar_" + imageName);
        vc.tabBarItem.selectedImage = UIImage(named: "tabbar_" + imageName + "_selected")?.withRenderingMode(.alwaysOriginal);
        
        // 设置tabar 的标题字体
        vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.orange()], for: .highlighted)
        
        let nav = WBNavigationController(rootViewController: vc)
        
        return nav;
        
        
    }
    
}
