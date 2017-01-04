//
//  RadioListViewController.swift
//  NetEaseCloudMusic
//
//  Created by Dan.Lee on 2017/1/4.
//  Copyright © 2017年 Ampire_Dan. All rights reserved.
//

import UIKit

class RadioListViewController: BaseSliderViewController {
    var titleText: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        adjustViewFrameForFakeNavigationBar()
        
        navigationBar.leftButton.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
        navigationBar.leftButton.setImage(UIImage.init(named: "cm2_icn_back")?.renderWith(color: UIColor.black), for: UIControlState())
        navigationBar.leftButton.setImage(UIImage.init(named: "cm2_icn_back")?.renderWith(color: UIColor.black), for: .highlighted)
        navigationBar.titleString = titleText ?? ""
        navigationBar.rightButton.addTarget(self, action: #selector(goPlaySongVC), for: .touchUpInside)
        navigationBar.rightButton.setImage(UIImage.init(named: "cm2_topbar_icn_playing")?.renderWith(color: UIColor.black), for: UIControlState())
        navigationBar.rightButton.setImage(UIImage.init(named: "cm2_topbar_icn_playing_prs")?.renderWith(color: UIColor.black), for: .highlighted)
        navigationBar.backgroundColor = UIColor.white
        
        view.addSubview(statusBar)
        view.addSubview(navigationBar)
        view.backgroundColor = UIColor.white
        navigationBar.lineView.isHidden = true
    }
}
