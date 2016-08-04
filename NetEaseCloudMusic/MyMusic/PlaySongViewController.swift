//
//  PlaySongViewController.swift
//  NetEaseCloudMusic
//
//  Created by Ampire_Dan on 2016/7/14.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit


class PlaySongViewController: BaseViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var discMaskImageView: UIImageView!
    @IBOutlet weak var needleImageView: UIImageView!
    @IBOutlet weak var blurBackgroundImageView: UIImageView!
    @IBOutlet weak var swipableDiscView: UIScrollView!
    @IBOutlet weak var loveImageView: UIImageView!
    @IBOutlet weak var lyricTableView: UITableView!
    @IBOutlet weak var downloadImageView: UIImageView!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var settingImageView: UIImageView!
    @IBOutlet weak var timePointLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var currentLocationSlider: UISlider!
    @IBOutlet weak var playModeImageView: UIImageView!
    @IBOutlet weak var lastSongImageView: UIImageView!
    @IBOutlet weak var playImageView: UIImageView!
    @IBOutlet weak var nextImageView: UIImageView!
    @IBOutlet weak var totalSettingImageView: UIImageView!
    @IBOutlet weak var dotCurrentProcess: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var titleView: UIView!
    
    // MARK: - Tap Action
    
    func tapPlayImage() -> Void {
        isPlaying = !isPlaying
        isPlaying ? playSongService.startPlay() : playSongService.pausePlay()
        
        changePlayImage()
        changeNeedlePosition(true)
    }
    
    func tapPrevSongImage() {
        playSongService.playPrev()
        
        currentSongIndex = playSongService.currentPlaySong
        currentSongIndexChange()
        
        changeTitleText()
        changeBackgroundBlurImage()
        changeProgressAndText(0, duration: 0)
        playSongService.getSongLyric { (songLyric) in self.songLyric = songLyric }
    }
    
    func tapNextSongImage() {
        playSongService.playNext()
        
        currentSongIndex = playSongService.currentPlaySong
        currentSongIndexChange()
        
        changeTitleText()
        changeBackgroundBlurImage()
        changeProgressAndText(0, duration: 0)
        playSongService.getSongLyric { (songLyric) in self.songLyric = songLyric }
    }
    
    func tapLoveImage() {
        isLike = !isLike
        changeLikeImage(true)
    }
    
    func tapPlayModeImage() {
        playMode.next()
        playModeChange()
        changePlayModeImage()
    }
    
    func tapDiscScrollViewOrLyricTableView() {
        if !swipableDiscView.hidden {
            UIView.animateWithDuration(0.2, animations: {
                self.lyricTableView.hidden = false
                self.swipableDiscView.hidden = true
                self.needleImageView.hidden = true
                self.discMaskImageView.hidden = true

                }, completion: nil)
        } else {
            UIView.animateWithDuration(0.2, animations: {
                self.swipableDiscView.hidden = false
                self.lyricTableView.hidden = true
                self.needleImageView.hidden = false
                self.discMaskImageView.hidden = false

                }, completion: nil)
        }
        
        if songLyric == nil && !lyricTableView.hidden {
            playSongService.getSongLyric({ (songLyric) in self.songLyric = songLyric })
        }
    }
    
    func tapBackButton() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func tapShareButton() {
    }
    
    // MARK: - Property
    
    var data: CertainSongSheet?
    var currentSongIndex = 0
    var picUrl = ""
    var blurPicUrl = ""
    var songname = ""
    var singers = ""
    var songLyric: SongLyric? {
        didSet {
            lyricTableView.reloadData()
        }
    }
    
    var isPlaying = false
    var isLike = false
    var playMode = PlayMode.Order
    
    let playSongService = PlaySongService.sharedInstance
    var userDragging = false
    var isSwipeLeft = false
    var isNeedleUp = false
        
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
    
    private lazy var discLeft: DiscView = {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let discWidth: CGFloat = 240
        let paddingToEdge = (screenWidth - discWidth) / 2
        return DiscView.init(frame: CGRectMake(paddingToEdge, 0, discWidth, discWidth))
    }()
    
    private lazy var discMiddle: DiscView = {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let discWidth: CGFloat = 240
        let paddingToEdge = (screenWidth - discWidth) / 2
        return DiscView.init(frame: CGRectMake(paddingToEdge + screenWidth, 0, discWidth, discWidth))
    }()
    
    private lazy var discRight: DiscView = {
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let discWidth: CGFloat = 240
        let paddingToEdge = (screenWidth - discWidth) / 2
        return DiscView.init(frame: CGRectMake(paddingToEdge + 2 * screenWidth, 0, discWidth, discWidth))
    }()
    
    // MARK: Override method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataInit()
        viewsInit()
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
    
    // MARK: Supporting For Data
    
    // dataInit called only once
    func dataInit() {
        playSongService.delegate = self
        playSongService.playLists = data
        playModeChange()
        currentSongIndexChange()
        if isPlaying {
            playSongService.playCertainSong(currentSongIndex)
        }
    }
    
    func currentSongIndexChange()  {
        if let da = data {
            self.picUrl = da.tracks[currentSongIndex]["album"]!["picUrl"] as! String
            self.blurPicUrl = da.tracks[currentSongIndex]["album"]!["blurPicUrl"] as! String
            self.songname = da.tracks[currentSongIndex]["name"] as! String
            self.singers = da.tracks[currentSongIndex]["artists"]![0]["name"] as! String
        }
    }
    
    func playModeChange() {
        playSongService.playMode = playMode
    }
    
    func sliderValueChanged(sender: UISlider) {
        playSongService.playStartPoint(sender.value)
    }
    
    // MARK: Supporting For View
    
    // viewsInit called only once
    func viewsInit() {
        // blurBackgroundImageView
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
        visualEffectView.frame = blurBackgroundImageView.bounds
        blurBackgroundImageView.addSubview(visualEffectView)
        
        // swipableDiscView
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let discWidth: CGFloat = 240
        swipableDiscView.contentSize = CGSizeMake(3 * screenWidth, discWidth)
        swipableDiscView.contentOffset = CGPointMake(screenWidth, 0)
        swipableDiscView.showsHorizontalScrollIndicator = false
        swipableDiscView.delegate = self
        swipableDiscView.pagingEnabled = true
        swipableDiscView.addSubview(self.discLeft)
        swipableDiscView.addSubview(self.discMiddle)
        swipableDiscView.addSubview(self.discRight)
        swipableDiscView.hidden = false
        let swipableTapGest = UITapGestureRecognizer.init(target: self, action: #selector(tapDiscScrollViewOrLyricTableView))
        swipableTapGest.numberOfTapsRequired = 1
        swipableDiscView.addGestureRecognizer(swipableTapGest)
        swipableDiscView.tag = 1
    
        // lyricTableView
        lyricTableView.delegate = self
        lyricTableView.dataSource = self
        lyricTableView.hidden = true
        lyricTableView.backgroundColor = UIColor.clearColor()
        let lyricTapGest = UITapGestureRecognizer.init(target: self, action: #selector(tapDiscScrollViewOrLyricTableView))
        lyricTapGest.numberOfTapsRequired = 1
        lyricTableView.addGestureRecognizer(lyricTapGest)
        lyricTableView.tag = 2
        lyricTableView.rowHeight = UITableViewAutomaticDimension
        lyricTableView.estimatedRowHeight = 50

        
        // loveImageView
        let tapGest = UITapGestureRecognizer.init(target: self, action: #selector(tapLoveImage))
        tapGest.numberOfTapsRequired = 1
        loveImageView.addGestureRecognizer(tapGest)
        
        // currentLocationSlider
        currentLocationSlider.setThumbImage(UIImage.init(named: "cm2_fm_playbar_btn"), forState: .Normal)
        currentLocationSlider.minimumTrackTintColor = FixedValue.mainRedColor
        
        // playModeImageView
        let ptapGest = UITapGestureRecognizer.init(target: self, action: #selector(tapPlayModeImage))
        playModeImageView.addGestureRecognizer(ptapGest)
        
        // lastSongImageView
        let ltapGest = UITapGestureRecognizer.init(target: self, action: #selector(tapPrevSongImage))
        lastSongImageView.addGestureRecognizer(ltapGest)
        
        // playImageView
        let PIVtapGest = UITapGestureRecognizer.init(target: self, action: #selector(tapPlayImage))
        playImageView.addGestureRecognizer(PIVtapGest)
        
        // nextImageView
        let ntapGest = UITapGestureRecognizer.init(target: self, action: #selector(tapNextSongImage))
        nextImageView.addGestureRecognizer(ntapGest)
        
        // titleView
        titleView.addSubview(self.marqueeTitleLabel)
        titleView.addSubview(self.singerNameLabel)
        
        currentLocationSlider.continuous = true
        currentLocationSlider.addTarget(self, action: #selector(sliderValueChanged), forControlEvents: .ValueChanged)
        
        backButton.addTarget(self, action: #selector(tapBackButton), forControlEvents: .TouchUpInside)
        shareButton.addTarget(self, action: #selector(tapShareButton), forControlEvents: .TouchUpInside)
        
        
        
        changeTitleText()
        changeBackgroundBlurImage()
        changePlayModeImage()
        changePlayImage()
//        changeNeedlePosition(false)
        changeProgressAndText(0, duration: 0)
        
        
        if let songInfo = self.playSongService.getCurrentSongInfo() {
            discMiddle.headPicCycleImageView.sd_setImageWithURL(NSURL.init(string: songInfo.picUrl)!, placeholderImage: UIImage.init(named: "cm2_default_cover_play"))
            discMiddle.resumeHeadPicImageViewAnimate()
//            needleDown(true)
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
    
    
    func needleUp(animate: Bool) {
        if isNeedleUp {
            return
        }
        let angle = -CGFloat(M_PI/360 * 50)
        let point = self.view.convertPoint(CGPointMake(self.view.bounds.size.width/2, 64), toView: self.needleImageView)
        let anchorPoint = CGPointMake(point.x/self.needleImageView.bounds.size.width, point.y/self.needleImageView.bounds.size.height)
        self.setAnchorPoint(anchorPoint, forView: self.needleImageView)
        if animate {
            UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseInOut, animations: {
                self.needleImageView.transform = CGAffineTransformRotate(self.needleImageView.transform, angle)
                }, completion: nil)
        } else {
            self.needleImageView.transform = CGAffineTransformMakeRotation(angle)
        }
        isNeedleUp = true
    }
    
    func needleDown(animate: Bool) {
        if !isNeedleUp {
            return
        }
        let angle = CGFloat(M_PI/360 * 50)
        if CGAffineTransformEqualToTransform(self.needleImageView.transform, CGAffineTransformRotate(CGAffineTransformIdentity, angle)) {
            return
        }
        let point = self.view.convertPoint(CGPointMake(self.view.bounds.size.width/2, 64), toView: self.needleImageView)
        let anchorPoint = CGPointMake(point.x/self.needleImageView.bounds.size.width, point.y/self.needleImageView.bounds.size.height)
        self.setAnchorPoint(anchorPoint, forView: self.needleImageView)
        
        if animate {
            UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseInOut, animations: {
                self.needleImageView.transform = CGAffineTransformRotate(self.needleImageView.transform, angle)
                }, completion: nil)
        } else {
            self.needleImageView.transform = CGAffineTransformMakeRotation(angle)
        }
        isNeedleUp = false
    }
    
    func changeTitleText() {
        marqueeTitleLabel.text = songname
        singerNameLabel.text = singers
    }
    
    func changeBackgroundBlurImage() {
        blurBackgroundImageView?.sd_setImageWithURL(NSURL.init(string: blurPicUrl))
    }
    
    func changePlayModeImage() {
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
    
    func changePlayImage() {
        if isPlaying {
            playImageView.image = UIImage.init(named: "cm2_fm_btn_pause")
            discMiddle.resumeHeadPicImageViewAnimate()
        } else {
            playImageView.image = UIImage.init(named: "cm2_fm_btn_play")
            discMiddle.pauseHeadPicImageViewAnimate()
        }
    }
    
    func changeNeedlePosition(animate: Bool) {
        if isPlaying {
            needleDown(animate)
        } else {
            needleUp(animate)
        }
    }
    
    func changeLikeImage(animate: Bool) {
        if isLike {
            loveImageView.image = UIImage.init(named: "cm2_play_icn_loved")
            if animate {
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
        } else {
            loveImageView.image = UIImage.init(named: "cm2_play_icn_love")
        }
    }
    
    func changeProgressAndText(current: Float64, duration: Float64) {
        self.totalTimeLabel.text = getFormatTime(duration)
        self.timePointLabel.text = getFormatTime(current)
        if duration != 0 && !duration.isNaN && !current.isNaN {
            self.currentLocationSlider.setValue(Float(current / duration) , animated: true)
        } else {
            self.currentLocationSlider.setValue(0 , animated: true)
        }
    }
    
    func changeSongLyricPosition(current: Float64) {
        if let lyric = self.songLyric {
            var lastValue:Float64 = 0
            for (idx, value) in lyric.lyricTimeArray.enumerate() {
                if current <= value && current > lastValue{
                    let row = idx == 0 ? 0 : idx - 1
                    for cell in self.lyricTableView.visibleCells {
                        cell.textLabel?.textColor = UIColor.lightGrayColor()
                    }
                    if let cell = self.lyricTableView.cellForRowAtIndexPath(NSIndexPath.init(forRow: row, inSection: 0)) {
                        let startContentOffset = CGPointMake(0, -self.lyricTableView.bounds.size.height / 2 + cell.frame.origin.y)
                        self.lyricTableView.setContentOffset(startContentOffset, animated: true)
                        cell.textLabel?.textColor = UIColor.whiteColor()
                    }
                    break;
                }
                lastValue = value
            }
        }
    }
    
    // MARK: Data Util
    
    func getFormatTime(time: Float64) -> String {
        if time.isNaN {
            return "00:00"
        }
        let minuteValue = Int(time / 60)
        let secondValue = Int(time) - minuteValue * 60
        
        var secondStr = "\(secondValue)"
        if secondValue < 10 {
            secondStr = "0" + secondStr
        }
        
        var minStr = "\(minuteValue)"
        if minuteValue < 0 {
            minStr = "00"
        } else if minuteValue < 9 {
            minStr = "0" + minStr
        }
        
        return minStr + ":" + secondStr
    }
}

extension PlaySongViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.tag == 2 {
            return
        }
        if self.userDragging {
            if scrollView.panGestureRecognizer.translationInView(scrollView.superview).x > 0 {
                // right means prev
                if let songInfo = self.playSongService.getPrevSongInfo() {
                    self.discLeft.headPicCycleImageView.sd_setImageWithURL(NSURL.init(string: songInfo.picUrl)!, placeholderImage: UIImage.init(named:"cm2_default_cover_play"))
                }
                self.isSwipeLeft = false
            } else {
                // left means next
                if let songInfo = self.playSongService.getNextSongInfo() {
                    self.discRight.headPicCycleImageView.sd_setImageWithURL(NSURL.init(string: songInfo.picUrl)!, placeholderImage: UIImage.init(named:"cm2_default_cover_play"))
                }
                self.isSwipeLeft = true
            }
            needleUp(true)
            discMiddle.pauseHeadPicImageViewAnimate()
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.tag == 2 {
            return
        }
        self.userDragging = false
        scrollView.userInteractionEnabled = false
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if scrollView.tag == 2 {
            return
        }
        self.userDragging = true
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView.tag == 2 {
            return
        }
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        var contentOffSet = scrollView.contentOffset
        if contentOffSet.x == 2 * screenWidth {
            // play next
            tapNextSongImage()
        } else if contentOffSet.x == 0 {
            // play prev
            tapPrevSongImage()
        }
        contentOffSet.x = screenWidth
        scrollView.setContentOffset(contentOffSet, animated: false)
        if let songInfo = self.playSongService.getCurrentSongInfo() {
            discMiddle.headPicCycleImageView.sd_setImageWithURL(NSURL.init(string: songInfo.picUrl)!, placeholderImage: UIImage.init(named: "cm2_default_cover_play"))
            discMiddle.resumeHeadPicImageViewAnimate()
            needleDown(true)
        }
        scrollView.userInteractionEnabled = true
    }
}

extension PlaySongViewController: PlaySongServiceDelegate {
    func updateProgress(currentTime: Float64, durationTime: Float64) {
        changeProgressAndText(currentTime, duration: durationTime)
        changeSongLyricPosition(currentTime)
    }
    
    func didChangeSong() {
        currentSongIndex = playSongService.currentPlaySong
        currentSongIndexChange()
        
        changeTitleText()
        changeBackgroundBlurImage()
        changeProgressAndText(0, duration: 0)
    }
}

class LyricCell: UITableViewCell {

}


extension PlaySongViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("LyricCell")
        if cell == nil {
            cell = UITableViewCell.init(style: .Default, reuseIdentifier: "LyricCell")
            cell?.backgroundColor = UIColor.clearColor()
            cell?.textLabel?.textAlignment = .Center
            cell?.textLabel?.numberOfLines = 0
        }
        cell?.textLabel?.textColor = UIColor.lightGrayColor()
        cell?.textLabel?.text = songLyric?.lyricArray[indexPath.row]
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = songLyric?.lyricArray.count {
            return count
        }
        return 0
    }
}
