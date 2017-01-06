//
//  BaseViewController.swift
//  NetEaseCloudMusic
//
//  Created by Ampire_Dan on 16/6/18.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    let navigationBar: BaseNavigationBar = {
        let bar = BaseNavigationBar.init(frame: CGRect(x: 0, y: 20, width: UIScreen.main.bounds.size.width, height: 44))
        bar.backgroundColor = UIColor.clear
        return bar
    }()
    
    let statusBar: UIView = {
       let view = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 20))
        view.backgroundColor = UIColor.white
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func makeACommonNavigationBar(isBlackIcon: Bool) {
        if isBlackIcon {
            navigationBar.leftButton.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
            navigationBar.leftButton.setImage(UIImage.init(named: "cm2_icn_back")?.renderWith(color: UIColor.black), for: UIControlState())
            navigationBar.leftButton.setImage(UIImage.init(named: "cm2_icn_back")?.renderWith(color: UIColor.black), for: .highlighted)
            navigationBar.rightButton.addTarget(self, action: #selector(goPlaySongVC), for: .touchUpInside)
            navigationBar.rightButton.setImage(UIImage.init(named: "cm2_topbar_icn_playing")?.renderWith(color: UIColor.black), for: UIControlState())
            navigationBar.rightButton.setImage(UIImage.init(named: "cm2_topbar_icn_playing_prs")?.renderWith(color: UIColor.black), for: .highlighted)
        } else {
            navigationBar.leftButton.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
            navigationBar.leftButton.setImage(UIImage.init(named: "cm2_icn_back"), for: UIControlState())
            navigationBar.leftButton.setImage(UIImage.init(named: "cm2_icn_back"), for: .highlighted)
            navigationBar.rightButton.addTarget(self, action: #selector(goPlaySongVC), for: .touchUpInside)
            navigationBar.rightButton.setImage(UIImage.init(named: "cm2_topbar_icn_playing"), for: UIControlState())
            navigationBar.rightButton.setImage(UIImage.init(named: "cm2_topbar_icn_playing_prs"), for: .highlighted)
        }
        view.addSubview(navigationBar)
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
