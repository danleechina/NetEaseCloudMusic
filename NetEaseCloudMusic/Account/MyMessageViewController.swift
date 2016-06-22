//
//  MyMessageViewController.swift
//  NetEaseCloudMusic
//
//  Created by Ampire_Dan on 16/6/14.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit

class MyMessageViewController: BaseViewController {

    private lazy var segementView:HasInfoSegmentedControl = {
       let segement = HasInfoSegmentedControl.init(frame: CGRectZero, numbers: [0, 100, 0, 0], items: ["@我的", "私信", "评论", "通知"])
        segement.addTarget(self, action: #selector(segeementTouched), forControlEvents: .ValueChanged)
        return segement
    }()
    
    //at我的
    private lazy var atMineListTableView:AtMineListTableView = {
       let tableView = AtMineListTableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.hidden = true
        tableView.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    //私信
    private lazy var privateMessageListTableView:PrivateMessageListTableView = {
        let tableView = PrivateMessageListTableView()
        tableView.delegate = self.privateMessageListDAD
        tableView.dataSource = self.privateMessageListDAD
        tableView.hidden = true
        tableView.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    private lazy var privateMessageListDAD:PrivateMessageListDAD = {
       let dad = PrivateMessageListDAD()
        return dad
    }()
    
    //评论
    private lazy var commentListTableView:CommentListTableView = {
        let tableView = CommentListTableView()
        tableView.delegate = self.commentListDAD
        tableView.dataSource = self.commentListDAD
        tableView.hidden = true
        tableView.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    private lazy var commentListDAD:CommentListDAD = {
        let dad = CommentListDAD()
        return dad
    }()
    
    //通知
    private lazy var notificationListTableView:NotificationListTableView = {
        let tableView = NotificationListTableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.hidden = true
        tableView.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的消息"
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(segementView)
        self.view.addSubview(atMineListTableView)
        self.view.addSubview(privateMessageListTableView)
        self.view.addSubview(commentListTableView)
        self.view.addSubview(notificationListTableView)
        
//        segementView.selectedSegmentIndex = 1
        privateMessageListTableView.hidden = false
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
    
    func segeementTouched(sender: HasInfoSegmentedControl) -> Void {
        print(sender.currentSelectedIndex)
        if sender.currentSelectedIndex == 0 {
            atMineListTableView.hidden = false
            privateMessageListTableView.hidden = true
            commentListTableView.hidden = true
            notificationListTableView.hidden = true
        } else if sender.currentSelectedIndex == 1 {
            
            atMineListTableView.hidden = true
            privateMessageListTableView.hidden = false
            commentListTableView.hidden = true
            notificationListTableView.hidden = true
        } else if sender.currentSelectedIndex == 2 {
            
            atMineListTableView.hidden = true
            privateMessageListTableView.hidden = true
            commentListTableView.hidden = false
            notificationListTableView.hidden = true
        } else if sender.currentSelectedIndex == 3 {
            
            atMineListTableView.hidden = true
            privateMessageListTableView.hidden = true
            commentListTableView.hidden = true
            notificationListTableView.hidden = false
        }
    }

}


extension MyMessageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = BaseTableViewCell()
        if tableView .isKindOfClass(AtMineListTableView) {
            
            cell = AtMineCell.cellFor(tableView)
        } else if tableView .isKindOfClass(AtMineListTableView) {
            
            cell = PrivateMessageCell.cellFor(tableView)
        } else if tableView .isKindOfClass(AtMineListTableView) {
            
//            cell = CommentCell.cellFor(tableView)
        } else if tableView .isKindOfClass(AtMineListTableView) {
            
            cell = NotificationCell.cellFor(tableView)
        }
        cell.setData()
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 19
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}


