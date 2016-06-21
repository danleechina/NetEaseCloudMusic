//
//  PrivateMessageListTableView.swift
//  NetEaseCloudMusic
//
//  Created by Ampire_Dan on 16/6/19.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit

class PrivateMessageListTableView: BaseTableView {

}

class PrivateMessageListDAD: NSObject, UITableViewDelegate, UITableViewDataSource {
    var models:Array<PrivateMessageModel> = [PrivateMessageModel]()
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = PrivateMessageCell.cellFor(tableView)
        cell.model = PrivateMessageModel.dictToModel(nil)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return models.count
        return 20
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
}

class PrivateMessageCell: BaseTableViewCell {
    
    static let reuseIdentifier = "PrivateMessageCell"
    static let margin:CGFloat = 5
    var model:PrivateMessageModel = PrivateMessageModel() {
        didSet {
            setData()
        }
    }
    
    
    private lazy var headIconView:HeadIconView = {
        let headIconView = HeadIconView.init(frame: CGRectZero, headImageName: "second", number: 1, rank: "V")
        return headIconView
    }()
    
    private lazy var nickNameLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.blackColor()
        return label
    }()
    
    private lazy var messageLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.grayColor()
        return label
    }()
    
    private lazy var timeLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.grayColor()
        return label
    }()
    
    
    static func cellFor(table: UITableView) -> PrivateMessageCell {
        var cell = table.dequeueReusableCellWithIdentifier(reuseIdentifier) as? PrivateMessageCell
        if cell == nil {
            cell = PrivateMessageCell.init(style: .Default, reuseIdentifier: reuseIdentifier)
        }
        return cell!
    }
    
    override func setData() -> Void {
        headIconView.number = model.number
        headIconView.image = UIImage.init(named: model.iconName)
        nickNameLabel.text = model.nickName
        messageLabel.text = model.message
        model.rankStr = "V"
        //TODO: 日期处理
        let dateformatter = NSDateFormatter()
        dateformatter.dateFormat = "mm dd"
        timeLabel.text = dateformatter .stringFromDate(model.time)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(headIconView)
        addSubview(nickNameLabel)
        addSubview(messageLabel)
        addSubview(timeLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nickNameLabel.sizeToFit()
        timeLabel.sizeToFit()
        
        headIconView.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.snp_centerY)
            make.left.equalTo(self.snp_left).offset(FixedValue.defaultMargin)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        nickNameLabel.snp_makeConstraints { (make) in
            make.bottom.equalTo(self.snp_centerY)
            make.left.equalTo(headIconView.snp_right).offset(FixedValue.defaultMargin)
        }
        
        messageLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.snp_centerY)
            make.left.equalTo(headIconView.snp_right).offset(FixedValue.defaultMargin)
            make.right.equalTo(self.snp_right)
        }
        
        timeLabel.snp_makeConstraints { (make) in
            make.right.equalTo(self.snp_right).offset(-FixedValue.defaultMargin)
            make.centerY.equalTo(nickNameLabel.snp_centerY)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class PrivateMessageModel: NSObject {
    var iconName = ""
    var nickName = ""
    var message = ""
    var number = 0
    var rankStr = "V"
    var time = NSDate()
    
    
    static func dictToModel(dict: Dictionary<String, String>?) -> PrivateMessageModel {
        let model = PrivateMessageModel()
        if dict == nil {
            model.iconName = "first"
            model.nickName = "薛之谦"
            model.message = "hello from me"
            model.number = 2
            model.rankStr = "V"
            model.time = NSDate()
        } else {
            //TODO：数据处理
        }
        return model
    }
    
    
}