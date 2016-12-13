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
    
    let statusBar: UIView = {
       let view = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 20))
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tapBackButton() {
        if let nvc = self.navigationController {
            if nvc.viewControllers.count > 0 {
                if nvc.viewControllers.count == 1 {
                    if !(nvc.parent != nil) {
                        nvc.dismiss(animated: true, completion: nil)
                    }
                } else {
                    nvc.popViewController(animated: true)
                }
            } else {
                if !(self.parent != nil) {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        } else {
            if !(self.parent != nil) {
                self.dismiss(animated: true, completion: nil)
            }
        }
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
