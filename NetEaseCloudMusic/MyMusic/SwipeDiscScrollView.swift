//
//  SwipeDiscScrollView.swift
//  NetEaseCloudMusic
//
//  Created by Zhengda Lee on 7/24/16.
//  Copyright © 2016 Ampire_Dan. All rights reserved.
//

import UIKit

class SwipeDiscScrollView: UIScrollView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return self
    }
}

class DiscView: UIView {
    
    fileprivate var blackCycleImageView = UIImageView.init(image: UIImage.init(named: "cm2_play_disc-ip6"))
    var headPicCycleImageView = UIImageView.init(image: UIImage.init(named: "cm2_default_cover_play"))
    fileprivate var isPause = false

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headPicCycleImageView)
        addSubview(blackCycleImageView)
        
        
        let rotationAnimation = CABasicAnimation.init(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = Double(2 * M_PI)
        rotationAnimation.duration = 10
        rotationAnimation.repeatCount = Float.infinity
        headPicCycleImageView.layer.add(rotationAnimation, forKey: "rotationAnimation")
        pauseHeadPicImageViewAnimate()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var frame = headPicCycleImageView.frame
        frame.size.height = 160
        frame.size.width = 160
        headPicCycleImageView.frame = frame
        
        
        frame = blackCycleImageView.frame
        frame.size.height = 240
        frame.size.width = 240
        blackCycleImageView.frame = frame
        
        let centerOfAll = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
        headPicCycleImageView.center = centerOfAll
        blackCycleImageView.center = centerOfAll
    }
    
    func pauseHeadPicImageViewAnimate() {
        if isPause {
            return
        }
        isPause = true
        let pausedTime = headPicCycleImageView.layer .convertTime(CACurrentMediaTime(), from: nil)
        headPicCycleImageView.layer.speed = 0
        headPicCycleImageView.layer.timeOffset = pausedTime
    }
    
    func resumeHeadPicImageViewAnimate() {
        if !isPause {
            return
        }
        isPause = false
        let pausedTime = headPicCycleImageView.layer.timeOffset
        headPicCycleImageView.layer.speed = 1
        headPicCycleImageView.layer.timeOffset = 0
        headPicCycleImageView.layer.beginTime = 0
        let timeSincePause = headPicCycleImageView.layer .convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        headPicCycleImageView.layer.beginTime = timeSincePause
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
