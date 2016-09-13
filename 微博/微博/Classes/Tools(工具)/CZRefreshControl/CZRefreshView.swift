//
//  CZRefreshView.swift
//  自定义刷新控件
//
//  Created by lk on 16/9/10.
//  Copyright © 2016年 lk. All rights reserved.
//

import UIKit

/// 刷新视图 - 负责刷新相关的视图处理
class CZRefreshView: UIView {

    /**
     IOS 系统中 UIVIew 封装的旋转动画
     - 默认顺时针旋转
     - 就近原则
     - 要想实现同方向旋转,需要调整一个,非常小的值
     */
    var refreshState:CZRefreshState = .Normal{
        didSet{
            switch refreshState {
            case .Normal:
                // 恢复状态
                tipIcon?.isHidden = false
                indicator?.stopAnimating()
                
                tipLabel?.text = "下拉会刷新..."
                // 还原图标
                UIView.animate(withDuration: 0.25, animations: {
                    self.tipIcon?.transform = CGAffineTransform.identity
                })
            case .Pulling:
                tipLabel?.text = "放手就刷新..."
                // 旋转图标
                UIView.animate(withDuration: 0.25, animations: { 
                    self.tipIcon?.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI - 0.001))
                })
            case .WillRefresh:
                tipLabel?.text = "正在刷新中..."
                // 隐藏提示图标
                tipIcon?.isHidden = true
                // 显示菊花
                indicator?.startAnimating()
                
            }
            
        }
    }
    
    // 父视图高度
    var parentViewHeight:CGFloat = 0
    
    /// 指示器
    @IBOutlet weak var indicator: UIActivityIndicatorView?
    /// 提示图标
    @IBOutlet weak var tipIcon: UIImageView?
    /// 提示标签
    @IBOutlet weak var tipLabel: UILabel?

    class func refreshView() -> CZRefreshView{
        
        let nib = UINib(nibName: "CZMeituanRefreshView", bundle: nil)
        
        return nib.instantiate(withOwner: nil, options: nil)[0] as! CZRefreshView
        
    }

}
