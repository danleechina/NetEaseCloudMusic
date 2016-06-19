//
//  HeadIconView.swift
//  NetEaseCloudMusic
//
//  Created by Zhengda Lee on 6/18/16.
//  Copyright © 2016 Ampire_Dan. All rights reserved.
//

import UIKit
import SnapKit

class HeadIconView: UIView {

     lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    
     lazy var roundNumberLabel: RoundNumberLabel = {
       let label = RoundNumberLabel()
        return label
    }()
    
    
     lazy var rankRoundLabel: RankRoundLabel = {
        let label = RankRoundLabel()
        return label
    }()
    
    init(frame: CGRect, headImageName: String, number: Int, rank: String) {
        super.init(frame: frame)
        imageView.image = UIImage.init(named: headImageName)
        roundNumberLabel.number = number
        rankRoundLabel.rankText = rank
        addSubview(imageView)
        addSubview(roundNumberLabel)
        addSubview(rankRoundLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.snp_makeConstraints { (make) in
            make.center.equalTo(self.snp_center)
        }
        
        roundNumberLabel.snp_makeConstraints { (make) in
            make.right.equalTo(imageView.snp_right)
            make.top.equalTo(imageView.snp_top)
        }
        
        rankRoundLabel.snp_makeConstraints { (make) in
            make.right.equalTo(imageView.snp_right).offset(-FixedValue.defaultMargin)
            make.bottom.equalTo(imageView.snp_bottom)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
