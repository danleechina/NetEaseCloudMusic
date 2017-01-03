//
//  FindMusicViewController.swift
//  NetEaseCloudMusic
//
//  Created by Ampire_Dan on 16/6/14.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit

class FindMusicViewController: SliderViewController {
    lazy var searchBar: UISearchBar = {
        let bar = UISearchBar.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 110, height: 44))
        bar.searchBarStyle = .minimal
        bar.placeholder = "搜索音乐、歌词、电台"
        bar.barTintColor = UIColor.clear
        
        var searchField = bar.value(forKey: "searchField") as? UITextField
        searchField?.backgroundColor = UIColor.lightGray
        return bar
    }()
    
    lazy var navigationBar: BaseNavigationBar = {
        let bar = BaseNavigationBar.init(frame: CGRect(x: 0, y: 20, width: UIScreen.main.bounds.size.width, height: 44))
        bar.backgroundColor = UIColor.white
        
        let limage = UIImage.init(named: "cm2_topbar_icn_mic_prs")
        bar.leftButton.setImage(limage?.renderWith(color: UIColor.black), for: .normal)
        
        bar.rightButton.addTarget(self, action: #selector(goPlaySongVC), for: .touchUpInside)
        let rimage = UIImage.init(named: "cm2_topbar_icn_playing")
        bar.rightButton.setImage(rimage?.renderWith(color: UIColor.black), for: .normal)
        bar.rightButton.setImage(rimage?.renderWith(color: UIColor.black), for: .highlighted)
        bar.titleView.addSubview(self.searchBar)
        bar.backgroundColor = UIColor.white
        return bar
    }()
    
    func goPlaySongVC() {
        let vc = PlaySongViewController()
        let playSongService = PlaySongService.sharedInstance
        vc.data = playSongService.playLists
        vc.currentSongIndex = playSongService.currentPlaySong
        vc.isPlaying = true
        
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        let recommendVC = RecommendViewController()
        let songSheetVC = SongSheetViewController()
        let radioVC = RadioViewController()
        let rankListVC = RankListViewController()
        contentViewControllers = [recommendVC, songSheetVC, radioVC, rankListVC]
        titleTexts = ["个性推荐", "歌单", "主播电台", "排行榜"]
        currentIndex = 1
        
        super.viewDidLoad()
        
        adjustViewFrameForFakeNavigationBar()
        self.view.addSubview(navigationBar)
        
    }
    
    func adjustViewFrameForFakeNavigationBar() {
        for view in self.view.subviews {
            view.top += 64
            if let scrollView = view as? UIScrollView {
                scrollView.height -= 64
                var cs = scrollView.contentSize
                cs.height -= 64
                scrollView.contentSize = cs
            }
        }
    }
}
