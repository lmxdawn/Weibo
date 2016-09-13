//
//  WBWelcomeView.swift
//  微博
//
//  Created by lk on 16/9/7.
//  Copyright © 2016年 lk. All rights reserved.
//

import UIKit

import SDWebImage


///  欢迎界面
class WBWelcomeView: UIView {
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    //底部约束
    @IBOutlet weak var bottomCons: NSLayoutConstraint!
    // 头像宽度约束
    @IBOutlet weak var iconWidthCons: NSLayoutConstraint!
    
    class func webcomeView() -> WBWelcomeView{
        
        let nib = UINib(nibName: "WBWelcomeView", bundle: nil)
        
        let vc = nib.instantiate(withOwner: nil, options: nil)[0] as! WBWelcomeView
        //从XIB 加载的视图,默认是 600*600 的
        vc.frame = UIScreen.main().bounds
        
        return vc
        
    }
    
    
    override func awakeFromNib() {
        
//        guard let urlStringImage = WBNetworkManager.shared.userAccount.avatar_large,
//            url = URL(string:urlStringImage) else {
//            return
//        }
//        // 设置头像
//        iconView.sd_setImage(with: url, placeholderImage: UIImage(named: "avatar_default_big"))
        
        guard let urlString = WBNetworkManager.shared.userAccount.avatar_large else {
            return
        }
        // 设置头像
        iconView.cz_setImage(urlString: urlString, placeholderImage: UIImage(named: "avatar_default_big"),isAvatar: true)
        
        //设置圆角
//        iconView.layer.cornerRadius = iconWidthCons.constant * 0.5
//        iconView.layer.masksToBounds = true
        
    }

    // 自动布局系统更新完成约束后,会自动调用此方法
    // 通常是对子视图布局进行修改
//    override func layoutSubviews() {
//        super.layoutSubviews()
//    }
    
    // 视图被添加到 window 上,表示视图已经显示
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        // 视图是使用自动布局来设置的,只是设置了约束
        // - 当视图被添加到窗口上时,根据父视图的大小,计算约束值,更新控件位置
        // - layoutIfNeeded 会直接按照当前的约束直接更新控件位置
        self.layoutIfNeeded()
        
        bottomCons.constant = bounds.size.height - 200
        
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: { 
                        
                        //更新约束
                        self.layoutIfNeeded()
                        
            }) { (_) in
            
            UIView.animate(withDuration: 1.0, animations: { 
                self.tipLabel.alpha = 1
                }, completion: { (_) in
                    //关掉视图
                    self.removeFromSuperview()
            })
            
                
        }
        
        
        
    }
    
    
    
    
}
