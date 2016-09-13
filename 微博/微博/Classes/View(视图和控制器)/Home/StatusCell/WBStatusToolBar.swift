//
//  WBStatusToolBar.swift
//  微博
//
//  Created by lk on 16/9/8.
//  Copyright © 2016年 lk. All rights reserved.
//

import UIKit

class WBStatusToolBar: UIView {
    
    // 微博视图模型
    var viewModel:WBStatusViewModel?{
        didSet{
//            // 转发
//            retweetButton.setTitle("\(status?.reposts_count)", for: [])
//            // 评论
//            commentButton.setTitle("\(status?.comments_count)", for: [])
//            // 点赞
//            likeButton.setTitle("\(status?.attitudes_count)", for: [])
            
            // 转发
            retweetButton.setTitle(viewModel?.retweetedStr, for: [])
            // 评论
            commentButton.setTitle(viewModel?.commentStr, for: [])
            // 点赞
            likeButton.setTitle(viewModel?.likeStr, for: [])
            
        }
    }
    
    /// 转发
    @IBOutlet weak var retweetButton: UIButton!
    /// 评论
    @IBOutlet weak var commentButton: UIButton!
    /// 赞
    @IBOutlet weak var likeButton: UIButton!
    
}
