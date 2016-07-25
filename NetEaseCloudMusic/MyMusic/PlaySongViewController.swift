//
//  PlaySongViewController.swift
//  NetEaseCloudMusic
//
//  Created by Ampire_Dan on 2016/7/14.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit


class PlaySongViewController: BaseViewController {
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
    
//    @IBOutlet weak var themePicImageView: UIImageView!{
//        didSet {
//            let lswipeGest = UISwipeGestureRecognizer.init(target: self, action: #selector(swipeThemePictImageView))
//            lswipeGest.direction = UISwipeGestureRecognizerDirection.Left
//            themePicImageView.addGestureRecognizer(lswipeGest)
//            
//            let rswipeGest = UISwipeGestureRecognizer.init(target: self, action: #selector(swipeThemePictImageView))
//            rswipeGest.direction = UISwipeGestureRecognizerDirection.Right
//            themePicImageView.addGestureRecognizer(rswipeGest)
//        }
//    }
//    
//    
//    @IBOutlet weak var headPicImageView: UIImageView!{
//        didSet {
//            headPicImageView.layer.cornerRadius = 80
//            let rotationAnimation = CABasicAnimation.init(keyPath: "transform.rotation.z")
//            rotationAnimation.toValue = Double(2 * M_PI)
//            rotationAnimation.duration = 10
////            rotationAnimation.cumulative = true
//            rotationAnimation.repeatCount = Float.infinity
//            headPicImageView.layer.addAnimation(rotationAnimation, forKey: "rotationAnimation")
//            pauseHeadPicImageViewAnimate()
//        }
//    }
    
    @IBOutlet weak var swipableDiscView: UIScrollView! {
        didSet {
            swipableDiscView.delegate = self
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
            playModeImageView.addGestureRecognizer(tapGest)
        }
    }
    
    @IBOutlet weak var lastSongImageView: UIImageView!{
        didSet {
            let tapGest = UITapGestureRecognizer.init(target: self, action: #selector(tapPrevSongImage))
            lastSongImageView.addGestureRecognizer(tapGest)
        }
    }
    
    @IBOutlet weak var playImageView: UIImageView!{
        didSet {
            let tapGest = UITapGestureRecognizer.init(target: self, action: #selector(tapPlayImage))
            playImageView.addGestureRecognizer(tapGest)
        }
    }
    
    
    @IBOutlet weak var nextImageView: UIImageView!{
        didSet {
            let tapGest = UITapGestureRecognizer.init(target: self, action: #selector(tapNextSongImage))
            nextImageView.addGestureRecognizer(tapGest)
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
    
    @IBOutlet weak var backButton: UIButton! {
        didSet {
            backButton.addTarget(self, action: #selector(tapBackButton), forControlEvents: .TouchUpInside)
        }
    }
    
    
    @IBOutlet weak var shareButton: UIButton! {
        didSet {
            shareButton.addTarget(self, action: #selector(tapShareButton), forControlEvents: .TouchUpInside)
        }
    }
    
    func pauseHeadPicImageViewAnimate() {
//        let pausedTime = headPicImageView.layer .convertTime(CACurrentMediaTime(), fromLayer: nil)
//        headPicImageView.layer.speed = 0
//        headPicImageView.layer.timeOffset = pausedTime
    }
    
    func resumeHeadPicImageViewAnimate() {
//        let pausedTime = headPicImageView.layer.timeOffset
//        headPicImageView.layer.speed = 1
//        headPicImageView.layer.timeOffset = 0
//        headPicImageView.layer.beginTime = 0
//        let timeSincePause = headPicImageView.layer .convertTime(CACurrentMediaTime(), fromLayer: nil) - pausedTime
//        headPicImageView.layer.beginTime = timeSincePause
    }
    
    func tapPlayImage() -> Void {
        var angle:CGFloat = 0
        if isPlaying {
            playImageView.image = UIImage.init(named: "cm2_fm_btn_play")
            angle = -CGFloat(M_PI/360 * 50)
            
            pauseHeadPicImageViewAnimate()
        } else {
            playImageView.image = UIImage.init(named: "cm2_fm_btn_pause")
            angle = CGFloat(0)
            
            resumeHeadPicImageViewAnimate()
        }
        let point = self.view.convertPoint(CGPointMake(self.view.bounds.size.width/2, 64), toView: self.needleImageView)
        let anchorPoint = CGPointMake(point.x/self.needleImageView.bounds.size.width, point.y/self.needleImageView.bounds.size.height)
        self.setAnchorPoint(anchorPoint, forView: self.needleImageView)
        UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseInOut, animations: { 
            self.needleImageView.transform = CGAffineTransformMakeRotation(angle)
            }, completion: nil)
        isPlaying = !isPlaying
        
        if isPlaying {
            playSongService.startPlay()
        } else {
            playSongService.pausePlay()
        }
    }
    
    func tapPrevSongImage() {
        playSongService.playPrev()
    }
    
    func tapNextSongImage() {
        playSongService.playNext()
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
        playMode.next()
        switch playMode {
        case PlayMode.Shuffle:
            playModeImageView.image = UIImage.init(named: "cm2_icn_shuffle")
            playModeImageView.highlightedImage = UIImage.init(named: "cm2_icn_shuffle_prs")
            break
        case PlayMode.Cycle:
            playModeImageView.image = UIImage.init(named: "cm2_icn_loop")
            playModeImageView.highlightedImage = UIImage.init(named: "cm2_icn_loop_prs")
            break
        case PlayMode.Repeat:
            playModeImageView.image = UIImage.init(named: "cm2_icn_one")
            playModeImageView.highlightedImage = UIImage.init(named: "cm2_icn_one_prs")
            break
        case PlayMode.Order:
            playModeImageView.image = UIImage.init(named: "cm2_icn_order")
            playModeImageView.highlightedImage = UIImage.init(named: "cm2_icn_order_prs")
            break
        }
    }
    
    func tapBackButton() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func tapShareButton() {
        
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
    
    var data: CertainSongSheet? {
        didSet {
            playSongService.playLists = data
        }
    }
    
    var currentSongIndex = 0 {
        didSet {
            if let da = data {
                self.mp3Url = da.tracks[currentSongIndex]["mp3Url"] as! String
                self.picUrl = da.tracks[currentSongIndex]["album"]!["picUrl"] as! String
                self.blurPicUrl = da.tracks[currentSongIndex]["album"]!["blurPicUrl"] as! String
                self.songname = da.tracks[currentSongIndex]["name"] as! String
                self.singers = da.tracks[currentSongIndex]["artists"]![0]["name"] as! String
            }
        }
    }
    
    var mp3Url = ""
    var picUrl = ""
    var blurPicUrl = ""
    var songname = ""
    var singers = ""
    
    var isPlaying = false
    var isLike = false
    var playMode = PlayMode.Order {
        didSet {
            playSongService.playMode = playMode
        }
    }
    
    let playSongService = PlaySongService.sharedInstance
        
    private lazy var marqueeTitleLabel: MarqueeLabel = {
        let label =  MarqueeLabel.init(frame: CGRectMake(0, 0, 200, 24), duration: 10, fadeLength:10)
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        label.type = .Continuous
        label.font = UIFont.systemFontOfSize(15)
        return label
    }()
    
    private lazy var singerNameLabel: UILabel = {
        let label = UILabel.init(frame: CGRectMake(0, 0, 200, 20))
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.systemFontOfSize(11)
        label.center = CGPointMake(100, 33)
        label.textAlignment = .Center
        return label
    }()
    
    @IBOutlet weak var titleView: UIView! {
        didSet {
            titleView.addSubview(self.marqueeTitleLabel)
            titleView.addSubview(self.singerNameLabel)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isPlaying = true
        
//        headPicImageView.sd_setImageWithURL(NSURL.init(string: picUrl), placeholderImage: UIImage.init(named: "cm2_default_cover_play"))
        blurBackgroundImageView.sd_setImageWithURL(NSURL.init(string: blurPicUrl))
        
        marqueeTitleLabel.text = songname + "22222220000000000222"
        singerNameLabel.text = singers
        
        if isPlaying {
            resumeHeadPicImageViewAnimate()
        }
        // this is weird.
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        UIApplication.sharedApplication().statusBarStyle = .Default
        setAnchorPoint(CGPointMake(0.5, 0.5), forView: self.needleImageView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var backButtonCenter = backButton.center
        backButtonCenter.y = 44
        backButton.center = backButtonCenter
        
        var shareButtonCenter = shareButton.center
        shareButtonCenter.y = 44
        shareButton.center = shareButtonCenter
    }
 
}

extension PlaySongViewController: UIScrollViewDelegate {
}
