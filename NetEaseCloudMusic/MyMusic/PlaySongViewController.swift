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
    
    @IBOutlet weak var blurBackgroundImageView: UIImageView! {
        didSet {
            let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
            visualEffectView.frame = blurBackgroundImageView.bounds
            blurBackgroundImageView.addSubview(visualEffectView)
        }
    }
    
    @IBOutlet weak var themePicImageView: UIImageView!{
        didSet {
            let lswipeGest = UISwipeGestureRecognizer.init(target: self, action: #selector(swipeThemePictImageView))
            lswipeGest.direction = UISwipeGestureRecognizerDirection.Left
            themePicImageView.addGestureRecognizer(lswipeGest)
            
            let rswipeGest = UISwipeGestureRecognizer.init(target: self, action: #selector(swipeThemePictImageView))
            rswipeGest.direction = UISwipeGestureRecognizerDirection.Right
            themePicImageView.addGestureRecognizer(rswipeGest)
        }
    }
    
    
    @IBOutlet weak var headPicImageView: UIImageView!{
        didSet {
            headPicImageView.layer.cornerRadius = 80
            let rotationAnimation = CABasicAnimation.init(keyPath: "transform.rotation.z")
            rotationAnimation.toValue = Double(2 * M_PI)
            rotationAnimation.duration = 10
            rotationAnimation.cumulative = true
            rotationAnimation.repeatCount = Float.infinity
            headPicImageView.layer.addAnimation(rotationAnimation, forKey: "rotationAnimation")
            pauseHeadPicImageViewAnimate()
        }
    }
    
    
    @IBOutlet weak var loveImageView: UIImageView!{
        didSet {
            let tapGest = UITapGestureRecognizer.init(target: self, action: #selector(tapLoveImage))
            tapGest.numberOfTapsRequired = 1
            loveImageView.addGestureRecognizer(tapGest)
        }
    }
    
    @IBOutlet weak var downloadImageView: UIImageView!
    
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
            let tapGest = UITapGestureRecognizer.init(target: self, action: #selector(tapPlayModeImage))
            tapGest.numberOfTapsRequired = 1
            playModeImageView.addGestureRecognizer(tapGest)
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
    
    func pauseHeadPicImageViewAnimate() {
        let pausedTime = headPicImageView.layer .convertTime(CACurrentMediaTime(), fromLayer: nil)
        headPicImageView.layer.speed = 0
        headPicImageView.layer.timeOffset = pausedTime
    }
    
    func resumeHeadPicImageViewAnimate() {
        let pausedTime = headPicImageView.layer.timeOffset
        headPicImageView.layer.speed = 1
        headPicImageView.layer.timeOffset = 0
        headPicImageView.layer.beginTime = 0
        let timeSincePause = headPicImageView.layer .convertTime(CACurrentMediaTime(), fromLayer: nil) - pausedTime
        headPicImageView.layer.beginTime = timeSincePause
    }
    
    func tapPlayImage() -> Void {
        var angle:CGFloat = 0
        if isPlaying {
            playImageView.image = UIImage.init(named: "cm2_fm_btn_pause")
            angle = -CGFloat(M_PI/360 * 80)
            
            pauseHeadPicImageViewAnimate()
        } else {
            playImageView.image = UIImage.init(named: "cm2_fm_btn_play")
            angle = CGFloat(0)
            
            resumeHeadPicImageViewAnimate()
        }
        let point = self.view.convertPoint(CGPointMake(self.view.bounds.size.width/2, 64), toView: self.needleImageView)
        let anchorPoint = CGPointMake(point.x/self.needleImageView.bounds.size.width, point.y/self.needleImageView.bounds.size.height)
        self.setAnchorPoint(anchorPoint, forView: self.needleImageView)
        UIView .animateWithDuration(0.2) {
            self.needleImageView.transform = CGAffineTransformMakeRotation(angle)
        }
        
        
        
        isPlaying = !isPlaying
    }
    
    func tapLoveImage() {
        if isLike {
            loveImageView.image = UIImage.init(named: "cm2_play_icn_love")
        } else {
            loveImageView.image = UIImage.init(named: "cm2_play_icn_loved")
            UIView.animateWithDuration(0.1, animations: {
                self.loveImageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2)
                }, completion: { (finished) in
                    UIView.animateWithDuration(0.1, animations: {
                        self.loveImageView.transform = CGAffineTransformScale(self.loveImageView.transform, 0.8, 0.8)
                        }, completion: { (finished) in
                            UIView.animateWithDuration(0.1, animations: {
                                self.loveImageView.transform = CGAffineTransformScale(self.loveImageView.transform, 1, 1)
                                }, completion: { (finished) in
                                    self.loveImageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1)
                            })
                    })
            })
        }
        isLike = !isLike
    }
    
    func tapPlayModeImage() {
        playMode += 1
        playMode = playMode == 4 ? 0 : playMode
        switch playMode {
        case 0:
            playModeImageView.image = UIImage.init(named: "cm2_icn_shuffle")
            playModeImageView.highlightedImage = UIImage.init(named: "cm2_icn_shuffle_prs")
            break
        case 1:
            playModeImageView.image = UIImage.init(named: "cm2_icn_loop")
            playModeImageView.highlightedImage = UIImage.init(named: "cm2_icn_loop_prs")
            break
        case 2:
            playModeImageView.image = UIImage.init(named: "cm2_icn_one")
            playModeImageView.highlightedImage = UIImage.init(named: "cm2_icn_one_prs")
            break
        case 3:
            playModeImageView.image = UIImage.init(named: "cm2_icn_order")
            playModeImageView.highlightedImage = UIImage.init(named: "cm2_icn_order_prs")
            break
        default:
            break
        }
    }
    
    func swipeThemePictImageView(sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case UISwipeGestureRecognizerDirection.Left:
            
            break
            
        case UISwipeGestureRecognizerDirection.Right:
            break
        default:
            break
        }
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
    
    
    var mp3Url = ""
    var picUrl = ""
    var blurPicUrl = ""
    var songname = ""
    var singers = ""
    
    var isPlaying = false
    var isLike = false
    var playMode = 0
    
    private lazy var marqueeTitleLabel: MarqueeLabel = {
        let label =  MarqueeLabel.init(frame: CGRectMake(0, 0, 50, 44), duration: 2, fadeLength: 0)
        label.textColor = UIColor.whiteColor()
        label.backgroundColor = UIColor.blackColor()
        return label
    }()
    
    private lazy var singerNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var titleView: UIView = {
        let view = UIView()
        view.addSubview(self.marqueeTitleLabel)
        view.addSubview(self.singerNameLabel)
        return view
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        isPlaying = true
        
        headPicImageView.sd_setImageWithURL(NSURL.init(string: picUrl))
        blurBackgroundImageView.sd_setImageWithURL(NSURL.init(string: blurPicUrl))
        
        let barAppearance = self.navigationController?.navigationBar
        barAppearance?.translucent = true
        barAppearance?.setBackgroundImage(UIImage(), forBarMetrics: .Default)

        marqueeTitleLabel.text = songname + "2222222222"
        marqueeTitleLabel.triggerScrollStart()

        self.navigationItem.titleView = titleView
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        setAnchorPoint(CGPointMake(0.5, 0.5), forView: self.needleImageView)
    }
    
}
