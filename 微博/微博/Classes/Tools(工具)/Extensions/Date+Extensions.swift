//
//  Date+Extensions.swift
//  微博
//
//  Created by lk on 16/9/13.
//  Copyright © 2016年 lk. All rights reserved.
//

import Foundation


// 日期格式格式化器
private let dateFormatter = DateFormatter()

/// 当前日历对象
private let calendar = Calendar.current()

extension Date{
    
    /// 计算与当前系统时间偏差 delta 秒数的日期字符串
    /// 在 Swift中,如果要定义结构体的 '类' 函数,使用 static 修饰 -> 静态函数
    static func cz_dateString(delta:TimeInterval) -> String{
        
        let date = Date(timeIntervalSinceNow: delta)
        
        // 指定日期格式
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.string(from: date)
        
    }
    
    
    /// 将新浪格式的字符串转换成日期
    ///
    /// - parameter string: Tue Sep 15 12:12:00 +0800 2015
    ///
    /// - returns: 日期
    static func cz_sinaDate(string: String) -> Date? {
        
        // 1. 设置日期格式
        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
        
        // 2. 转换并且返回日期
        return dateFormatter.date(from: string)
    }
    
    /**
     刚刚(一分钟内)
     X分钟前(一小时内)
     X小时前(当天)
     昨天 HH:mm(昨天)
     MM-dd HH:mm(一年内)
     yyyy-MM-dd HH:mm(更早期)
     */
    var cz_dateDescription: String {
        
        // 1. 判断日期是否是今天
        if calendar.isDateInToday(self) {
            
            let delta = -Int(self.timeIntervalSinceNow)
            
            if delta < 60 {
                return "刚刚"
            }
            
            if delta < 3600 {
                return "\(delta / 60) 分钟前"
            }
            
            return "\(delta / 3600) 小时前"
        }
        
        // 2. 其他天
        var fmt = " HH:mm"
        
        if calendar.isDateInYesterday(self) {
            fmt = "昨天" + fmt
        } else {
            fmt = "MM-dd" + fmt
            
            let year = calendar.component(.year, from: self)
            let thisYear = calendar.component(.year, from: Date())
            
            if year != thisYear {
                fmt = "yyyy-" + fmt
            }
        }
        
        // 设置日期格式字符串
        dateFormatter.dateFormat = fmt
        
        return dateFormatter.string(from: self)
    }
    
    
    
    /**
        时间转化为时间戳
        :param: stringTime 时间为stirng
         
        :returns: 返回时间戳为stirng
     */
    static func stringToTimeStamp(stringTime:String,dateFormat:String = "yyyy-MM-dd")->String {
        
        dateFormatter.dateFormat=dateFormat
        let date = dateFormatter.date(from: stringTime)
        
        let dateStamp:TimeInterval = date!.timeIntervalSince1970
        
        let dateSt:Int = Int(dateStamp)
        
        return String(dateSt)
        
    }
    
    /**
        时间戳转时间
        :param: timeStamp 时间戳
     
        :returns: return time
     */
    static func timeStampToString(timeStamp:String,dateFormat:String = "yyyy-MM-dd")->String {
        
        let string = NSString(string: timeStamp)
        
        let timeSta:TimeInterval = string.doubleValue
        
        dateFormatter.dateFormat=dateFormat
        
        let date = NSDate(timeIntervalSince1970: timeSta)
        
        return dateFormatter.string(from: date as Date)
    }
    
    
    
    
}
