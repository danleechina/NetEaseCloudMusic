//
//  AccountTableViewCell.swift
//  NetEaseCloudMusic
//
//  Created by Ampire_Dan on 16/6/14.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit
import SnapKit

class AccountTableViewCell: BaseTableViewCell {
    static let reuseIdentifier = "AccountTableViewCell"
    
    var titleImage: UIImage? {
        get {
            return titleImageView.image
        }
        set {
            titleImageView.image = newValue
        }
    }
    
    var titleText: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }
    
    var number: Int? {
        get {
            return roundNumberLabel.number
        }
        set {
            roundNumberLabel.number = newValue
            roundNumberLabel.hidden = false
            rightInfoLabel.hidden = true
            switchButton.hidden = true
        }
    }
    
    var rightInfoText: String? {
        get {
            return rightInfoLabel.text
        }
        set {
            rightInfoLabel.text = newValue
            roundNumberLabel.hidden = true
            rightInfoLabel.hidden = false
            switchButton.hidden = true
        }
    }
    
    var isOn: Bool {
        get {
            return switchButton.on
        }
        set {
            switchButton.on = newValue
            roundNumberLabel.hidden = true
            rightInfoLabel.hidden = true
            switchButton.hidden = false
        }
    }
    
    /*必有项*/
    private lazy var titleImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        return label
    }()
    
    /*可选项*/
    private lazy var roundNumberLabel: RoundNumberLabel = {
        let numberLabel = RoundNumberLabel()
        numberLabel.hidden = true
        return numberLabel
    }()
    
    private lazy var rightInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.grayColor()
        label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        label.hidden = true
        return label
    }()
    
    private lazy var switchButton: UISwitch = {
        let switchButton = UISwitch()
        switchButton.hidden = true
        return switchButton
    }()
    
    
    static func cellFor(table: UITableView) -> AccountTableViewCell {
        var cell = table.dequeueReusableCellWithIdentifier(reuseIdentifier)
        if cell == nil {
            cell = AccountTableViewCell.init(style: .Default, reuseIdentifier: reuseIdentifier)
            cell?.accessoryType = .DisclosureIndicator
        }
        return cell as! AccountTableViewCell
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(titleImageView)
        self.addSubview(titleLabel)
        self.addSubview(roundNumberLabel)
        self.addSubview(rightInfoLabel)
        self.addSubview(switchButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleImageView.sizeToFit()
        titleLabel.sizeToFit()
        roundNumberLabel.sizeToFit()
        rightInfoLabel.sizeToFit()
        
        titleImageView.snp_makeConstraints { (make) in
            make.left.equalTo(self.snp_left).offset(10)
            make.centerY.equalTo(self.snp_centerY)
        }
        
        titleLabel.snp_makeConstraints { (make) in
            make.left.equalTo(titleImageView.snp_right).offset(10)
            make.centerY.equalTo(self.snp_centerY)
        }
        
        roundNumberLabel.snp_makeConstraints { (make) in
            make.right.equalTo(self.contentView.snp_right).offset(-5)
            make.centerY.equalTo(self.snp_centerY)
        }
        
        rightInfoLabel.snp_makeConstraints { (make) in
            make.right.equalTo(self.contentView.snp_right).offset(-5)
            make.centerY.equalTo(self.snp_centerY)
        }
        
        switchButton.snp_makeConstraints { (make) in
            make.right.equalTo(self.contentView.snp_right).offset(-5)
            make.centerY.equalTo(self.snp_centerY)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
