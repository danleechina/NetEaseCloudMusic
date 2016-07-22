//
//  AccountViewController.swift
//  NetEaseCloudMusic
//
//  Created by Ampire_Dan on 16/6/14.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit

class AccountViewController: BaseViewController {
    
    @IBOutlet weak var accountHeadView: UIView! {
        didSet {
            
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.backgroundColor = UIColor.clearColor()
            tableView.showsVerticalScrollIndicator = false
            //avoid line separate happened everywhere
            tableView.tableFooterView = UIView()
            //avoid floating section
            tableView.contentInset = UIEdgeInsetsMake(-10, 0, 0, 0)
        }
    }
    
    @IBOutlet weak var headImageView: UIImageView! {
        didSet {
            
        }
    }
    
    @IBOutlet weak var nickNameStackView: UIStackView! {
        didSet {
            
        }
    }
    
    
    
    @IBOutlet weak var checkInButton: UIButton! {
        didSet {
            checkInButton.layer.borderColor = FixedValue.mainRedColor.CGColor
            checkInButton.layer.borderWidth = 1.5
            checkInButton.layer.cornerRadius = 3
            checkInButton.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10)
        }
    }
    
    @IBOutlet weak var activityStackView: UIStackView! {
        didSet {
            
        }
    }

    @IBOutlet weak var focusStackView: UIStackView! {
        didSet {
            
        }
    }
    
    @IBOutlet weak var fansStackView: UIStackView! {
        didSet {
            
        }
    }
    
    @IBOutlet weak var editStackView: UIStackView! {
        didSet {
            
        }
    }
    
    
    
    
    private var titleArray = [["我的消息"],
                              ["付费音乐包" , "积分商城" , "在线听歌免流量"],
                              ["设置" , "主题换肤" , "夜间模式" , "定时关闭" , "音乐闹钟" , "驾驶模式"],
                              ["分享网易云音乐", "关于"],
                              ["退出登录"]]
    
    private var imageNameArray = [["first"],
                                  ["second", "first", "second"],
                                  ["first", "second", "first", "second", "first", "second"],
                                  ["first", "second"],
                                  ["first"]]
    
    private var actionArray:[[UIViewController.Type]] = [[MyMessageViewController.self,],
                                           [PaidMusicViewController.self, PointMallViewController.self, OnlineFreePlayViewController.self,],
                                           [SettingViewController.self, ThemeSkinViewController.self, UIViewController.self, CountDownViewController.self, MusicAlarmViewController.self, DrivingModeViewController.self,],
                                           [UIViewController.self, AboutViewController.self,],
                                           [UIViewController.self,]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func changeDayMode() -> Void {
        print("change mode")
    }
    
    func shareTheApp() -> Void {
        print("share the app")
    }
    
    func logout() -> Void {
        print("logout")
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
        } else if indexPath.section == 2 && indexPath.row == 2 {
            cell.isOn = true
        } else if indexPath.section == 4 && indexPath.row == 0 {
            cell.isLogin = true
            cell.accessoryType = .None
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let vc = actionArray[indexPath.section][indexPath.row].init()
        if vc.superclass == BaseViewController.self {
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            if indexPath.section == 2 && indexPath.row == 2 {
                changeDayMode()
            } else if indexPath.section == 3 && indexPath.row == 0 {
                shareTheApp()
            } else if indexPath.section == 4 && indexPath.row == 0 {
                logout()
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 4 {
            return 10
        }
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray[section].count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return titleArray.count
    }
    
    
}