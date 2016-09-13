//
//  String+Extenstions.swift
//  正则初体验
//
//  Created by lk on 16/9/11.
//  Copyright © 2016年 lk. All rights reserved.
//

import Foundation

extension String{
    
    /// 从当前字符串中,提取链接和文本
    /// Swift 提供了 '元组' 同时返回多个值
    func cz_href() -> (link:String, text: String)?{
        
        
        // 1.正则表达式
        // a.pattern - 匹配方案
        let pattern = "<a href=\"(.*?)\" rel=\"nofollow\">(.*?)</a>"
        
        // b.创建正则表达式,如果 pattern 失败,抛出异常
        guard let regx = try? RegularExpression(pattern: pattern, options: []),
            result = regx.firstMatch(in: self, options: [], range: NSRange(location: 0, length: characters.count)) else {
            return nil
        }
        
        
        // 2.result 中有两个重要的方法
        // result.numberOfRanges -> 查找到的范围数量
        // result.range(at: idx) -> 指定 '索引' 位置的范围
        let link = (self as NSString).substring(with: result.range(at: 1))
        let text = (self as NSString).substring(with: result.range(at: 2))
        
        return (link,text)
        
    }
    
}
