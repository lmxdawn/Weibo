//
//  WBMainViewController.swift
//  微博
//
//  Created by lk on 16/8/29.
//  Copyright © 2016年 lk. All rights reserved.
//

import UIKit
import SVProgressHUD

class WBMainViewController: UITabBarController {
    
    // 定时器
    private var timer:Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChildControllers();
        setupComposeButton();
        //定时操作
        setupTimer()
        
        // 新特性视图
        setupNewfeatureViews()
        
        //设置代理
        delegate = self
        
        
        //注册通知
        NotificationCenter.default().addObserver(self, selector: #selector(userLogin), name: WBUserShouldLoginNotification, object: nil)

    }
    
    deinit {
        //销毁时钟
        timer?.invalidate()
        
        //注销通知
        NotificationCenter.default().removeObserver(self)
        
    }
    
    /**
     portrait :竖屏,肖像
     landscape : 横屏,风景画
     
     - 使用代码控制设备的方向,好处,可以在需要横屏的时候单独处理
     - 设置支持方向之后,当前的控制器及自控制器都会遵循这个方向
     - 如果播放视频,通常是通过 modal 展现的
     
     */
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .portrait;
    }
    
    // MARK: - 监听通知
    @objc private func userLogin(n:Notification){
        
        print("用户登录通知\(n)")
        
        // 延时时间
        var when = DispatchTime.now()
        
        // 判断n.object 是否有值,如果有值,提示用户重新登录
        if n.object != nil {
            // 设置显示类型
            SVProgressHUD.setDefaultMaskType(.gradient)
            SVProgressHUD.showInfo(withStatus: "登录超时,请重新登录!")
            when = when + 2
        }
        
        // 延时
        DispatchQueue.main.after(when: when) {
            // 设置显示类型
            SVProgressHUD.setDefaultMaskType(.clear)
            //展现登录控制器
            let loginVc = UINavigationController(rootViewController: WBOAuthViewController())
            self.present(loginVc, animated: true, completion: nil)
        }
        
    }
    
    // MARK: - 监听方法
    // @objc 允许这个函数在"运行时"通过 OC 的消息机制被调用
    @objc private func composeStatus(){
        print("撰写微博")
        
        //撰写微博
        let vc = WBComposeTypeView.composeTypeView()
        vc.show { [weak vc] (clsName) in
            
            // 展现撰写微博控制器
            guard let clsName = clsName,
                cls = NSClassFromString(Bundle.main().namespace + "." + clsName) as? UIViewController.Type else{
                
                vc?.removeFromSuperview()
                return
            }
            
            let v = cls.init()
            
            let nav = UINavigationController(rootViewController: v)
            
            // 强行更新约束
            nav.view.layoutIfNeeded()
            
            self.present(nav, animated: true, completion: {
                
                vc?.removeFromSuperview()
            })
            
            
        }
        
        
    }

    private lazy var composeButton:UIButton = UIButton.cz_imageButton("tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")
    
}


// MARK: - 新特性视图处理
extension WBMainViewController{
    
    // 设置新特性视图
    private func setupNewfeatureViews(){
        
        // 0.判断是否登录
        if !WBNetworkManager.shared.userLogin {
            return
        }
        
        
        // 1. 如果更新,显示新特性,否则显示欢迎界面
        let v = isNewVersion ? WBNewFeatureView.newFeatureView() : WBWelcomeView.webcomeView()
        
        // 2.添加视图
        //v.frame = view.bounds
        
        view.addSubview(v)
        
        
    }
    
    /// extension 中可以有计算型属性,不会占用存储空间
    /// 构造函数:给属性分配空间
    /**
        版本号:
        - 在 AppStore 中每次升级应用程序,版本号都需要增加
        - 组成 主版本号.次版本号.修订版本号
        - 主版本号:意味着大的修改,使用者也需要做大的适应
        - 次版本号:意味着小的修改,某些函数和方法的使用或者参数有变化
        - 修订版本号:框架/程序内部 bug 的修订,不会对使用者照成任何影响
     
     */
    private var isNewVersion:Bool{
        
        // 1.取当前的版本号
        //print(Bundle.main().infoDictionary)
        // 新版本
        let currentVersion = Bundle.main().infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        //print(currentVersion)
        // 2.取保存在 'Document' 目录中的之前版本号
        let path:String = ("version" as NSString).cz_appendDocumentDir()
        // 沙盒版本
        let sandboxVersion = ( try? String(contentsOfFile: path)) ?? ""
        
        // 3.将版本号保存在沙盒
        _ = try? currentVersion.write(toFile: path, atomically: true, encoding: .utf8)
        
        // 4.返回两个版本号 '是否一致' not new
        return currentVersion != sandboxVersion
    }
    
    
}

// MARK: - UITabBarControllerDelegate 代理
extension WBMainViewController:UITabBarControllerDelegate{
    
    /// 将要选择 TabBarItem
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        // 获取控制器在数组中的索引
        let idx = (childViewControllers as NSArray).index(of: viewController)
        
        //判断
        if selectedIndex == 0 && selectedIndex == idx {
            print("点击首页")
            // 证明点击的是首页,目前的显示也是首页
            let nav = childViewControllers[0] as! WBNavigationController
            let vc = nav.childViewControllers[0] as! WBHomeViewController
            
            
            //滚动到顶部
            vc.tableView?.setContentOffset(CGPoint(x: 0,y: -64), animated: true)
            //清空badgeNumber
            setBadgeNumber(count: 0)
            
            //刷新数据
            DispatchQueue.main.after(when: DispatchTime.now() + 1, execute: { 
                vc.loadData()
            })
            
        }
        
        // 判断目标控制器是否是 UIVIewController
        return !viewController.isMember(of: UIViewController.self)
    }
    
}

// MARK: - 时钟相关方法
extension WBMainViewController{
    
    // 定义时钟
    private func setupTimer(){
        
        timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
    }
    
    // 时钟触发方法
    @objc private func updateTimer(){
        
        if !WBNetworkManager.shared.userLogin {
            return
        }
        
        WBNetworkManager.shared.unreadCount { (count) in
            print("检测到\(count)条微博")
            // 设置badgeNumber
            self.setBadgeNumber(count: count)
        }
        
    }
    
    // 设置badgeNumber
    @objc private func setBadgeNumber(count:Int){
        //设置首页 tabBarItem 的badgeNumber
        self.tabBar.items?[0].badgeValue = count > 0 ? "\(count)" : nil
        
        // 设置App 的badgeNumber
        UIApplication.shared().applicationIconBadgeNumber = count
    }
    
}


// extension 类似于 OC 中的分类,在swift 中还可以用来切分代码块
// 可以吧相近功能的函数,放在一个 extension 中
// 这样可以便于代码的维护

// 注意: 和OC 的分类一样 extension 中不能定义属性

// MARK: - 设置界面
extension WBMainViewController {
    
    
    //设置撰写按钮
    private func setupComposeButton(){
        tabBar.addSubview(composeButton)
        
        //计算撰写按钮宽度
        let count = childViewControllers.count;
        //将向内缩进的宽度减少,能让按钮的宽度变大,盖住容错点,防止穿帮
        //let w = tabBar.bounds.width / CGFloat(count) - 1
        let w = tabBar.bounds.width / CGFloat(count)
        
        // CGRectInset 正数向内缩进,负数向外扩展
        composeButton.frame = tabBar.bounds.insetBy(dx: 2 * w, dy: 0)
        
        //添加监听方法
        composeButton.addTarget(self, action: #selector(composeStatus), for: .touchUpInside)
        
    }
    
    //设置所有自控制器
    private func setupChildControllers() {
        
        //从 bundle 加载配置json
        guard let path = Bundle.main().pathForResource("main.json", ofType: nil),
                data = NSData(contentsOfFile: path),
                array = try? JSONSerialization.jsonObject(with: data as Data, options: []) as? [[String:AnyObject]]
                else {
            return
        }
        
//        let array:[[String:AnyObject]] = [
//            ["clsName":"WBHomeViewController","title":"首页","imageName":"home",
//             "visitorInfo":["imageName":"","message":"关注一些人,回这里看看有什么惊喜"]],
//            ["clsName":"WBMessageViewController","title":"消息","imageName":"message_center",
//             "visitorInfo":["imageName":"visitordiscover_image_message","message":"登录后,别人评论你的微博,发给你的消息,都会在这里收到通知"]],
//            ["clsName":"UIViewController"],
//            ["clsName":"WBDiscoverViewController","title":"发现","imageName":"discover",
//             "visitorInfo":["imageName":"visitordiscover_image_message","message":"登录后,最新,最热微博尽在掌握,不再会与实事潮流擦肩而过"]],
//            ["clsName":"WBProfileViewController","title":"我","imageName":"profile",
//             "visitorInfo":["imageName":"visitordiscover_image_profile","message":"登录后,你的微博,相册,个人资料会显示在这里,展示给别人"]],
//        ]
        
        // 测试数据格式是否正确 转换成 plist 数据更加直观
        
//        let data = try! JSONSerialization.data(withJSONObject: array, options: [.prettyPrinted])
//        (data as NSData).write(toFile: "/Users/lk/Desktop/demo.josn",atomically: true)
        
        var arrayM = [UIViewController]();
        for dict in array! {
            arrayM.append(controller(dict: dict));
        }
        
        viewControllers = arrayM;
        
    }
    
    /// 使用字典创建一个子控制器
    /// dict[clsName,title,imageName]
    private func controller(dict:[String:AnyObject]) -> UIViewController{
        
        //1.取得字典内容
        guard let clsNmae = dict["clsName"] as? String,
            title = dict["title"] as? String,
            imageName = dict["imageName"] as? String,
            cls = NSClassFromString(Bundle.main().namespace + "." + clsNmae) as? WBBaseViewController.Type,
                visitorInfo = dict["visitorInfo"] as? [String:String]
                else {
                    return UIViewController();
        }
        
        // 2.创建视图控制器
        // 1>将clsName 转成 cls
        let vc = cls.init()
        vc.title = title;
        //设置访客视图信息
        vc.visitorInf = visitorInfo
        // 设置图片
        vc.tabBarItem.image = UIImage(named: "tabbar_" + imageName);
        vc.tabBarItem.selectedImage = UIImage(named: "tabbar_" + imageName + "_selected")?.withRenderingMode(.alwaysOriginal);
        
        // 设置tabar 的标题字体
        vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.orange()], for: .highlighted)
        
        let nav = WBNavigationController(rootViewController: vc)
        
        return nav;
        
        
    }
    
}
