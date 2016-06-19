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

class PrivateMessageCell: BaseTableViewCell {
    
    static let reuseIdentifier = "PrivateMessageCell"
    static let margin:CGFloat = 5
    
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
        nickNameLabel.text = "薛之谦"
        messageLabel.text = "MV: [刚刚好]"
        timeLabel.text = "昨天 12:42"
        //        headIconView.
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