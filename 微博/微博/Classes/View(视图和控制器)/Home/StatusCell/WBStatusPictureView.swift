//
//  WBStatusPictureView.swift
//  微博
//
//  Created by lk on 16/9/8.
//  Copyright © 2016年 lk. All rights reserved.
//

import UIKit


/// 配图视图
class WBStatusPictureView: UIView {
    
    var viewModel:WBStatusViewModel?{
        didSet{
            // 修改视图约束
            calcViewSize()
            /// 配图视图的数组
            urls = viewModel?.picURLs
        }
    }
    
    // 根据视图模型的配图大小,调整显示内容
    private func calcViewSize(){
        
        // 处理宽度
        // 1> 单图,根据配图的大小,修改 subviews[0] 的宽高
        if viewModel?.picURLs?.count == 1 {
            
            let viewSize = viewModel?.pictureViewSize ?? CGSize()
            
            // 获取第0张图像视图
            let v = subviews[0]
            v.frame = CGRect(x: 0, y: WBStatusPictureViewOutterMargin, width: viewSize.width, height: viewSize.height - WBStatusPictureViewOutterMargin)
            
        }else{
            // 2> 多图, 恢复 subviews[0] 的宽高
            // 获取第0张图像视图
            let v = subviews[0]
            v.frame = CGRect(x: 0, y: WBStatusPictureViewOutterMargin, width: WBStatusPictureItemWidth, height: WBStatusPictureItemHeight)
        }
        
        
        //修改高度约束
        heightCons.constant = viewModel?.pictureViewSize.height ?? 0
    }
    
    // 配图视图数组
    private var urls:[WBStatusPicture]?{
        didSet{
            
            // 1.隐藏所有的 ImageView
            for v in subviews{
                v.isHidden = true
            }
            
            // 2.遍历 urls 数组,顺序设置图像
            var index = 0
            for url in urls ?? []{
                
                // 获取对应索引的 imageView
                let iv = subviews[index] as! UIImageView
                
                // 4张图像时候的处理
                if index == 1 && urls?.count == 4 {
                    index += 1
                }
                // 设置图像
                iv.cz_setImage(urlString: url.thumbnail_pic, placeholderImage: nil)
                // 显示图像
                iv.isHidden = false
                
                index +=  1
            }
            
        }
    }
    
    /// 配图视图高度
    @IBOutlet weak var heightCons: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        
        // 设置界面
        setupUI()
        
    }

}

// MARK: - 设置界面
extension WBStatusPictureView{
    
    
    
    // 1.Cell 中所有的控件都是提前准备好
    // 2. 设置的时候,根据数据决定是否显示
    // 3.不要动态创建控件
    private func setupUI(){
        
        // 设置背景颜色
        backgroundColor = superview?.backgroundColor
        
        // 超出边界的内容不显示
        clipsToBounds = true
        
        let rect = CGRect(x: 0, y: WBStatusPictureViewOutterMargin, width: WBStatusPictureItemWidth, height: WBStatusPictureItemHeight)
        
        for i in 0..<WBStatusPictureViewMaxCount{
            
            let iv = UIImageView()
            
            // 设置 contentMode
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            
            // 行 -> Y
            let row = CGFloat(i / WBStatusPictureViewCols)
            // 列 -> X
            let col = CGFloat(i % WBStatusPictureViewCols)
            
            let xOffset = col * (WBStatusPictureItemWidth + WBStatusPictureViewInnerMargin)
            let yOffset = row * (WBStatusPictureItemHeight + WBStatusPictureViewInnerMargin)
            
            iv.frame = rect.offsetBy(dx: xOffset, dy: yOffset)
            
            addSubview(iv)
            
        }
        
    }
    
}
