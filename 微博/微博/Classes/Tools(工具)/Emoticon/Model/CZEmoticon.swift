//
//  CZEmoticon.swift
//  004-表情包数据
//
//  Created by apple on 16/7/10.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit
import YYModel

/// 表情模型
class CZEmoticon: NSObject {

    /// 表情类型 false - 图片表情 / true - emoji
    var type = false
    /// 表情字符串，发送给新浪微博的服务器(节约流量)
    var chs: String?
    /// 表情图片名称，用于本地图文混排
    var png: String?
    /// emoji 的十六进制编码
    var code: String? {
        didSet {
            
            guard let code = code else {
                return
            }
            
            let scanner = Scanner(string: code)
            
            var result: UInt32 = 0
            scanner.scanHexInt32(&result)
            
            emoji = String(Character(UnicodeScalar(result)))
        }
    }
    /// 表情使用次数
    var times: Int = 0
    /// emoji 的字符串
    var emoji: String?
    
    /// 表情模型所在的目录
    var directory: String?
    
    /// `图片`表情对应的图像
    var image: UIImage? {
        
        // 判断表情类型
        if type {
            return nil
        }
        
        guard let directory = directory,
            png = png,
            path = Bundle.main().pathForResource("HMEmoticon.bundle", ofType: nil),
            bundle = Bundle(path: path)
            else {
                return nil
        }
    
        return UIImage(named: "\(directory)/\(png)", in: bundle, compatibleWith: nil)
    }
    
    /// 将当前的图像转换生成图片的属性文本
    func imageText(font: UIFont) -> AttributedString {
        
        // 1. 判断图像是否存在
        guard let image = image else {
            return AttributedString(string: "")
        }
        
        // 2. 创建文本附件
        let attachment = CZEmoticonAttachment()
        
        // 记录属性文本文字
        attachment.chs = chs
        
        attachment.image = image
        let height = font.lineHeight
        attachment.bounds = CGRect(x: 0, y: -4, width: height, height: height)
        
        // 3. 返回图片属性文本
        let attrStrM = NSMutableAttributedString(attributedString: AttributedString(attachment: attachment))
        
        // 设置字体属性
        attrStrM.addAttributes([NSFontAttributeName: font], range: NSRange(location: 0, length: 1))
        
        // 4. 返回属性文本
        return attrStrM
    }
    
    override var description: String {
        return yy_modelDescription()
    }
}
