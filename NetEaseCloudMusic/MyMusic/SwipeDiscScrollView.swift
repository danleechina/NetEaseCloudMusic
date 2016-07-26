//
//  SwipeDiscScrollView.swift
//  NetEaseCloudMusic
//
//  Created by Zhengda Lee on 7/24/16.
//  Copyright © 2016 Ampire_Dan. All rights reserved.
//

import UIKit

class SwipeDiscScrollView: UIScrollView {

    var leftDiscHeadImage = UIImage.init(named: "cm2_default_cover_play")
    var rightDiscHeadImage = UIImage.init(named: "cm2_default_cover_play")
    
    var visibleDiscView = Array<DiscView>()
    private var discViewContainerView = UIView()
    
    private func recenterIfNecessary() {
        let currentOffset = contentOffset
        let contentWidth = contentSize.width
        let centerOffsetX = (contentWidth - bounds.size.width)/2
        let distanceFromCenter = fabs(currentOffset.x - centerOffsetX)
        
        if distanceFromCenter > contentWidth / 4 {
            contentOffset = CGPointMake(centerOffsetX, contentOffset.y)
            for discView in visibleDiscView {
                var center = self.discViewContainerView.convertPoint(discView.center, toView: self)
                center.x += (centerOffsetX - currentOffset.x)
                discView.center = self.convertPoint(center, toView: self.discViewContainerView)
            }
        }
        
    }
    
    private func insertNewDiscView() -> DiscView {
        let discView = DiscView.init(frame: CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height))
        self.discViewContainerView.addSubview(discView)
        return discView
    }
    
    private func placeNewDiscOnRight(rightEdge: CGFloat) -> CGFloat {
        let discView = insertNewDiscView()
        visibleDiscView.append(discView)
        var frame = discView.frame
        frame.origin.x = rightEdge
        frame.origin.y = self.discViewContainerView.bounds.height - frame.size.height
        discView.frame = frame
        return CGRectGetMaxX(frame)
    }
    
    private func placeNewDiscOnLeft(leftEdge: CGFloat) -> CGFloat {
        let discView = insertNewDiscView()
        visibleDiscView.insert(discView, atIndex: 0)
        var frame = discView.frame
        frame.origin.x = leftEdge - frame.size.width
        frame.origin.y = self.discViewContainerView.bounds.height - frame.size.height
        discView.frame = frame
        return CGRectGetMinX(frame)
    }
    
    private func tileDiscFrom(minX: CGFloat, maxX: CGFloat) {
        if visibleDiscView.count == 0 {
            placeNewDiscOnRight(minX)
        }
        
        var lastDiscView = visibleDiscView.last
        var rightEdge = CGRectGetMaxX((lastDiscView?.frame)!)
        while rightEdge < maxX {
            rightEdge = placeNewDiscOnRight(rightEdge)
        }
        
        var firstDiscView = visibleDiscView.first
        var leftEdge = CGRectGetMinX((firstDiscView?.frame)!)
        while leftEdge > minX {
            leftEdge = placeNewDiscOnLeft(leftEdge)
        }
        
        lastDiscView = visibleDiscView.last
        while lastDiscView?.frame.origin.x > maxX {
            lastDiscView?.removeFromSuperview()
            visibleDiscView.removeLast()
            lastDiscView = visibleDiscView.last
        }
        
        firstDiscView = visibleDiscView.first
        while CGRectGetMaxX((firstDiscView?.frame)!) < minX {
            firstDiscView?.removeFromSuperview()
            visibleDiscView.removeFirst()
            firstDiscView = visibleDiscView.first
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        recenterIfNecessary()
        
        let visibleBounds = self.convertRect(self.bounds, toView: self.discViewContainerView)
        let minX = CGRectGetMinX(visibleBounds)
        let maxX = CGRectGetMaxX(visibleBounds)
        
        tileDiscFrom(minX, maxX: maxX)
        
        visibleDiscView[0].headPicImage = leftDiscHeadImage
        if visibleDiscView.count > 1 {
            visibleDiscView[1].headPicImage = rightDiscHeadImage
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        contentSize = CGSizeMake(4000, self.bounds.height)
        addSubview(discViewContainerView)
        showsHorizontalScrollIndicator = false
        
        discViewContainerView.frame = CGRectMake(0, 0, self.bounds.width, self.bounds.height)
    }
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
        
        var frame = headPicCycleImageView.frame
        frame.size.height = 160
        frame.size.width = 160
        headPicCycleImageView.frame = frame
        
        
        frame = blackCycleImageView.frame
        frame.size.height = 240
        frame.size.width = 240
        blackCycleImageView.frame = frame
        
        let centerOfAll = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)
        headPicCycleImageView.center = centerOfAll
        blackCycleImageView.center = centerOfAll
    }
    
    func pauseHeadPicImageViewAnimate() {
        let pausedTime = headPicCycleImageView.layer .convertTime(CACurrentMediaTime(), fromLayer: nil)
        headPicCycleImageView.layer.speed = 0
        headPicCycleImageView.layer.timeOffset = pausedTime
    }
    
    func resumeHeadPicImageViewAnimate() {
        let pausedTime = headPicCycleImageView.layer.timeOffset
        headPicCycleImageView.layer.speed = 1
        headPicCycleImageView.layer.timeOffset = 0
        headPicCycleImageView.layer.beginTime = 0
        let timeSincePause = headPicCycleImageView.layer .convertTime(CACurrentMediaTime(), fromLayer: nil) - pausedTime
        headPicCycleImageView.layer.beginTime = timeSincePause
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
