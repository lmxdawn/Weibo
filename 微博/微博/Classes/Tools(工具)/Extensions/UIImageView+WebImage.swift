//
//  UIImageView+WebImage.swift
//  微博
//
//  Created by lk on 16/9/8.
//  Copyright © 2016年 lk. All rights reserved.
//

import SDWebImage

extension UIImageView{
    
    
    /// 隔离 SDWebImage 设置图像函数
    /// 
    /// - parameter urlString: 路径
    /// - parameter placeholderImage : 占位图像
    /// - parameter isAvatar: 是否是头像
    func cz_setImage(urlString:String?,placeholderImage:UIImage?,isAvatar:Bool = false){
        
        // 处理URL
        guard let urlString = urlString,
                  url = URL(string: urlString) else{
            // 设置占位图像
            image = placeholderImage
            return
        }
       
        sd_setImage(with: url, placeholderImage: placeholderImage, options: [], progress: nil) { [weak self] (image, _, _, _) in
            
            // 完成回调 - 判断是否是头像
            if isAvatar{
                self?.image = image?.cz_avatarImage(size: self?.bounds.size)
            }
            
        }
        
        
    }
    
}
