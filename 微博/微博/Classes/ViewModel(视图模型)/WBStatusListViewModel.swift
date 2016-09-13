//
//  WBStatusListViewModel.swift
//  微博
//
//  Created by lk on 16/9/5.
//  Copyright © 2016年 lk. All rights reserved.
//

import Foundation

import SDWebImage


/// 微博数据列表视图模型

class WBStatusListViewModel {
    
    /// 微博视图模型数组懒加载
    lazy var statusList = [WBStatusViewModel]()
    
    
    /// 加载微博列表
    func loadStatus(pullup:Bool,completion:(isSuccess:Bool)->()){
        
        //取出第一条
        let since_id = pullup ? 0 :(statusList.first?.status.id ?? 0)
        
        // 上拉刷新 最后一个微博 id
        let max_id = !pullup ? 0 :(statusList.last?.status.id ?? 0)
        
        
        WBNetworkManager.shared.statusList(since_id: since_id,max_id: max_id) { (list, isSuccess) in
            
            // 判断网络请求是否成功
            if !isSuccess{
                // 回调返回
                completion(isSuccess: false)
                return
            }
            
            //字典转模型
            // 定义结果可变数组
            var array = [WBStatusViewModel]()
            
            // 遍历服务器返回的字典数组,字典转模型
            for dict in list ?? []{
                // 创建微博模型
                guard let model = WBStatus.yy_model(with: dict) else{
                    continue
                }
                // 将 model 添加到数组
                array.append(WBStatusViewModel(model: model))
            }
            
//            guard let array = NSArray.yy_modelArray(with: WBStatus.self, json: list ?? []) as? [WBStatus] else{
//                //完成回调
//                completion(isSuccess: isSuccess)
//                return
//            }
            
            // 拼接数据
            if pullup{
                // 上拉刷新,应该讲结果数组拼接在数组最后面
                self.statusList += array

            }else{
                
                // 下拉刷新,应该讲结果数组拼接在数组前面
                self.statusList = array + self.statusList
            }
            
            if array.count != 0 {
                self.cacheSingleImage(list: array,completion: completion)
                
            }else{
                
                //没有数据完成回调
                completion(isSuccess: false)
            }
            
            
        }
        
    }
    
    /// 缓存本次下载微博数据数组中的单张图像
    ///
    /// - parameter list:本次下载的视图模型数组
    private func cacheSingleImage(list:[WBStatusViewModel],completion:(isSuccess:Bool)->()){
        
        // 调度组
        let group = DispatchGroup()
        
        // 记录数据长度
        var length = 0
        // 遍历数组,查找微博数据数组中有单张图像的,进行缓存
        for vm in list {
            // 判断图像数量
            if vm.picURLs?.count != 1 {
                continue
            }
            
            // 获取图像模型
            guard let pic = vm.picURLs?[0].thumbnail_pic,
                url = URL(string: pic) else{
                continue
            }
            
            // 下载图像
            // a.downloadImage 是 SDWebImage 的核心方法
            // b.图像下载完成之后,会自动保存在沙盒中,文件路径是 url 的md5
            // c.如果沙盒中已经存在的缓存的图像,后续使用 SD 通过 URL 加载图像,都会加载本地沙盒的图像
            // d.不会发起网络请求,同时,回调方法,同样会调用
            // e.方法还是同样的方法,调用还是同样的调用,不过内部不会再次发起网络请求!
            // *** 注意点:如果缓存的图像累计很大,要找后台要接口
            // A>入组
            group.enter()
            
            SDWebImageManager.shared().downloadImage(with: url, options: [], progress: nil, completed: { (image, _, _, _, _) in
                
                if let image = image,data = UIImagePNGRepresentation(image){
                    
                    // NSData 是 length 属性
                    length += data.count
                    
                    // 图像缓存成功,更新视图大小
                    vm.updateSingleImageSize(image: image)
                }
                // B>出租
                group.leave()
            })
            
        }
        
        // C>监听调度组情况
        group.notify(queue: DispatchQueue.main){
            print("图像缓存完成\(length / 1024)")
            
            completion(isSuccess: true)
            
        }
        
    }
    
}
