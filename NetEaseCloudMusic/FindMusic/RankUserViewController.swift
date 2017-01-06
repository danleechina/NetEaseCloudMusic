//
//  RankUserViewController.swift
//  NetEaseCloudMusic
//
//  Created by Dan.Lee on 2017/1/6.
//  Copyright © 2017年 Ampire_Dan. All rights reserved.
//

import UIKit

class RankUserViewController: RadioTwoTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        makeACommonNavigationBar(isBlackIcon: true)
        navigationBar.titleString = "用户榜"
        view.addSubview(statusBar)
    }
}
