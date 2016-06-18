//
//  MyMessageViewController.swift
//  NetEaseCloudMusic
//
//  Created by Ampire_Dan on 16/6/14.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit

class MyMessageViewController: BaseViewController {

    private lazy var segementView:UISegmentedControl = {
       let segement = UISegmentedControl.init(items: ["@我的", "私信", "评论", "通知"])
        return segement
    }()
    
    
    private lazy var tableView:UITableView = {
       let tableView = UITableView()
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的消息"
        self.view.addSubview(segementView)
    }

}

class AtMineCell: UITableViewCell {
    static let reuseIdentifier = "AtMineCell"
    static func cellFor(table: UITableView) -> AtMineCell {
        var cell = table.dequeueReusableCellWithIdentifier(reuseIdentifier) as? AtMineCell
        if cell == nil {
            cell = AtMineCell.init(style: .Default, reuseIdentifier: reuseIdentifier)
        }
        return cell!
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class PrivateMessageCell: UITableViewCell {
    
    static let reuseIdentifier = "PrivateMessageCell"
    private lazy var headImage:UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var nickNameLabel:UILabel = {
       let label = UILabel()
        return label
    }()
    
    private lazy var messageLabel:UILabel = {
        let label = UILabel()
        return label
    }()

    private lazy var timeLabel:UILabel = {
        let label = UILabel()
        return label
    }()
    
    
    static func cellFor(table: UITableView) -> PrivateMessageCell {
        var cell = table.dequeueReusableCellWithIdentifier(reuseIdentifier) as? PrivateMessageCell
        if cell == nil {
            cell = PrivateMessageCell.init(style: .Default, reuseIdentifier: reuseIdentifier)
        }
        return cell!
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CommentCell: UITableViewCell {
    
    static let reuseIdentifier = "CommentCell"
    static func cellFor(table: UITableView) -> CommentCell {
        var cell = table.dequeueReusableCellWithIdentifier(reuseIdentifier) as? CommentCell
        if cell == nil {
            cell = CommentCell.init(style: .Default, reuseIdentifier: reuseIdentifier)
        }
        return cell!
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class NotificationCell: UITableViewCell {
    
    static let reuseIdentifier = "NotificationCell"
    static func cellFor(table: UITableView) -> NotificationCell {
        var cell = table.dequeueReusableCellWithIdentifier(reuseIdentifier) as? NotificationCell
        if cell == nil {
            cell = NotificationCell.init(style: .Default, reuseIdentifier: reuseIdentifier)
        }
        return cell!
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
