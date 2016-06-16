//
//  AccountViewController.swift
//  NetEaseCloudMusic
//
//  Created by Ampire_Dan on 16/6/14.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {
    private var titleArray = [["我的消息"],
                              ["付费音乐包" , "积分商城" , "在线听歌免流量"],
                              ["设置" , "主题换肤" , "夜间模式" , "定时关闭" , "音乐闹钟" , "驾驶模式"],
                              ["分享网易云音乐", "关于"]]
    private var imageNameArray = [["first"],
                                  ["second", "first", "second"],
                                  ["first", "second", "first", "second", "first", "second"],
                                  ["first", "second"]]
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = self.view.frame
        tableView.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "账号"
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.tableView)
    }
}

extension AccountViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = AccountTableViewCell.cellFor(tableView)
        
        cell.titleText = titleArray[indexPath.section][indexPath.row]
        cell.titleImage = UIImage.init(named: imageNameArray[indexPath.section][indexPath.row])
        
        if indexPath.section == 0 {
            cell.number = 99
        } else if indexPath.section == 1 && indexPath.row == 1 {
            cell.rightInfoText = "3积分"
        } else if indexPath.section == 2 && indexPath.row == 1 {
            cell.rightInfoText = "官方红"
        } else if indexPath.section == 2 && indexPath.row == 1 {
            cell.isOn = true
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray[section].count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return titleArray.count
    }
    
    
}


class AccountHeadView: UIView {
    private lazy var faceIconView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var levelLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var checkInLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var activityLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var activityLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var focusLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var fansLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var editInfoView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}