//
//  MyMusicViewController.swift
//  NetEaseCloudMusic
//
//  Created by Ampire_Dan on 16/6/14.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit

class MyMusicViewController: BaseViewController {
    var mySongSheet: [[MyMusicModel]] = [[MyMusicModel]]()
    
    
    fileprivate lazy var tableView:UITableView = {
       let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(self.tableView)
    }
}


extension MyMusicViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mySongSheet[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return mySongSheet.count
    }
    

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        if section == 1 {
            label.text = "我创建的歌单(\(mySongSheet[0].count))"
        } else if section == 0 {
            label.text = "我收藏的歌单(\(mySongSheet[1].count))"
        }
        return label
    }
    
}

class MyMusicHeadModel: NSObject {
    
}


class MyMusicModel: NSObject {
    var titleImage:UIImage?
    var titleName:String?
    var numberOfSongs: String?
    var downloadedSongs: String?
    var authorID: String?
    
    class func dictToModel(_ data: Dictionary<String, String>?) -> MyMusicModel {
        let model = MyMusicModel()
        if let dict = data {
            model.titleImage = UIImage.init(named: dict["titleImage"] ?? "first")
            model.titleName = dict["titleName"]
            model.numberOfSongs = dict["numberOfSongs"]
            model.downloadedSongs = dict["downloadedSongs"]
            model.authorID = dict["authorID"]
        } else {
            model.titleImage = UIImage.init(named: "first")
            model.titleName = "song sheet name"
            model.numberOfSongs = "66"
            model.downloadedSongs = "6"
            model.authorID = "authorID"
        }
        return model
    }
}
