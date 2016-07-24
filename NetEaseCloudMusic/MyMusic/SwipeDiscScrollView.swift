//
//  SwipeDiscScrollView.swift
//  NetEaseCloudMusic
//
//  Created by Zhengda Lee on 7/24/16.
//  Copyright © 2016 Ampire_Dan. All rights reserved.
//

import UIKit

class SwipeDiscScrollView: UIScrollView {

    private var visibleDiscView: Array<DiscView>?
    private var discViewContainerView = UIView()
    
    
}

class DiscView: UIView {
    var headPicImage = UIImage.init(named: "cm2_default_cover_play") {
        didSet {
            headPicCycleImageView.image = headPicImage
        }
    }
    
    private var blackCycleImageView = UIImageView.init(image: UIImage.init(named: "cm2_play_disc-ip6"))
    private var headPicCycleImageView = UIImageView.init(image: UIImage.init(named: "cm2_default_cover_play"))

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headPicCycleImageView)
        addSubview(blackCycleImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        headPicCycleImageView.center = 
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
