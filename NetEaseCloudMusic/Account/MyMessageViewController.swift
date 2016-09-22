//
//  MyMessageViewController.swift
//  NetEaseCloudMusic
//
//  Created by Ampire_Dan on 16/6/14.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit

class MyMessageViewController: BaseViewController {

    fileprivate lazy var segementView:HasInfoSegmentedControl = {
       let segement = HasInfoSegmentedControl.init(frame: CGRect.zero, numbers: [0, 100, 0, 0], items: ["@我的", "私信", "评论", "通知"])
        segement.addTarget(self, action: #selector(segeementTouched), for: .valueChanged)
        return segement
    }()
    
    //at我的
    fileprivate lazy var atMineListTableView:AtMineListTableView = {
       let tableView = AtMineListTableView()
//        tableView.delegate = self
//        tableView.dataSource = self
        tableView.isHidden = true
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    //私信
    fileprivate lazy var privateMessageListTableView:PrivateMessageListTableView = {
        let tableView = PrivateMessageListTableView()
        tableView.delegate = self.privateMessageListDAD
        tableView.dataSource = self.privateMessageListDAD
        tableView.isHidden = true
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    fileprivate lazy var privateMessageListDAD:PrivateMessageListDAD = {
       let dad = PrivateMessageListDAD()
        return dad
    }()
    
    //评论
    fileprivate lazy var commentListTableView:CommentListTableView = {
        let tableView = CommentListTableView()
        tableView.delegate = self.commentListDAD
        tableView.dataSource = self.commentListDAD
        tableView.isHidden = true
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        tableView.register(UINib.init(nibName: "CommentCell", bundle: Bundle.main), forCellReuseIdentifier: "CommentCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 110
        tableView.allowsSelection = false
        return tableView
    }()
    
    fileprivate lazy var commentListDAD:CommentListDAD = {
        let dad = CommentListDAD()
        return dad
    }()
    
    //通知
    fileprivate lazy var notificationListTableView:NotificationListTableView = {
        let tableView = NotificationListTableView()
//        tableView.delegate = self
//        tableView.dataSource = self
        tableView.isHidden = true
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的消息"
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(segementView)
        self.view.addSubview(atMineListTableView)
        self.view.addSubview(privateMessageListTableView)
        self.view.addSubview(commentListTableView)
        self.view.addSubview(notificationListTableView)
        
//        segementView.selectedSegmentIndex = 1
        privateMessageListTableView.isHidden = false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        segementView.snp_makeConstraints { (make) in
            make.left.equalTo(self.view.snp_left).offset(FixedValue.defaultMargin)
            make.right.equalTo(self.view.snp_right).offset(-FixedValue.defaultMargin)
            make.height.equalTo(FixedValue.segementHeight)
            make.top.equalTo(self.view.snp_top).offset(64.0 + FixedValue.defaultMargin)
        }
        
        atMineListTableView.snp_makeConstraints { (make) in
            make.left.equalTo(self.view.snp_left)
            make.right.equalTo(self.view.snp_right)
            make.top.equalTo(segementView.snp_bottom).offset(FixedValue.defaultMargin * 2)
            make.bottom.equalTo(self.view.snp_bottom).offset(-44)
        }
        
        privateMessageListTableView.snp_makeConstraints { (make) in
            make.left.equalTo(self.view.snp_left)
            make.right.equalTo(self.view.snp_right)
            make.top.equalTo(segementView.snp_bottom).offset(FixedValue.defaultMargin * 2)
            make.bottom.equalTo(self.view.snp_bottom).offset(-44)
        }
        
        commentListTableView.snp_makeConstraints { (make) in
            make.left.equalTo(self.view.snp_left)
            make.right.equalTo(self.view.snp_right)
            make.top.equalTo(segementView.snp_bottom).offset(FixedValue.defaultMargin * 2)
            make.bottom.equalTo(self.view.snp_bottom).offset(-44)
        }
        
        notificationListTableView.snp_makeConstraints { (make) in
            make.left.equalTo(self.view.snp_left)
            make.right.equalTo(self.view.snp_right)
            make.top.equalTo(segementView.snp_bottom).offset(FixedValue.defaultMargin * 2)
            make.bottom.equalTo(self.view.snp_bottom).offset(-44)
        }
    }
    
    func segeementTouched(_ sender: HasInfoSegmentedControl) -> Void {
        print(sender.currentSelectedIndex)
        if sender.currentSelectedIndex == 0 {
            atMineListTableView.isHidden = false
            privateMessageListTableView.isHidden = true
            commentListTableView.isHidden = true
            notificationListTableView.isHidden = true
        } else if sender.currentSelectedIndex == 1 {
            
            atMineListTableView.isHidden = true
            privateMessageListTableView.isHidden = false
            commentListTableView.isHidden = true
            notificationListTableView.isHidden = true
        } else if sender.currentSelectedIndex == 2 {
            
            atMineListTableView.isHidden = true
            privateMessageListTableView.isHidden = true
            commentListTableView.isHidden = false
            notificationListTableView.isHidden = true
        } else if sender.currentSelectedIndex == 3 {
            
            atMineListTableView.isHidden = true
            privateMessageListTableView.isHidden = true
            commentListTableView.isHidden = true
            notificationListTableView.isHidden = false
        }
    }

}
