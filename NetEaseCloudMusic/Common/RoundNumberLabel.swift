//
//  CircleNumberLabel.swift
//  NetEaseCloudMusic
//
//  Created by Ampire_Dan on 16/6/16.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit

class RoundNumberLabel: UIView {
    static let height:CGFloat = 15
    var width:CGFloat = 15
    
    
    var number:Int? = 0 {
        didSet {
            var numberStr = String(number!)
            if number > 99 {
                numberStr = "99+"
            }
            self.numberLabel.text = numberStr
            self.sizeToFit()
        }
    }
    
    
    
    private lazy var numberLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.boldSystemFontOfSize(12)
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
        let size = self.numberLabel.bounds.size
        self.numberLabel.frame = CGRectMake(width/2 - size.width/2, RoundNumberLabel.height/2 - size.height/2, size.width, size.height)
    }
    
    override func sizeToFit() {
        width = RoundNumberLabel.height
        if number > 99 {
            width *= 2.2
        } else if number >= 10 {
            width *= 1.5
        } else if number > 0 {
            width *= 1
        } else {
            width = 0
        }
        self.bounds = CGRectMake(0, 0, width, RoundNumberLabel.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
