//
//  PlaySongViewController.swift
//  NetEaseCloudMusic
//
//  Created by Ampire_Dan on 2016/7/14.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit

class PlaySongViewController: UIViewController {
    //I made a mistake, I should let the type be UIButton not UIImageView, but I am lazy to change. So be it
    
    @IBOutlet weak var needleImageView: UIImageView! {
        didSet {
        }
    }
    
    @IBOutlet weak var themePicImageView: UIImageView!{
        didSet {
            
        }
    }
    
    @IBOutlet weak var loveImageView: UIImageView!{
        didSet {
            
        }
    }
    
    @IBOutlet weak var downloadImageView: UIImageView!{
        didSet {
            
        }
    }
    
    @IBOutlet weak var commentImageView: UIImageView!{
        didSet {
            
        }
    }
    
    @IBOutlet weak var settingImageView: UIImageView!{
        didSet {
            
        }
    }
    
    @IBOutlet weak var timePointLabel: UILabel!{
        didSet {
            
        }
    }
    
    @IBOutlet weak var totalTimeLabel: UILabel!{
        didSet {
            
        }
    }
    
    @IBOutlet weak var currentLocationSlider: UISlider! {
        didSet {
            currentLocationSlider.setThumbImage(UIImage.init(named: "cm2_fm_playbar_btn"), forState: .Normal)
            currentLocationSlider.minimumTrackTintColor = FixedValue.mainRedColor
        }
    }
    
    
    @IBOutlet weak var playModeImageView: UIImageView!{
        didSet {
            
        }
    }
    
    @IBOutlet weak var lastSongImageView: UIImageView!{
        didSet {
            
        }
    }
    
    @IBOutlet weak var playImageView: UIImageView!{
        didSet {
            let tapGest = UITapGestureRecognizer.init(target: self, action: #selector(tapPlayImage))
            tapGest.numberOfTapsRequired = 1
            playImageView.addGestureRecognizer(tapGest)
        }
    }
    
    
    @IBOutlet weak var nextImageView: UIImageView!{
        didSet {
            
        }
    }
    
    @IBOutlet weak var totalSettingImageView: UIImageView!{
        didSet {
            
        }
    }
    
    @IBOutlet weak var dotCurrentProcess: UIImageView! {
        didSet {
            
        }
    }
    
    var isPlaying = false
    
    func tapPlayImage() -> Void {
        var angle:CGFloat = 0
        if isPlaying {
            playImageView.image = UIImage.init(named: "cm2_fm_btn_pause")
            angle = -CGFloat(M_PI/360 * 80)
        } else {
            playImageView.image = UIImage.init(named: "cm2_fm_btn_play")
            angle = CGFloat(0)
        }
        self.setAnchorPoint(CGPointMake(0.1, 0.1), forView: self.needleImageView)
        UIView .animateWithDuration(0.2) {
            self.needleImageView.transform = CGAffineTransformMakeRotation(angle)
        }
        isPlaying = !isPlaying
    }
    
    func setAnchorPoint(anchorPoint: CGPoint, forView view: UIView) {
        var newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x, view.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x, view.bounds.size.height * view.layer.anchorPoint.y)
        
        newPoint = CGPointApplyAffineTransform(newPoint, view.transform)
        oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform)
        
        var position = view.layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        view.layer.position = position
        view.layer.anchorPoint = anchorPoint
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isPlaying = true
    }
    
//    override func viewDidLayoutSubviews() {
//        
//        var frame = view.frame
//        frame.origin.y += 64
//        frame.size.height -= 64
//        view.frame = frame
//    }

}
