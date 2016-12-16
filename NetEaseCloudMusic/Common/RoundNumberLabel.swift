//
//  CircleNumberLabel.swift
//  NetEaseCloudMusic
//
//  Created by Ampire_Dan on 16/6/16.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class RoundNumberLabel: UIView {
    static let height:CGFloat = 20
    var fixWidth:CGFloat = 20
    
    
    var number:Int? = 0 {
        didSet {
            var numberStr = String(number!)
            if number > 99 {
                numberStr = "99+"
            }
            self.numberLabel.text = numberStr
            self.sizeToFit()
            if number == 0 {
                self.isHidden = true
            } else {
                self.isHidden = false
            }
        }
    }
    
    fileprivate lazy var numberLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = FixedValue.mainRedColor
        self.layer.cornerRadius = RoundNumberLabel.height/2
        
        self.addSubview(self.numberLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.numberLabel.sizeToFit()
        self.sizeToFit()
        let size = self.numberLabel.bounds.size
        self.numberLabel.frame = CGRect(x: fixWidth/2 - size.width/2, y: RoundNumberLabel.height/2 - size.height/2, width: size.width, height: size.height)
    }
    
    override func sizeToFit() {
        fixWidth = RoundNumberLabel.height
        if number > 99 {
            fixWidth *= 2
        } else if number >= 10 {
            fixWidth *= 1.5
        } else if number > 0 {
            fixWidth *= 1
        } else {
            fixWidth = 0
        }
        self.bounds = CGRect(x: 0, y: 0, width: fixWidth, height: RoundNumberLabel.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
