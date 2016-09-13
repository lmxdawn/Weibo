//
//  WBHomeViewController.swift
//  微博
//
//  Created by lk on 16/8/29.
//  Copyright © 2016年 lk. All rights reserved.
//

import UIKit

/// 定义全局常量,尽量使用 private 修饰,
// 原创微博可重用 Cell ID
private let originalCellId = "originalCellId"
// 被转发微博的可重用 Cell Id
private let retweetedCellId = "retweetedCellId"

class WBHomeViewController: WBBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    ///微博数据数组
    private lazy var listViewModel = WBStatusListViewModel()
    
    ///加载数据
    override func loadData() {
        
        refreshControl?.beginRefreshing()
        
        
        DispatchQueue.main.after(when: DispatchTime.now() + 2) { 
            self.listViewModel.loadStatus(pullup: self.isPullup) { (isSuccess) in
                //结束刷新控件
                self.refreshControl?.endRefreshing()
                /// 回复上拉刷新标记
                self.isPullup = false
                
                //刷新表格
                self.tableView?.reloadData()
            }
        }
        
        
        
        
        
        
    }
    
    // 显示好友
    @objc private func showFriends(){
        
        //print(#function)
        
        let vc = WBDemoViewController()
        
        //隐藏taBar
        //vc.hidesBottomBarWhenPushed = true;
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    

}

/// MARK: - 表格数据源方法
extension WBHomeViewController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let viewModel = listViewModel.statusList[indexPath.row]
        let cellId = (viewModel.status.retweeted_status != nil) ? retweetedCellId : originalCellId
        
        // 1.取Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! WBStatusCell
        // 2.设置Cell
        
        cell.viewModel = viewModel
        
        // 设置代理
        cell.delegate = self
        
        // 3.返回Cell
        return cell
        
    }
    
    // 设置行高
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // 获取视图模型
        let vm = listViewModel.statusList[indexPath.row]
        
        // 返回计算的行高
        return vm.rowHeight
        
    }
    
}

// MARK: - WBStatusCellDelegate 代理
extension WBHomeViewController:WBStatusCellDelegate{
    
    // 点击 链接
    func statusCellDidSelectURLString(cell: WBStatusCell, urlString: String) {
        //print(urlString)
        let vc = WBWebViewController()
        
        vc.urlString = urlString
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
}



// MARK - 设置界面
extension WBHomeViewController{
    
    //重写父类的方法
    override func setupTableView(){
        super.setupTableView()
        
        //设置导航栏按钮
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "好友", style: .plain, target: self, action: #selector(showFriends))
        navItem.leftBarButtonItem = UIBarButtonItem(title: "好友", target: self, action: #selector(showFriends))
        
        /// 注册原型 Cell
        //tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView?.register(UINib(nibName: "WBStatusNormalCell",bundle: nil), forCellReuseIdentifier: originalCellId)
        tableView?.register(UINib(nibName: "WBStatusRetweetedCell",bundle: nil), forCellReuseIdentifier: retweetedCellId)
        
        
        // 设置行高
        //tableView?.rowHeight = UITableViewAutomaticDimension // 自动行高
        //tableView?.estimatedRowHeight = 300 // 预估行高
        
        // 取消分隔线
        tableView?.separatorStyle = .none
        
        
        setupNavTitle()
        
    }
    
    //设置导航栏标题
    private func setupNavTitle(){
        
        // 用户昵称
        let title = WBNetworkManager.shared.userAccount.screen_name
        
        let button = WBTitleButton(title: title)
        
        navItem.titleView = button
        
        button.addTarget(self, action: #selector(clickTitButton), for: .touchUpInside)
        
    }
    
    //点击标题
    @objc private func clickTitButton(btn:UIButton){
        
        //设置选择状态
        btn.isSelected = !btn.isSelected
        
    }
    
}
