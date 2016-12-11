//
//  MyMusicViewController.swift
//  NetEaseCloudMusic
//
//  Created by Ampire_Dan on 16/6/14.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit
import RealmSwift

class MyMusicViewController: BaseViewController {

    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
//            tableView.separatorStyle = .none
        }
    }
    
    fileprivate var isSectionOpen = [true, true]
    fileprivate var sectionOneLabel: UILabel!
    fileprivate var sectionTwoLabel: UILabel!
    fileprivate var sectionOneImageView: UIImageView!
    fileprivate var sectionTwoImageView: UIImageView!
    fileprivate lazy var sectionHeaderOne: UIView = {
        let (view, label, imageView) = self.getSectionHeader()
        label.text = "我创建的歌单(\(self.createByMyselfPlayList.count))"
        imageView.image = UIImage.init(named: "cm2_list_icn_arr_open")
        view.tag = 1
        self.sectionOneLabel = label
        self.sectionOneImageView = imageView
        return view
    }()
    
    fileprivate lazy var sectionHeaderTwo: UIView = {
        let (view, label, imageView) = self.getSectionHeader()
        label.text = "我收藏的歌单(\(self.favoritePlayList.count))"
        imageView.image = UIImage.init(named: "cm2_list_icn_arr_open")
        view.tag = 2
        self.sectionTwoLabel = label
        self.sectionTwoImageView = imageView
        return view
    }()
    
    fileprivate func getSectionHeader() -> (view: UIView, label: UILabel, imageView: UIImageView) {
        let view = UIView()
        let label = UILabel()
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 8, y: 5, width: 20, height: 20)
        label.frame = CGRect(x: 32, y: 5, width: 200, height: 20)
        imageView.contentMode = .center
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 13)
        view.backgroundColor = UIColor.init(red: 238/256.0, green: 239/256.0, blue: 240/256.0, alpha: 1)
        let tapGest = UITapGestureRecognizer.init(target: self, action: #selector(tapSectionHeader(sender:)))
        tapGest.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGest)
        view.addSubview(label)
        view.addSubview(imageView)
        return (view, label, imageView)
    }
    
    func tapSectionHeader(sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }
        
        isSectionOpen[view.tag - 1] = !isSectionOpen[view.tag - 1]
        if view.tag == 1 {
            sectionOneImageView.image = isSectionOpen[view.tag - 1] ? UIImage.init(named: "cm2_list_icn_arr_open") : UIImage.init(named: "cm2_list_icn_arr_fold")
        } else {
            sectionTwoImageView.image = isSectionOpen[view.tag - 1] ? UIImage.init(named: "cm2_list_icn_arr_open") : UIImage.init(named: "cm2_list_icn_arr_fold")
        }
        tableView.reloadData()
    }
    
    fileprivate var realmNotificationTokenForPlayList: NotificationToken? = nil
    fileprivate var sectionZeroList = [ ["下载音乐", "cm2_list_icn_dld_new", "8"],
                                        ["最近播放", "cm2_list_icn_recent_new", "100"],
                                        ["我的歌手", "cm2_list_icn_artists_new", "19"],
                                        ["我的MV", "cm2_list_icn_mymv_new", "19"],
                                        ["我的电台", "cm2_list_icn_rdi_new", "19"],
                                        ]
    
    fileprivate var createByMyselfPlayList = Array<PlayList>()
    fileprivate var favoritePlayList = Array<PlayList>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.backgroundColor = UIColor.white
        self.navigationBar.titleString = "我的音乐"
        self.navigationBar.leftButton.setTitle("更多", for: .normal)
        self.navigationBar.leftButton.setTitleColor(UIColor.black, for: .normal)
        self.navigationBar.leftButton.addTarget(self, action: #selector(clickTopBarMoreButton), for: .touchUpInside)
        self.view.addSubview(self.navigationBar)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onNewUserLogin), name: .onNewUserLogin, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onUserLogout), name: .onUserLogout, object: nil)
        
        let realm = try! Realm()
        let playListData = realm.objects(PlayListData.self)
        realmNotificationTokenForPlayList = playListData.addNotificationBlock({ [weak self] (change) in
            switch change {
            case .initial(let values):
                self?.refreshData(values: values)
                break
            case .update(let values, _, _, _):
                self?.refreshData(values: values)
                break
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
                break
            }
        })
    }
    
    func refreshData(values: Results<PlayListData>) {
        guard let userID = DatabaseManager.shareInstance.currentUsedID else {return}
        let value = values.filter("userId == \(userID)").first?.playlist
        if let nValue = value {
            let cValue = nValue.filter("userId == \(userID)")
            self.createByMyselfPlayList.removeAll()
            for playlist in cValue {
                self.createByMyselfPlayList.append(playlist)
            }
            
            let fValue = nValue.filter("userId != \(userID)")
            self.favoritePlayList.removeAll()
            for playlist in fValue {
                self.favoritePlayList.append(playlist)
            }
            sectionOneLabel.text = "我创建的歌单(\(self.createByMyselfPlayList.count))"
            sectionTwoLabel.text = "我收藏的歌单(\(self.favoritePlayList.count))"
            tableView.reloadData()
        }
    }
    
    func onNewUserLogin() {
        NetworkMusicApi.shareInstance.getUserPlayList { (data, error) in
            if let err = error {
                print(err)
                return
            }
            guard let dict = data?.jsonDict else { return }
            if dict["code"] as? Int != 200 {
                print("code = \(dict["code"])")
                return
            }
            DatabaseManager.shareInstance.storeUserPlayList(data: dict)
        }
    }
    
    func onUserLogout() {
        
    }
    
    func clickTopBarMoreButton() {
        self.blurView.isHidden = !self.blurView.isHidden
        self.listView.isHidden = !self.listView.isHidden
        
    }
    
    deinit {
        realmNotificationTokenForPlayList?.stop()
        NotificationCenter.default.removeObserver(self)
    }
}


extension MyMusicViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyMusicTableViewSectionOneCell") as? MyMusicTableViewSectionOneCell
            cell?.leftImageView.image = UIImage.init(named: sectionZeroList[indexPath.row][1])
            cell?.titleLabel.text = sectionZeroList[indexPath.row][0]
            cell?.rightValueLabel.text = sectionZeroList[indexPath.row][2]
            return cell!
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyMusicTableViewPlayListCell") as? MyMusicTableViewPlayListCell
            if let imageUrlStr = createByMyselfPlayList[indexPath.row].coverImgUrl {
                cell?.leftImageView.sd_setImage(with: URL.init(string: imageUrlStr), placeholderImage: UIImage.init(named: "second"))
            }
            cell?.playListNameLabel.text = createByMyselfPlayList[indexPath.row].name
            cell?.infoLabel.text = "\(createByMyselfPlayList[indexPath.row].cloudTrackCount)"
            cell?.downloadIndicatorImageView.image = UIImage.init(named: "cm2_list_icn_dld_half")
            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyMusicTableViewPlayListCell") as? MyMusicTableViewPlayListCell
            if let imageUrlStr = favoritePlayList[indexPath.row].coverImgUrl {
                cell?.leftImageView.sd_setImage(with: URL.init(string: imageUrlStr), placeholderImage: UIImage.init(named: "second"))
            }
            cell?.playListNameLabel.text = favoritePlayList[indexPath.row].name
            cell?.infoLabel.text = "\(favoritePlayList[indexPath.row].cloudTrackCount)"
            cell?.downloadIndicatorImageView.image = UIImage.init(named: "cm2_list_icn_dld_half")
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.sectionZeroList.count
        } else if section == 1 {
            return isSectionOpen[0] ? self.createByMyselfPlayList.count : 0
        } else if section == 2 {
            return isSectionOpen[1] ? self.favoritePlayList.count : 0
        } else {
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            return sectionHeaderOne
        } else {
            return sectionHeaderTwo
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 30
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = CertainSongSheetViewController()
        if indexPath.section == 1 {
            vc.playListID = "\(self.createByMyselfPlayList[indexPath.row].id)"
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.section == 2 {
            vc.playListID = "\(self.favoritePlayList[indexPath.row].id)"
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 50
        }
        return 64
    }
}

class MyMusicTableViewPlayListCell: BaseTableViewCell {
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var playListNameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var downloadIndicatorImageView: UIImageView!
    @IBOutlet weak var seperateLineView: UIView!
    
}

class MyMusicTableViewSectionOneCell: BaseTableViewCell {
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rightValueLabel: UILabel!
    @IBOutlet weak var seperateLineView: UIView!
    
}

