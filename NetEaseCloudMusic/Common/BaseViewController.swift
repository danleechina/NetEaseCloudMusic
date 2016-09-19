//
//  BaseViewController.swift
//  NetEaseCloudMusic
//
//  Created by Ampire_Dan on 16/6/18.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    var needProgramInsertNavigationBar = true
    let navigationBar: BaseNavigationBar = {
        let bar = BaseNavigationBar.init(frame: CGRectMake(0, 20, UIScreen.mainScreen().bounds.size.width, 44))
        bar.backgroundColor = UIColor.clearColor()
        return bar
    }()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tapBackButton() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func goPlaySongVC() {
        let vc = PlaySongViewController()
        let playSongService = PlaySongService.sharedInstance
        vc.data = playSongService.playLists
        vc.currentSongIndex = playSongService.currentPlaySong
        vc.isPlaying = true
        
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
