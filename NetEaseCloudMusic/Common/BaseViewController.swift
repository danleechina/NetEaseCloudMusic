//
//  BaseViewController.swift
//  NetEaseCloudMusic
//
//  Created by Ampire_Dan on 16/6/18.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        applyDefaultNavigationBarStyle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyDefaultNavigationBarStyle()
    }
    
    func applyDefaultNavigationBarStyle() {
//        let appearance = self.navigationController?.navigationBar
//        appearance?.translucent = false
//        appearance?.barTintColor = FixedValue.mainRedColor
//        appearance?.barStyle = .Default
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
