//
//  WBDemoViewController.swift
//  微博
//
//  Created by lk on 16/9/2.
//  Copyright © 2016年 lk. All rights reserved.
//

import UIKit

class WBDemoViewController: WBBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func showFriends(){
        
    }

}

extension WBDemoViewController{
    
    override func setupTableView(){
        super.setupTableView()
        
        navItem.rightBarButtonItem = UIBarButtonItem(title: "好友", target: self, action: #selector(showFriends))
        
        
    }
    
}
