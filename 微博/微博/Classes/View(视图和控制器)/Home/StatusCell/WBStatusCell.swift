//
//  WBStatusCell.swift
//  微博
//
//  Created by lk on 16/9/8.
//  Copyright © 2016年 lk. All rights reserved.
//

import UIKit


/// 微博 Cell 的协议
/// 如果需要设置可选协议方法
/// - 需要遵守 NSObjectProtocol 协议
/// - 协议需要时 @objc 的
/// - 方法需要 @objc optional
@objc protocol WBStatusCellDelegate:NSObjectProtocol{
    
    // 微博 Cell 选中URL 字符串
    @objc optional func statusCellDidSelectURLString(cell:WBStatusCell, urlString: String)
    
}


class WBStatusCell: UITableViewCell {
    
    // 代理属性
    weak var delegate:WBStatusCellDelegate?
    
    /// 微博视图模型
    var viewModel:WBStatusViewModel?{
        didSet{
            
            // 微博模型
            let status = viewModel?.status
            // 用户模型
            let user = status?.user
            
            // 微博文本
            statusLabel?.attributedText = viewModel?.statusAttrText
            /// 设置被转发微博的文字
            retweetedLabel?.attributedText = viewModel?.retweetedAttrText
            
            // 昵称
            nameLabel.text = user?.screen_name
            
            // 设置会员图标
            memberIconView.image = viewModel?.memberIcon
            
            // 设置认证图标
            vipIconView.image = viewModel?.vipIcon
            
            // 设置头像
            iconView.cz_setImage(urlString: user?.profile_image_url, placeholderImage: UIImage(named: "avatar_default_big"),isAvatar: true)
            
            ///设置配图视图
            pictureView.viewModel = viewModel
            /// 配图视图的高度
            //pictureView.heightCons.constant = viewModel?.pictureViewSize.height ?? 0
            /// 配图视图的数组
//            //测试4张
//            if status?.pic_urls?.count > 4 {
//                var picUrls = viewModel!.status.pic_urls!
//                picUrls.removeSubrange((picUrls.startIndex + 4)..<picUrls.endIndex)
//                pictureView.urls = picUrls
//            }else{
//                pictureView.urls = status?.pic_urls
//            }
            //pictureView.urls = viewModel?.picULs
            
            /// 设置底部工具栏
            toolBarView.viewModel = viewModel
            
         
            
            /// 设置来源
            sourceLabel.text = status?.source
            
            
        }
    }
    
    /// 头像
    @IBOutlet weak var iconView: UIImageView!
    /// 姓名
    @IBOutlet weak var nameLabel: UILabel!
    /// 会员图标
    @IBOutlet weak var memberIconView: UIImageView!
    /// 时间
    @IBOutlet weak var timeLabel: UILabel!
    /// 来源
    @IBOutlet weak var sourceLabel: UILabel!
    /// 认证
    @IBOutlet weak var vipIconView: UIImageView!
    /// 微博正文
    @IBOutlet weak var statusLabel: FFLabel!
    /// 配图视图
    @IBOutlet weak var pictureView: WBStatusPictureView!
    
    /// 底部工具栏
    @IBOutlet weak var toolBarView: WBStatusToolBar!
    
    /// 被转发微博的文字
    @IBOutlet weak var retweetedLabel: FFLabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 离屏渲染 - 异步加载
        self.layer.drawsAsynchronously = true
        
        // 栅格化 - 异步绘制之后,会生成一张独立的图像,cell在屏幕上滚动的时候,本质上滚动的是这张图片
        // cell 优化,要尽量减少图层的数量,相当于就只有一层
        // 停止滚动之后,可以接收监听
        self.layer.shouldRasterize = true
        
        // 使用 '栅格化' 必须指定分辨率
        self.layer.rasterizationScale = UIScreen.main().scale
        
        // 设置微博文本代理
        statusLabel.delegate = self
        retweetedLabel?.delegate = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


// MARK: - 代理
extension WBStatusCell:FFLabelDelegate{
    
    // 点击文字
    func labelDidSelectedLinkText(label: FFLabel, text: String) {
        
        // 判断是否是 URL
        if text.hasPrefix("http://") {
            delegate?.statusCellDidSelectURLString?(cell: self, urlString: text)
        }
        
        
    }
    
}



