//
//  CZSQLiteManager.swift
//  数据库
//
//  Created by lk on 16/9/13.
//  Copyright © 2016年 lk. All rights reserved.
//

import Foundation
import FMDB

// 最大数据库缓存时间
private let maxDBCacheTime:TimeInterval = -60 //-5 * 24 * 60 * 60

/// SQLite 管理器

/**
 1.数据库本质上是保存在沙盒中的一个文件,首先需要创建并且打开数据库
   FMDB - 队列
 2.创建数据表
 3.做增删改查
 */

class CZSQLiteManager {
    
    // 单例,全局数据库工具访问点
    static let shared = CZSQLiteManager()
    
    /// 数据库队列
    let queue:FMDatabaseQueue
    
    // 构造函数
    private init(){
        
        /// 数据库路径
        let dbName = "status.db"
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        path = (path as NSString).appendingPathComponent(dbName)
        
        print("数据库路径:" + path)
        // 创建数据库队列
        queue = FMDatabaseQueue(path: path)
        
        // 打开数据库
        createTable()
        
        // 注册通知 - 应用程序进入后台
        NotificationCenter.default().addObserver(self,
                                                 selector: #selector(clearDBCache),
                                                 name: Notification.Name.UIApplicationDidEnterBackground,
                                                 object: nil)
        
    }
    
    deinit {
        // 注销通知
        NotificationCenter.default().removeObserver(self)
    }
    
    // 清理缓存
    @objc private func clearDBCache(){
        
        let dateString = Date.cz_dateString(delta: maxDBCacheTime)
        
        let sql = "DELETE FROM T_Status WHERE createTime < ?"
        
        // 执行
        queue.inDatabase { (db) in
            
            if db?.executeUpdate(sql, withArgumentsIn: [dateString]) == true{
                
                print("删除了多少条 \(db?.changes()) 条记录")
            }
            
        }
        
        
    }
    
    
}

// MARK: - 微博数据库操作
extension CZSQLiteManager{
    
    
    func loadStatus(userId:String, since_id:Int64 = 0,max_id:Int64 = 0) -> [[String:AnyObject]]{
        
        // 准备SQL
        var sql = "SELECT * FROM T_Status \n"
        sql += "WHERE 1 == 1 \n"
        sql += " AND userId = \(userId) \n"
        if since_id > 0 {
            sql += " AND statusId > \(since_id) \n"
        }else if max_id > 0{
            sql += " AND statusId < \(max_id) \n"
        }
        
        sql += " ORDER BY statusId DESC \n"
        sql += " LIMIT 20 \n"
        sql += ";"
        
        // 执行SQL
        //print(sql)
        let array = execRecordSet(sql: sql)
        
        // 遍历数组,将数组中的 status 反序列化 -> 字典数组
        var result = [[String:AnyObject]]()
        for dict in array {
            
            guard let jsonData = dict["status"] as? Data,
            json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String:AnyObject] else{
                continue
            }
            
            // 追加到数组
            result.append(json ?? [:])
            
            
        }
        
        return result
    }
    
    /// 新增或者修改微博数据,微博数据在刷新的时候,可能会出现重叠
    func updateStatus(userId:String,array:[[String:AnyObject]]){
        
        // 1.准备sql
        let sql = "INSERT OR REPLACE INTO T_Status (statusId,userId,status) VALUES (?,?,?)"
        
        // 2.执行sql
        queue.inTransaction { (db, rollback) in
            // 遍历数组,逐条插入微博数据
            for dict in array{
                
                // 将字典序列化成二进制数据
                guard let statusId = dict["idstr"] as? String,
                    jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) else{
                    
                    continue
                }
                
                // 执行sql
                if db?.executeUpdate(sql, withArgumentsIn: [statusId,userId,jsonData]) == false{
                    
                    //需要回滚
                    rollback?.pointee = true
                    
                    break
                }
                
                
            }
            
        }
        
    }
    
}


// MARK: - 创建数据表以及其他私有方法
private extension CZSQLiteManager{
    
    /// 执行一个 SQL,返回一个字典数组
    func execRecordSet(sql:String) -> [[String:AnyObject]]{
        
        var result = [[String:AnyObject]]()
        
        // 查询数据,不需要开启事务
        queue.inDatabase { (db) in
            
            guard let rs = db?.executeQuery(sql, withArgumentsIn: []) else{
                return
            }
            
            // 逐行 - 遍历结果集
            while rs.next() {
                
                // 列数
                let colCount = rs.columnCount()
                
                // 遍历所有列
                for col in 0..<colCount{
                    
                    // 列名 -> KEY / 值 -> Value
                    guard let name = rs.columnName(for: col),
                        value = rs.object(forColumnIndex: col) else{
                        continue
                    }
                    
                    // 追加结果
                    result.append([name:value])
                }
                
                
            }
            
        }
        
        return result
        
    }
    
    
    // 创建数据表
    func createTable(){
        
        // 1.SQL
        guard let path = Bundle.main().pathForResource("status.sql", ofType: nil),
               sql = try? String(contentsOfFile: path) else{
            return
        }
        
        //print(sql)
        
        // 2.执行SQL
        queue.inDatabase { (db) in
            
            if db?.executeStatements(sql) == true{
                print("创表成功")
            }else{
                print("创表失败")
            }
            
        }
        
        
    }
    
}










