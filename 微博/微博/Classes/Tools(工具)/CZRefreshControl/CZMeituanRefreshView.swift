//
//  CZMeituanRefreshView.swift
//  自定义刷新控件
//
//  Created by lk on 16/9/10.
//  Copyright © 2016年 lk. All rights reserved.
//

import UIKit

class CZMeituanRefreshView: CZRefreshView {

    // 背景房子
    @IBOutlet weak var buildingIconView: UIImageView!
    // 地球
    @IBOutlet weak var earthIconVIew: UIImageView!
    // 小袋鼠
    @IBOutlet weak var kangarooIconView: UIImageView!
    
    // 父视图高度
    override var parentViewHeight: CGFloat{
        didSet{
            
            if parentViewHeight < 23 {
                return
            }
            // 高度差 / 最大高度
            var scale:CGFloat
            if parentViewHeight > 126 {
                scale = 1
            }else{
                scale = 1 - (126 - parentViewHeight) / (126 - 23)
            }
            
            kangarooIconView.transform = CGAffineTransform(scaleX: scale, y: scale)
            
        }
    }
    
    override func awakeFromNib() {
        
        // 房子
        let bImage1 = #imageLiteral(resourceName: "icon_building_loading_1")
        let bImage2 = #imageLiteral(resourceName: "icon_building_loading_2")
        
        buildingIconView.image = UIImage.animatedImage(with: [bImage1,bImage2], duration: 0.5)
        
        
        // 地球
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        
        anim.toValue = -2 * M_PI
        anim.repeatCount = MAXFLOAT
        anim.duration = 3
        anim.isRemovedOnCompletion = false
        
        earthIconVIew.layer.add(anim, forKey: nil)
        
        // 袋鼠
        // //设置动画
        let kImage1 = #imageLiteral(resourceName: "icon_small_kangaroo_loading_1")
        let kImage2 = #imageLiteral(resourceName: "icon_small_kangaroo_loading_2")
        kangarooIconView.image = UIImage.animatedImage(with: [kImage1,kImage2], duration: 0.5)
        
        // a.设置锚点
        kangarooIconView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        // b.设置 center
        let x = self.bounds.width * 0.5
        let y = self.bounds.height - 23
        kangarooIconView.center = CGPoint(x: x, y: y)
        
        kangarooIconView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        
        
    }
    

}
