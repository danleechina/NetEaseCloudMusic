//
//  HeadIconView.swift
//  NetEaseCloudMusic
//
//  Created by Zhengda Lee on 6/18/16.
//  Copyright © 2016 Ampire_Dan. All rights reserved.
//

import UIKit

class HeadIconView: UIView {

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    
    private lazy var roundNumberLabel: RoundNumberLabel = {
       let label = RoundNumberLabel()
        return label
    }()
    
    
    private lazy var rankLabel: RoundNumberLabel = {
        let label = RoundNumberLabel()
        return label
    }()
    
    init(headImageName: String, number: Int, rank: String) {
        imageView.image = UIImage.init(named: headImageName)
        roundNumberLabel.number = number
        rankLabel.
        super.init(frame: CGRectZero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
