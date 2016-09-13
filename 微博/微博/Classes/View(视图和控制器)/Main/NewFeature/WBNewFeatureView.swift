//
//  WBNewFeatureView.swift
//  微博
//
//  Created by lk on 16/9/7.
//  Copyright © 2016年 lk. All rights reserved.
//

import UIKit


/// 新特性视图
class WBNewFeatureView: UIView {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!

    //进入微博
    @IBAction func enterStatus() {
        // 删除视图
        removeFromSuperview()
        
    }
    
    class func newFeatureView() -> WBNewFeatureView{
    
        let nib = UINib(nibName: "WBNewFeatureView", bundle: nil)
        
        let vc = nib.instantiate(withOwner: nil, options: nil)[0] as! WBNewFeatureView
        
        // 从 XIB 加载的视图 ,默认是 600*600
        vc.frame = UIScreen.main().bounds
        

        return vc
    
    }
    
    override func awakeFromNib() {
        
        // 添加4个图像视图
        let count = 4
        let rect = UIScreen.main().bounds
        for i in 0..<count{
            let imageName = "new_feature_\(i + 1)"
            let iv = UIImageView(image: UIImage(named: imageName))
            
            //设置大小
            iv.frame = rect.offsetBy(dx: CGFloat(i) * rect.width, dy: 0)
            
            scrollView.addSubview(iv)
            
        }
        
        // 指定 scrollView 的属性
        scrollView.contentSize = CGSize(width: CGFloat(count + 1) * rect.width, height: rect.height)
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        //设置代理
        scrollView.delegate = self
        
        //隐藏按钮
        enterButton.isHidden = true
        
        // 禁止分页控件交互
        pageControl.isUserInteractionEnabled = false
        
    }

}

// MARK: - UIScrollViewDelegate代理
extension WBNewFeatureView:UIScrollViewDelegate{
    
    // 滚动
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        // 滚动到最后一屏 ,让视图删除
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        
        // 判断是否是最后一页
        if page == scrollView.subviews.count {
            print("欢迎")
            //删除视图
            removeFromSuperview()
            
        }
        
        // 如果滚动到倒数第二页
        enterButton.isHidden = (page != scrollView.subviews.count - 1)
        
        
    }
    
    //当前的偏移量
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 一旦滚动隐藏按钮
        enterButton.isHidden = true
        
        // 计算偏移量
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width + 0.5)
        
        // 设置分页控件
        pageControl.currentPage = page
        
        // 分页控件的隐藏
        pageControl.isHidden = (page == scrollView.subviews.count)
        
    }
    
    
}



