//
//  CZRefreshContorl.swift
//  微博
//
//  Created by lk on 16/9/9.
//  Copyright © 2016年 lk. All rights reserved.
//

import UIKit

// 刷新状态切换的临界点
private let CZRefreshOffset:CGFloat = 126

/// 刷新状态
///
/// Normal:         普通状态
/// Pulling:        超过临界点,如果放手,开始刷新
/// WillRefresh:    用户超过临界点,并且放手
enum CZRefreshState {
    case Normal
    case Pulling
    case WillRefresh
}

// 刷新控件
class CZRefreshControl: UIControl {

    // MARK: - 属性
    // 刷新控件的父视图,下拉刷新控件应该适用于 UITableView / UICollectionView
    private weak var scrollView:UIScrollView?
    /// 刷新视图
    private lazy var refreshView = CZRefreshView.refreshView()
    
    // MARK: - 构造函数
    init() {
        super.init(frame: CGRect())
        
        // 设置界面
        setupUI()
    }
    
    // MARK: - XIB 调用
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // 设置界面
        setupUI()
    }
    
    // MARK: - willMove addSubview 方法会调用
    // - 当添加到父视图的时候,newSuperview 是父视图
    // - 当父视图被移除,newSuperView 是nil
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        //记录父视图
        guard let sv = newSuperview as? UIScrollView else {
            return
        }
        
        scrollView = sv
        
        // KVO 监听父视图的 contentOffset
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
        
    }
    
    // 当前视图从父视图上移除
    override func removeFromSuperview() {
        
        // superView 还存在
        // 移除 KVO
        superview?.removeObserver(self, forKeyPath: "contentOffset")
        
        super.removeFromSuperview()
        // 执行完父类 ,superView就不存在了
    }
    
    // 所有的 KVO 方法会调用此方法
    override func observeValue(forKeyPath keyPath: String?, of object: AnyObject?, change: [NSKeyValueChangeKey : AnyObject]?, context: UnsafeMutablePointer<Void>?) {
        
        guard let sv = scrollView else {
            return
        }
        // 初始高度 是 0
        let height = -(sv.contentInset.top + sv.contentOffset.y)
        
        if height < 0{
            return
        }
        
        // 传递父视图高度,如果正在刷新则不传递
        if refreshView.refreshState != .WillRefresh {
            refreshView.parentViewHeight = height
        }
        
        // 可以根据高度设置刷新控件的 frame
        self.frame = CGRect(x: 0,
                            y: -height,
                            width: sv.bounds.width,
                            height: height)
        
        // 判断临界点
        if sv.isDragging {
            if height > CZRefreshOffset && (refreshView.refreshState == .Normal) {
                //print("放手刷新")
                refreshView.refreshState = .Pulling
                
            }else if height <= CZRefreshOffset && (refreshView.refreshState == .Pulling){
                //print("继续使劲..")
                refreshView.refreshState = .Normal
                
            }
        }else{
            
            // 放手 - 判断是否超过临界点
            if refreshView.refreshState == .Pulling {
                //print("准备开始刷新")
                beginRefreshing()
                
                // 发送刷新数据事件
                sendActions(for: .valueChanged)
            }
            
        }
        
    }
    
    /// 开始刷新
    func beginRefreshing(){
        
        // 判断父视图是否存在
        guard let sv = scrollView else {
            return
        }
        
        // 判断是否在执行刷新,
        if refreshView.refreshState == .WillRefresh {
            return
        }
        
        // 设置刷新视图的状态
        refreshView.refreshState = .WillRefresh
        
        // 传递父视图高度
        refreshView.parentViewHeight = CZRefreshOffset
        
        // 调整表格的间距
        var inset = sv.contentInset
        inset.top += CZRefreshOffset
        
        sv.contentInset = inset
        
    }
    
    /// 结束刷新
    func endRefreshing(){
        
        // 判断父视图是否存在
        guard let sv = scrollView else {
            return
        }
        
        // 判断是否在执行刷新,
        if refreshView.refreshState != .WillRefresh {
            return
        }
        
        // 恢复刷新视图状态
        refreshView.refreshState = .Normal
        
        // 恢复表格的 contentInset
        // 调整表格的间距
        var inset = sv.contentInset
        inset.top -= CZRefreshOffset
        
        sv.contentInset = inset
        
    }
    
}

// MARK: - 设置界面
extension CZRefreshControl{
    
    
    private func setupUI(){
        
        //backgroundColor = UIColor.orange()
        
        // 超出边界不显示
        //clipsToBounds = true
        
        // 添加刷新界面
        addSubview(refreshView)
        
        // 自动布局
        refreshView.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: refreshView.bounds.width))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .height,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: refreshView.bounds.height))
        
        
        
    }
}

