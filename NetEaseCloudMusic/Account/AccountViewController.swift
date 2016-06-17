//
//  AccountViewController.swift
//  NetEaseCloudMusic
//
//  Created by Ampire_Dan on 16/6/14.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {
    
    @IBOutlet weak var accountHeadView: UIView! {
        didSet {
            
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.backgroundColor = UIColor.clearColor()
            tableView.tableFooterView = UIView()
//            tableView.tableHeaderView = UIView.init(frame: CGRectMake(0, 0, tableView.bounds.size.width, 130))
        }
    }

    
    private var titleArray = [["我的消息"],
                              ["付费音乐包" , "积分商城" , "在线听歌免流量"],
                              ["设置" , "主题换肤" , "夜间模式" , "定时关闭" , "音乐闹钟" , "驾驶模式"],
                              ["分享网易云音乐", "关于"]]
    private var imageNameArray = [["first"],
                                  ["second", "first", "second"],
                                  ["first", "second", "first", "second", "first", "second"],
                                  ["first", "second"]]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
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