//
//  AccountViewController.swift
//  NetEaseCloudMusic
//
//  Created by Ampire_Dan on 16/6/14.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit
import RealmSwift

class AccountViewController: BaseViewController {
    @IBOutlet weak var accountHeadView: UIView!
    @IBOutlet weak var noAccountLabel: UILabel!
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var checkInButton: UIButton!
    @IBOutlet weak var activityStackView: UIStackView!
    @IBOutlet weak var focusStackView: UIStackView!
    @IBOutlet weak var fansStackView: UIStackView!
    @IBOutlet weak var editStackView: UIStackView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var activityValueLabel: UILabel!
    @IBOutlet weak var focusValueLabel: UILabel!
    @IBOutlet weak var fansValueLabel: UILabel!
    
    func viewInit() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.showsVerticalScrollIndicator = false
        //avoid line separate happened everywhere
        tableView.tableFooterView = UIView()
        //avoid floating section
        tableView.contentInset = UIEdgeInsetsMake(-10, 0, 0, 0)
        
        checkInButton.layer.borderColor = FixedValue.mainRedColor.cgColor
        checkInButton.layer.borderWidth = 1.5
        checkInButton.layer.cornerRadius = 3
        checkInButton.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10)
        
        refreshView()
    }
    
    fileprivate var isSignedIn = false {
        didSet {
            DispatchQueue.main.async {
                self.refreshView()
            }
        }
    }
    
    func refreshView() {
        for view in self.accountHeadView.subviews {
            view.isHidden = !isSignedIn
        }
        
        noAccountLabel.isHidden = isSignedIn
        signinButton.isHidden = isSignedIn
        tableView.reloadData()
    }
    
    fileprivate var titleArray: Array< Array<String> > {
        get {
            if isSignedIn {
                return [
                    ["我的消息"],
                    ["付费音乐包" , "积分商城" , "在线听歌免流量"],
                    ["设置" , "主题换肤" , "夜间模式" , "定时关闭" , "音乐闹钟" , "驾驶模式"],
                    ["分享网易云音乐", "关于"],
                    ["退出登录"]
                ]
            } else {
                return [
                    ["我的消息"],
                    ["付费音乐包" , "积分商城" , "在线听歌免流量"],
                    ["设置" , "主题换肤" , "夜间模式" , "定时关闭" , "音乐闹钟" , "驾驶模式"],
                    ["分享网易云音乐", "关于"],
                ]
            }
        }
    }
    
    fileprivate var imageNameArray: Array< Array<String> > {
        get {
            if isSignedIn {
                return  [
                    ["cm2_set_icn_mail"],
                    ["cm2_set_icn_vip", "cm2_set_icn_store", "cm2_set_icn_combo"],
                    ["cm2_set_icn_set", "second", "cm2_set_icn_skin", "cm2_set_icn_night", "cm2_set_icn_alamclock", "cm2_set_icn_vehicle"],
                    ["cm2_set_icn_share", "cm2_set_icn_about"],
                    ["first"]
                ]
            } else {
                return  [
                    ["first"],
                    ["second", "first", "second"],
                    ["first", "second", "first", "second", "first", "second"],
                    ["first", "second"],
                    ["first"]
                ]
            }
        }
    }
    
    fileprivate var actionArray:[[UIViewController.Type]] = [
        [MyMessageViewController.self,],
        [PaidMusicViewController.self, PointMallViewController.self, OnlineFreePlayViewController.self,],
        [SettingViewController.self, ThemeSkinViewController.self, UIViewController.self, CountDownViewController.self, MusicAlarmViewController.self, DrivingModeViewController.self,],
        [UIViewController.self, AboutViewController.self,],
        [UIViewController.self,]
    ]
    
    fileprivate var realmNotificationTokenForAccount: NotificationToken? = nil
    fileprivate var realmNotificationTokenForActivity: NotificationToken? = nil
    fileprivate var realmNotificationTokenForFollows: NotificationToken? = nil
    fileprivate var realmNotificationTokenForFollowed: NotificationToken? = nil
    fileprivate var realmNotificationTokenForLevel: NotificationToken? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.navigationBar)
        self.navigationBar.titleString = "账号"
        self.navigationBar.backgroundColor = UIColor.white
        self.navigationBar.lineView.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        viewInit()
        self.isSignedIn = (DatabaseManager.shareInstance.currentUsedID != nil) ? true : false
        notificationInit()
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        realmNotificationTokenForAccount?.stop()
        realmNotificationTokenForActivity?.stop()
        realmNotificationTokenForFollows?.stop()
        realmNotificationTokenForFollowed?.stop()
        realmNotificationTokenForLevel?.stop()
    }
    
    func notificationInit() {
        NotificationCenter.default.addObserver(self, selector: #selector(onNewUserLogin), name: .onNewUserLogin, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onUserLogout), name: .onUserLogout, object: nil)
        
        let realm = try! Realm()
        let accoutsResults = realm.objects(AccountData.self)
        realmNotificationTokenForAccount = accoutsResults.addNotificationBlock({ [weak self] (changes: RealmCollectionChange) in
            guard let userID = DatabaseManager.shareInstance.currentUsedID else {return}
            switch changes {
            case .initial(let values):
                let value = values.filter("userID == \(userID)").first
                self?.nickNameLabel.text = value?.profile?.nickname
                guard let aurl = value?.profile?.avatarUrl else { break }
                self?.headImageView.sd_setImage(with: URL.init(string: aurl))
                break
            case .update(let values, _, _, _):
                let value = values.filter("userID == \(userID)").first
                self?.nickNameLabel.text = value?.profile?.nickname
                guard let aurl = value?.profile?.avatarUrl else { break }
                self?.headImageView.sd_setImage(with: URL.init(string: aurl))
                break
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
                break
            }
        })
        
        
        let activityResults = realm.objects(Activity.self)
        realmNotificationTokenForActivity = activityResults.addNotificationBlock({ [weak self] (changes: RealmCollectionChange) in
            guard let userID = DatabaseManager.shareInstance.currentUsedID else {return}
            switch changes {
            case .initial(let values):
                let value = values.filter("userID == \(userID)").first
                self?.activityValueLabel.text = "\(value?.events.count ?? 0)"
                break
            case .update(let values, _, _, _):
                let value = values.filter("userID == \(userID)").first
                self?.activityValueLabel.text = "\(value?.events.count ?? 0)"
                break
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
                break
            }
        })
        
        
        let followsResults = realm.objects(FollowsData.self)
        realmNotificationTokenForFollows = followsResults.addNotificationBlock({ [weak self] (changes: RealmCollectionChange) in
            guard let userID = DatabaseManager.shareInstance.currentUsedID else {return}
            switch changes {
            case .initial(let values):
                let value = values.filter("userID == \(userID)").first
                self?.focusValueLabel.text = "\(value?.follow.count ?? 0)"
                break
            case .update(let values, _, _, _):
                let value = values.filter("userID == \(userID)").first
                self?.focusValueLabel.text = "\(value?.follow.count ?? 0)"
                break
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
                break
            }
        })
        
        let followedResults = realm.objects(FollowedData.self)
        realmNotificationTokenForFollowed = followedResults.addNotificationBlock({ [weak self] (changes: RealmCollectionChange) in
            guard let userID = DatabaseManager.shareInstance.currentUsedID else {return}
            switch changes {
            case .initial(let values):
                let value = values.filter("userID == \(userID)").first
                self?.fansValueLabel.text = "\(value?.followeds.count ?? 0)"
                break
            case .update(let values, _, _, _):
                let value = values.filter("userID == \(userID)").first
                self?.fansValueLabel.text = "\(value?.followeds.count ?? 0)"
                break
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
                break
            }
        })
        
        let levelResults = realm.objects(Level.self)
        realmNotificationTokenForLevel = levelResults.addNotificationBlock({ [weak self] (changes: RealmCollectionChange) in
            guard let userID = DatabaseManager.shareInstance.currentUsedID else {return}
            switch changes {
            case .initial(let values):
                let value = values.filter("userId == \(userID)").first
                self?.levelLabel.text = "\(value?.level ?? 0)"
                break
            case .update(let values, _, _, _):
                let value = values.filter("userId == \(userID)").first
                self?.fansValueLabel.text = "\(value?.level ?? 0)"
                break
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
                break
            }
        })
        
    }
    
    func onNewUserLogin() {
        isSignedIn = true
        NetworkMusicApi.shareInstance.getCurrentLoginUserActivity { (data, error) in
            guard let dict = data?.jsonDict else {
                if let err = error {
                    print(err)
                } else {
                    print("data cannot be transferred to jsonDict")
                }
                return
            }
            if dict["code"] as? Int != 200 {
                print("code =\(dict["code"] as? Int)")
                return
            }
            DatabaseManager.shareInstance.storeActivityData(data: dict)
        }
        
        NetworkMusicApi.shareInstance.getCurrentLoginUserFollows { (data, error) in
            guard let dict = data?.jsonDict else {
                if let err = error {
                    print(err)
                } else {
                    print("data cannot be transferred to jsonDict")
                }
                return
            }
            if dict["code"] as? Int != 200 {
                print("code =\(dict["code"] as? Int)")
                return
            }
            DatabaseManager.shareInstance.storeFollowsData(data: dict)
        }
        
        NetworkMusicApi.shareInstance.getCurrentLoginUserFollowed { (data, error) in
            guard let dict = data?.jsonDict else {
                if let err = error {
                    print(err)
                } else {
                    print("data cannot be transferred to jsonDict")
                }
                return
            }
            if dict["code"] as? Int != 200 {
                print("code =\(dict["code"] as? Int)")
                return
            }
            DatabaseManager.shareInstance.storeFollowedData(data: dict)
        }
        
        NetworkMusicApi.shareInstance.getCurrentLoginUserLevel { (data, error) in
            guard let dict = data?.jsonDict else {
                if let err = error {
                    print(err)
                } else {
                    print("data cannot be transferred to jsonDict")
                }
                return
            }
            if dict["code"] as? Int != 200 {
                print("code =\(dict["code"] as? Int)")
                return
            }
            var muDict: Dictionary<String, Any> = dict["data"] as! Dictionary<String, Any>
            muDict["full"] = dict["full"]
            DatabaseManager.shareInstance.storeLevelData(data: muDict)
        }
        
    }
    
    func onUserLogout() {
        isSignedIn = false
    }
    
    func changeDayMode() -> Void {
        print("change mode")
    }
    
    func shareTheApp() -> Void {
        print("share the app")
    }
    
    func logout() -> Void {
        NetworkMusicApi.shareInstance.logout()
        print("logout")
    }
}

extension AccountViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AccountTableViewCell.cellFor(tableView)
        
        cell.titleText = titleArray[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        cell.titleImage = UIImage.init(named: imageNameArray[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row])
        
        if (indexPath as NSIndexPath).section == 0 {
            cell.number = 99
        } else if (indexPath as NSIndexPath).section == 1 && (indexPath as NSIndexPath).row == 1 {
            cell.rightInfoText = "3积分"
        } else if (indexPath as NSIndexPath).section == 2 && (indexPath as NSIndexPath).row == 1 {
            cell.rightInfoText = "官方红"
        } else if (indexPath as NSIndexPath).section == 2 && (indexPath as NSIndexPath).row == 2 {
            cell.isOn = true
        } else if (indexPath as NSIndexPath).section == 4 && (indexPath as NSIndexPath).row == 0 {
            cell.isLogin = true
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = actionArray[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row].init()
        if vc.superclass == BaseViewController.self {
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            if (indexPath as NSIndexPath).section == 2 && (indexPath as NSIndexPath).row == 2 {
                changeDayMode()
            } else if (indexPath as NSIndexPath).section == 3 && (indexPath as NSIndexPath).row == 0 {
                shareTheApp()
            } else if (indexPath as NSIndexPath).section == 4 && (indexPath as NSIndexPath).row == 0 {
                logout()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return titleArray.count
    }
    
    
}
