//
//  WeiBoCommon.swift
//  微博
//
//  Created by lk on 16/9/5.
//  Copyright © 2016年 lk. All rights reserved.
//

import Foundation


// MARK: - 应用程序信息
// 应用程序 ID
let WBAppKey = "564358851"
// 应用程序加密信息(开发者可以修改)
let WBAppSecret = "98b0adaf40ceb5965049c17d42758081"
// 回调地址
let WBRedirectURI = "http://baidu.com"


// MARK: - 全局通知定义
//用户登录通知
let WBUserShouldLoginNotification = "WBUserShouldLoginNotification"

// 用户登录成功通知
let WBUserLoginSuccessNotification = "WBUserLoginSuccessNotification"

// MARK: - 微博配图视图常量
// 最多显示多少个ImageView
let WBStatusPictureViewMaxCount = 9
// 列数
let WBStatusPictureViewCols = 3
// 配图视图外侧的间距
let WBStatusPictureViewOutterMargin = CGFloat(12)
// 配图视图内部图像视图的间距
let WBStatusPictureViewInnerMargin = CGFloat(3)
// 配图视图的宽度
let WBStatusPictureViewWidth = UIScreen.main().bounds.width - 2 * WBStatusPictureViewOutterMargin
// 每个 Item 默认的宽度
let WBStatusPictureItemWidth = (WBStatusPictureViewWidth - (CGFloat(WBStatusPictureViewCols) - 1) * WBStatusPictureViewInnerMargin) / CGFloat(WBStatusPictureViewCols)
//
let WBStatusPictureItemHeight = WBStatusPictureItemWidth


