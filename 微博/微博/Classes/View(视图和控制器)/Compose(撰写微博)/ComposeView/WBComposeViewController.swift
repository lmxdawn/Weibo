//
//  WBComposeViewController.swift
//  微博
//
//  Created by lk on 16/9/10.
//  Copyright © 2016年 lk. All rights reserved.
//

import UIKit
import SVProgressHUD

class WBComposeViewController: UIViewController {
    
    /// 文本编辑视图
    @IBOutlet weak var textView: WBComposeTextView!
    /// 底部工具栏
    @IBOutlet weak var toolbar: UIToolbar!
    /// 标题文本
    @IBOutlet var titleLabel: UILabel!
    /// 底部工具栏底部约束
    @IBOutlet weak var toolbarBottomCons: NSLayoutConstraint!
    
    /// 表情输入视图
    lazy var emoticonView:CZEmoticonInputView = CZEmoticonInputView.inputView { [weak self] (emoticon) in
        
        self?.textView.insertEmoticon(em: emoticon)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置界面
        setupUI()
        
        // 监听键盘通知
        NotificationCenter.default().addObserver(self,
                                                 selector: #selector(keyboardChanged),
                                                 name: Notification.Name.UIKeyboardWillChangeFrame,
                                                 object: nil)
        
        // 监听文本框的通知
//        NotificationCenter.default().addObserver(self, selector: #selector(textChanged), name: Notification.Name.UITextViewTextDidChange, object: textView)
        
    }

    deinit {
        
        // 注销通知
        NotificationCenter.default().removeObserver(self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 激活键盘
        
        textView.becomeFirstResponder()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 关闭键盘
        textView.resignFirstResponder()
        
        
    }
    
    // 发布按钮
    lazy var sendButton:UIButton = {
       
        let btn = UIButton()
        btn.setTitle("发布", for: [])
        // 设置颜色
        btn.setTitleColor(UIColor.white(), for: [])
        btn.setTitleColor(UIColor.gray(), for: .disabled)
        // 设置图片
        btn.setBackgroundImage(UIImage(named:"common_button_orange"), for: [])
        btn.setBackgroundImage(UIImage(named:"common_button_orange_highlighted"), for: .highlighted)
        btn.setBackgroundImage(UIImage(named:"common_button_white_disable"), for: .disabled)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        btn.frame = CGRect(x: 0, y: 0, width: 45, height: 35)
        btn.addTarget(self, action: #selector(postStatus), for: .touchUpInside)
        
        return btn
        
    }()
    
    
    
}




// MARK: - 监听方法
private extension WBComposeViewController{
    
    // 发布微博
    @objc func postStatus(){
        
        //微博文字
        
        let status = textView.emoticonText
        
        // 有图片
        var image:UIImage? = nil
        
        WBNetworkManager.shared.postStuatus(status: status,image:image) { (result, isSuccess) in
            
            //print(result)
            
            let message = isSuccess ? "发送成功" : "网络不给力"
            
            SVProgressHUD.setDefaultStyle(.dark)
            SVProgressHUD.showInfo(withStatus: message)
            
            // 成功,延迟关闭当前窗口
            if isSuccess{
                
                DispatchQueue.main.after(when: DispatchTime.now() + 1, execute: {
                    
                    // 恢复样式
                    SVProgressHUD.setDefaultStyle(.light)
                    // 关闭
                    self.close()
                    
                })
                
            }
            
        }
        
        
    }
    
    // 返回
    @objc func close(){
        
        dismiss(animated: true, completion: nil)
        
        
    }
    
    // 键盘通知方法
    @objc func keyboardChanged(n:Notification){
        
        //print(n.userInfo)
        
        // 目标 rect
        guard let rect = (n.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue(),
            duration = (n.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else{
            return
        }
        
        
        // 设置底部工具栏的底部约束高度
        let offSet = view.bounds.height - rect.origin.y
        
        toolbarBottomCons.constant = offSet
        
        UIView.animate(withDuration: duration) { 
            self.view.layoutIfNeeded()
        }
        
        
    }
    
    /// 文本视图的文本发生变化
//    @objc private func textChanged(n:Notification){
//        
//        // 如果有文本
//        sendButton.isEnabled = textView.hasText()
//        
//        
//        
//    }
    
    
    /// 切换表情键盘
    @objc private func emoticonKeyboard(){
        
        // 测试的键盘视图
//        let keyboardView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 200))
//        keyboardView.backgroundColor = UIColor.cz_random()
        
        
        // 设置键盘视图
        textView.inputView = (textView.inputView == nil) ? emoticonView : nil
        
        // 刷新键盘视图
        textView.reloadInputViews()
        
        
    }
    
    
}

// MARK: - UITextViewDelegate 代理
extension WBComposeViewController:UITextViewDelegate{
    
    // 文本视图文字发生变化
    func textViewDidChange(_ textView: UITextView) {
        
        sendButton.isEnabled = textView.hasText()
        
    }
    
}


// MARK: - 设置界面
private extension WBComposeViewController{
    
    // 设置界面
    func setupUI(){
        
        //view.backgroundColor = UIColor.cz_random()
        
        // 设置文本框的代理
        textView.delegate = self
        
        // 设置导航栏
        setupNavigationBar()
        
        // 设置toolBar
        setupToolBar()
        
    }
    
    // 设置toolBar
    func setupToolBar(){
        
        
        let itemSettings = [["imageName": "compose_toolbar_picture"],
                            ["imageName": "compose_mentionbutton_background"],
                            ["imageName": "compose_trendbutton_background"],
                            ["imageName": "compose_emoticonbutton_background", "actionName": "emoticonKeyboard"],
                            ["imageName": "compose_add_background"]]
        
        // 遍历
        var items = [UIBarButtonItem]()
        for s in itemSettings {
            
            guard let imageName = s["imageName"] else{
                continue
            }
            let image = UIImage(named: imageName)
            let imageHL = UIImage(named: imageName + "_highlighted")
            let btn = UIButton()
            btn.setImage(image, for: [])
            btn.setImage(imageHL, for: .highlighted)
            // 调整大小
            btn.sizeToFit()
            
            // 判断 actionName
            if let actionName = s["actionName"] {
                // 给按钮添加方法
                btn.addTarget(self, action: Selector(actionName), for: .touchUpInside)
            }
            
            items.append(UIBarButtonItem(customView: btn))
            
            // 追加弹簧
            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
            
        }
        // 删除末尾的弹簧
        items.removeLast()
        
        toolbar.items = items
        
    }
    
    // 设置导航栏
    func setupNavigationBar(){
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", target: self, action: #selector(close))
        
        // 发送按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sendButton)
        
        sendButton.isEnabled = false
        
        // 标题文本
        navigationItem.titleView = titleLabel
        
    }
    
}











