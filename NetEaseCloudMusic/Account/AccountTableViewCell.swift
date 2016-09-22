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
            roundNumberLabel.isHidden = false
            rightInfoLabel.isHidden = true
            switchButton.isHidden = true
            logoutLabel.isHidden = true
        }
    }
    
    var rightInfoText: String? {
        get {
            return rightInfoLabel.text
        }
        set {
            rightInfoLabel.text = newValue
            roundNumberLabel.isHidden = true
            rightInfoLabel.isHidden = false
            switchButton.isHidden = true
            logoutLabel.isHidden =  true
        }
    }
    
    var isOn: Bool {
        get {
            return switchButton.isOn
        }
        set {
            switchButton.isOn = newValue
            roundNumberLabel.isHidden = true
            rightInfoLabel.isHidden = true
            switchButton.isHidden = false
            logoutLabel.isHidden = true
            self.accessoryView = switchButton
        }
    }
    
    var isLogin: Bool {
        get {
            return !logoutLabel.isHidden
        }
        set {
            if newValue {
                logoutLabel.isHidden = false
                titleLabel.isHidden = true
                titleImageView.isHidden = true
            } else {
                logoutLabel.isHidden = true
                titleLabel.isHidden = false
                titleImageView.isHidden = false
            }
        }
    }
    
    
    /*必有项*/
    fileprivate lazy var titleImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
        return label
    }()
    
    /*可选项*/
    fileprivate lazy var roundNumberLabel: RoundNumberLabel = {
        let numberLabel = RoundNumberLabel()
        numberLabel.isHidden = true
        return numberLabel
    }()
    
    fileprivate lazy var rightInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1)
        label.isHidden = true
        return label
    }()
    
    fileprivate lazy var switchButton: UISwitch = {
        let switchButton = UISwitch()
        switchButton.isHidden = true
        return switchButton
    }()
    
    
    fileprivate lazy var logoutLabel: UILabel = {
        let label = UILabel()
        label.text = "退出登录"
        label.textColor = FixedValue.mainRedColor
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    
    static func cellFor(_ table: UITableView) -> AccountTableViewCell {
        var cell = table.dequeueReusableCell(withIdentifier: reuseIdentifier) as? AccountTableViewCell
        if cell == nil {
            cell = AccountTableViewCell.init(style: .default, reuseIdentifier: reuseIdentifier)
        }
        cell?.accessoryType = .disclosureIndicator
        cell?.titleImageView.isHidden = false
        cell?.titleLabel.isHidden = false
        cell?.rightInfoLabel.isHidden = true
        cell?.roundNumberLabel.isHidden = true
        cell?.switchButton.isHidden = true
        cell?.logoutLabel.isHidden = true
        return cell!
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(titleImageView)
        self.addSubview(titleLabel)
        self.addSubview(roundNumberLabel)
        self.addSubview(rightInfoLabel)
        self.addSubview(switchButton)
        self.addSubview(logoutLabel)
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
        
        logoutLabel.snp_makeConstraints { (make) in
            make.center.equalTo(self.snp_center)
            make.width.equalTo(self.snp_width)
            make.height.equalTo(self.snp_height)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
