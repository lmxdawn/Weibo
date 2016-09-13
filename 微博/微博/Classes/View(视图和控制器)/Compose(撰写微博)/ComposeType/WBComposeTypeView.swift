//
//  WBComposeTypeView.swift
//  微博
//
//  Created by lk on 16/9/10.
//  Copyright © 2016年 lk. All rights reserved.
//

import UIKit

// 动画框架
import pop

class WBComposeTypeView: UIView {

    // 显示自定义按钮视图
    @IBOutlet weak var scrollView: UIScrollView!
    // 关闭按钮的 CenterX
    @IBOutlet weak var closeButtonCenterXCons: NSLayoutConstraint!
    // 返回按钮的 CenterX
    @IBOutlet weak var returnButtonCenterXCons: NSLayoutConstraint!
    // 返回按钮
    @IBOutlet weak var returnButton: UIButton!
    
    
    /// 完成回调
    private var completionBlock:((clsName:String?)->())?
    
    /// 按钮数据数组
    private let buttonsInfo = [["imageName": "tabbar_compose_idea", "title": "文字", "clsName": "WBComposeViewController"],
                               ["imageName": "tabbar_compose_photo", "title": "照片/视频"],
                               ["imageName": "tabbar_compose_weibo", "title": "长微博"],
                               ["imageName": "tabbar_compose_lbs", "title": "签到"],
                               ["imageName": "tabbar_compose_review", "title": "点评"],
                               ["imageName": "tabbar_compose_more", "title": "更多", "actionName": "clickMore"],
                               ["imageName": "tabbar_compose_friend", "title": "好友圈"],
                               ["imageName": "tabbar_compose_wbcamera", "title": "微博相机"],
                               ["imageName": "tabbar_compose_music", "title": "音乐"],
                               ["imageName": "tabbar_compose_shooting", "title": "拍摄"]]
    
    class func composeTypeView() -> WBComposeTypeView{
        
        let nib = UINib(nibName: "WBComposeTypeView", bundle: nil)
        
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! WBComposeTypeView
        
        // XIB 加载默认是 600*600
        v.frame = UIScreen.main().bounds
        
        // 设置界面
        v.setupUI()
        
        return v
        
    }
    
    func show(completion:(clsName:String?)->()){
        
        // 记录闭包
        completionBlock = completion
        
        // 将当前视图添加到 根视图控制器的 View 上
        guard let vc = UIApplication.shared().keyWindow?.rootViewController else {
            return
        }
        
        // 添加视图
        vc.view.addSubview(self)
        
        // 执行动画
        showCurrentView()
        
        
    }
    
//    override func awakeFromNib() {
//        // 设置界面
//        setupUI()
//    }
    
    // MARK: - 监听方法
    @objc private func clickButton(button:WBComposeTypeButton){
        
        print("点我了")
        
        // 根据 contentOffset 判断当前显示的视图
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        let v = scrollView.subviews[page]
        
        for (i,btn) in v.subviews.enumerated() {
            
            // 缩放动画
            let scaleAnim:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewScaleXY)
            let scale = (button == btn) ? 2 : 0.2
            scaleAnim.toValue = NSValue(cgPoint: CGPoint(x: scale,y: scale))
            scaleAnim.duration = 0.5
            btn.pop_add(scaleAnim, forKey: nil)
            
            // 渐变动画
            let alphaAnim:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            
            alphaAnim.toValue = 0.2
            alphaAnim.duration = 0.5
            
            btn.pop_add(alphaAnim, forKey: nil)
            
            /// 判断都渐变完成
            if i == 0 {
                alphaAnim.completionBlock = { (_,_) in
                    // 完成回调
                    self.completionBlock?(clsName:button.clsName)
                }
            }
            
            
        }
        
        
    }
    
    /// 点击更多
    @objc private func clickMore(){
        //print("点击更多")
        
        // 将 scrollView 滚动到第二页
        let offset = CGPoint(x: scrollView.bounds.width, y: 0)
        scrollView.setContentOffset(offset, animated: true)
        
        // 让两个按钮分开
        returnButton.isHidden = false
        
        let margin = scrollView.bounds.width / 6
        closeButtonCenterXCons.constant += margin
        returnButtonCenterXCons.constant -= margin
        
        UIView.animate(withDuration: 0.25){
            // 更新布局
            self.layoutIfNeeded()
        }
        
    }
    
    /// 关闭视图
    @IBAction func close() {
        
        // 动画隐藏
        hidButton()
        
        //removeFromSuperview()
    }

    /// 点击返回按钮
    @IBAction func clickReturn() {
        
        // 将滚动视图,滚动到第一页
        scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
        
        // 合并两个按钮
        closeButtonCenterXCons.constant = 0
        returnButtonCenterXCons.constant = 0
        
        UIView.animate(withDuration: 0.25, animations: {
            // 更新布局
            self.layoutIfNeeded()
            self.returnButton.alpha = 0
            }) { (_) in
                self.returnButton.isHidden = true
                self.returnButton.alpha = 1
                
        }
        
    }
    
    
}

// MARK: - 动画方法扩展
private extension WBComposeTypeView{
    
    // MARK: - 消除动画
    private func hidButton(){
        
        // 根据 contentOffset 判断当前显示的视图
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        let v = scrollView.subviews[page]
        
        for (i,btn) in v.subviews.enumerated().reversed(){
            
            // 创建衰减动画
            let anim:POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            
            // 设置动画属性
            anim.fromValue = btn.center.y
            anim.toValue = btn.center.y + 350
            
            //设置动画时间
            anim.beginTime = CACurrentMediaTime() + CFTimeInterval(v.subviews.count - i) * 0.03
            
            // 添加动画
            btn.layer.pop_add(anim, forKey: nil)
            
            // 监听最后一个按钮的动画,最后一个执行
            if i == 0 {
                // 完成回调
                anim.completionBlock = {(_,_) in
                    // 隐藏视图
                    self.hideCurrentView()
                }
            }
            
        }
        
        
    }
    
    // 隐藏当前视图
    func hideCurrentView(){
        
        // 创建动画
        let anim:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        
        // 设置动画
        anim.fromValue = 1
        anim.toValue = 0
        anim.duration = 0.25
        
        // 添加到视图
        pop_add(anim, forKey: nil)
        
        // 完成动画后
        anim.completionBlock = { (_,_) in
            // 关闭视图
            self.removeFromSuperview()
        }
    }
    
    // MARK: - 显示动画
    // 动画显示当前视图
    func showCurrentView(){
        
        // 1.创建动画
        let anim:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        
        anim.fromValue = 0
        anim.toValue = 1
        anim.duration = 0.25
        
        // 添加到视图
        pop_add(anim, forKey: nil)
        
        // 添加按钮的动画
        self.showButtons()
        
        
    }
    
    // 弹力显示所有按钮
    private func showButtons(){
        
        // 获取 scrollView 的子视图 的第一个视图
        let v = scrollView.subviews[0]
        
        // 遍历 v 中的所有按钮
        for (i,btn) in v.subviews.enumerated(){
            
            // 创建动画
            let anim:POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            
            // 设置动画属性
            anim.fromValue = btn.center.y + 350
            anim.toValue = btn.center.y
            anim.springBounciness = 8 // 弹力效果
            anim.springSpeed = 6 // 弹力速度
            
            // 设置动画时间
            anim.beginTime = CACurrentMediaTime() + CFTimeInterval(i) * 0.03
            
            btn.pop_add(anim, forKey: nil)
            
        }
        
    }
    
    
}

// MARK: - 设置界面
private extension WBComposeTypeView{
    
    func setupUI(){
        
        // 0.强行更新布局
        layoutIfNeeded()
        
        // 向 scrollView 添加视图
        let rect = scrollView.bounds
        let width = scrollView.bounds.width
        for i in 0..<2 {
            let v = UIView(frame:rect.offsetBy(dx: CGFloat(i) * width, dy: 0))
            // 向 视图添加按钮
            addButtons(v: v, idx: i * 6)
            
            // 将视图添加到 scrollView
            scrollView.addSubview(v)
        }
        
        // 设置 scrollView 
        scrollView.contentSize = CGSize(width: 2 * width, height: 0)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        
        // 禁用滚动
        scrollView.isScrollEnabled = false
        
        
    }
    
    /// 向 v 中添加按钮,按钮的数据索引从 idx 开始
    private func addButtons(v:UIView,idx:Int){
        
        let count = 6
        // 从idx 开始,添加 6 个按钮
        for i in idx..<(idx + count) {
            
            if i >= buttonsInfo.count {
                break
            }
            
            // 0> 从数组字典中获取图像名称和 title 
            let dict = buttonsInfo[i]
            
            guard let imageName = dict["imageName"],
                    title = dict["title"] else{
                continue
            }
            
            // 创建按钮
            let btn = WBComposeTypeButton.composeTypeButton(imageName: imageName, title: title)
            
            v.addSubview(btn)
            
            // 添加监听方法
            if let actionName = dict["actionName"] {
                btn.addTarget(self, action: Selector(actionName), for: .touchUpInside)
            }else{
                btn.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
            }
            
            // 设置要展现的类名
            btn.clsName = dict["clsName"]
            
        }
        
        // 布局按钮,
        // 准备常量
        let btnCol = 3
        let btnSize = CGSize(width: 100, height: 100)
        let margin = (v.bounds.width - CGFloat(btnCol) * btnSize.width) / CGFloat(btnCol + 1)
        
        for (i,btn) in v.subviews.enumerated() {
            
            let y:CGFloat = (i > (btnCol - 1)) ? (v.bounds.height - btnSize.height) : 0
            
            let col = i % 3
            
            let x = CGFloat(col + 1) * margin + CGFloat(col) * btnSize.width
            
            btn.frame = CGRect(x: x, y: y, width: btnSize.width, height: btnSize.height)
        }
        
    }
    
}







