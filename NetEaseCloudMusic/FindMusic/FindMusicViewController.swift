//
//  FindMusicViewController.swift
//  NetEaseCloudMusic
//
//  Created by Ampire_Dan on 16/6/14.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit

class FindMusicViewController: BaseSliderViewController {
    lazy var searchBar: UISearchBar = {
        let bar = UISearchBar.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 110, height: 44))
        bar.searchBarStyle = .minimal
        bar.placeholder = "搜索音乐、歌词、电台"
        bar.barTintColor = UIColor.clear
        
        var searchField = bar.value(forKey: "searchField") as? UITextField
        searchField?.backgroundColor = UIColor.lightGray
        return bar
    }()
    
    override func viewDidLoad() {
        let recommendVC = RecommendViewController()
        let songSheetVC = SongSheetViewController()
        let radioVC = RadioViewController()
        let rankListVC = RankListViewController()
        contentViewControllers = [recommendVC, songSheetVC, radioVC, rankListVC]
        titleTexts = ["个性推荐", "歌单", "主播电台", "排行榜"]
        currentIndex = 2
        
        super.viewDidLoad()
        
        adjustViewFrameForFakeNavigationBar()
        
        let limage = UIImage.init(named: "cm2_topbar_icn_mic_prs")
        navigationBar.leftButton.setImage(limage?.renderWith(color: UIColor.black), for: .normal)
        
        navigationBar.rightButton.addTarget(self, action: #selector(goPlaySongVC), for: .touchUpInside)
        let rimage = UIImage.init(named: "cm2_topbar_icn_playing")
        navigationBar.rightButton.setImage(rimage?.renderWith(color: UIColor.black), for: .normal)
        navigationBar.rightButton.setImage(rimage?.renderWith(color: UIColor.black), for: .highlighted)
        navigationBar.titleView.addSubview(self.searchBar)
        navigationBar.backgroundColor = UIColor.white
        navigationBar.lineView.isHidden = true
        self.view.addSubview(navigationBar)
        
    }
}
