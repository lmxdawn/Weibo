//
//  WBBaseViewController.swift
//  微博
//
//  Created by lk on 16/8/29.
//  Copyright © 2016年 lk. All rights reserved.
//

import UIKit


///主控制器

class WBBaseViewController: UIViewController{
    
    
    /// 访客视图字典
    var visitorInf:[String:String]?
    
    ///表格视图
    var tableView:UITableView?
    
    /// 刷新控件
    var refreshControl : CZRefreshControl?
    
    /// 上拉刷新标记
    var isPullup = false
    
    //自定义导航条
    lazy var navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.cz_screenWidth(), height: 64))
    /// 自定义导航条目
    lazy var navItem = UINavigationItem()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置UI
        setupUI();
        
        
        // 注册登录成功通知
        NotificationCenter.default().addObserver(self, selector: #selector(loginSuccess), name: WBUserLoginSuccessNotification, object: nil)
        

    }
    
    deinit {
        // 注销通知
        NotificationCenter.default().removeObserver(self)
    }
    
    // 加载数据
    func loadData(){
        /// 关闭刷新
        refreshControl?.endRefreshing()
        
        
    }
    
    
    /// 重写 title 的 didSet
    override var title: String?{
        didSet{
            navItem.title = title;
            
        }
        
    }

}


/// MARK: - 访客视图监听方法
extension WBBaseViewController{
    
    /// 登录成功方法
    @objc private func loginSuccess(n:Notification){
        
        // 登录前 左边是注册,右边是登录
        navItem.leftBarButtonItem = nil
        navItem.rightBarButtonItem = nil
        
        
        
        // 更新UI
        view = nil
        // 注销通知
        NotificationCenter.default().removeObserver(self)
        
    }
    
    @objc private func login(){
        print("登录")
        //发送通知
        NotificationCenter.default().post(name: NSNotification.Name(rawValue: WBUserShouldLoginNotification), object: nil)
    }
    
    
    @objc private func register(){
        print("注册")
    }
    
}


// MARK - 设置界面
extension WBBaseViewController{
    
    private func setupUI(){
        view.backgroundColor = UIColor.white();
        
        //取消自动缩进
        automaticallyAdjustsScrollViewInsets = false;
        
        /// 设置导航条
        setupNavigationBar()
        
        ///设置表格视图
        //setupTableView()
        
        WBNetworkManager.shared.userLogin ? setupTableView() : setupVisitorView()
        
    }
    
    
    ///设置表格视图
    func setupTableView(){
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        
        view.insertSubview(tableView!, belowSubview: navigationBar)
        
        ///设置数据源&代理
        tableView?.dataSource = self
        tableView?.delegate = self
        
        // 设置内容缩进
        
        tableView?.contentInset = UIEdgeInsets(top: navigationBar.bounds.height,
                                               left: 0,
                                               bottom: tabBarController?.tabBar.bounds.height ?? 49,
                                               right: 0)
        // 修改指示器的缩进
        tableView?.scrollIndicatorInsets = (tableView?.contentInset)!
        
        /// 设置刷新控件
        refreshControl = CZRefreshControl()
        
        //添加到视图
        tableView?.addSubview(refreshControl!)
        
        //添加监听方法
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
        // 加载数据
        loadData()
        
    }
    
    /// 设置访客视图
    private func setupVisitorView(){
        let visitorView = WBVisitorView(frame: view.bounds)
        // 设置访客视图的信息
        visitorView.visitorInfo = visitorInf;
        
        //添加访客视图按钮的监听方法
        visitorView.loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        visitorView.registerButton.addTarget(self, action: #selector(register), for: .touchUpInside)
        
        view.insertSubview(visitorView, belowSubview: navigationBar)
        
        
        /// 设置导航按钮
        navItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(register))
        navItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(login))
        
    }
    
    /// 设置导航条
    private func setupNavigationBar(){
        
        view.addSubview(navigationBar)
        
        navigationBar.items = [navItem]
        
        
        //设置 navBar 渲染颜色
        navigationBar.barTintColor = UIColor.cz_color(withHex: 0xF6F6F6)
        
        //设置 navBar 的字体颜色
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor
            .darkGray()]
        
        // 设置 navBar 按钮的文件颜色
        navigationBar.tintColor = UIColor.orange()
        
    }
    
}

/// MARK - UITableViewDataSource,UITableViewDelegate 
extension WBBaseViewController:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    //基类只是准备方法,子类负责具体的实现
    // 子类的数据源方法不需要 super
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 只是保证没有语法错误
        return UITableViewCell()
    }
    
    // 行高设置
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 10
    }
    
    /// 在显示最后一行的时候,做上拉刷新
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //1.判断 indexPath 是否是最后一行
        let row = indexPath.row
        let secion = tableView.numberOfSections - 1
        
        if row < 0 || secion < 0{
            return
        }
        
        let count = tableView.numberOfRows(inSection: secion)
        
        if row == (count - 1) && !isPullup{
            
            isPullup = true;
            
            loadData();
            
        }
        
    }
    
    
}



