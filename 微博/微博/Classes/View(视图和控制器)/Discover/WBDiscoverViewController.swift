//
//  WBDiscoverViewController.swift
//  微博
//
//  Created by lk on 16/8/29.
//  Copyright © 2016年 lk. All rights reserved.
//

import UIKit

class WBDiscoverViewController: WBBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        WBNetworkManager.shared.userAccount.access_token = nil
    }

    
    

}
