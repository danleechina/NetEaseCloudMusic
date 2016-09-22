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
        let bar = BaseNavigationBar.init(frame: CGRect(x: 0, y: 20, width: UIScreen.main.bounds.size.width, height: 44))
        bar.backgroundColor = UIColor.clear
        return bar
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tapBackButton() {
        self.navigationController?.popViewController(animated: true)
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
