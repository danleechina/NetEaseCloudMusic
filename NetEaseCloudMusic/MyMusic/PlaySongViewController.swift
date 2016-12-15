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
    @IBOutlet weak var lyricTableView: LyricTableView!
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
    @IBOutlet weak var controlStackView: UIStackView!
    @IBOutlet weak var lyricTimeImageView: UIImageView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var lyricStateLabel: UILabel!
    @IBOutlet weak var lyricTimeLabel: UILabel!
    // MARK: - Tap Action
    
    func tapPlayImage() -> Void {
        isPlaying = !isPlaying
        isPlaying ? playSongService.startPlay() : playSongService.pausePlay()
        
        changePlayImage()
        changeNeedlePosition(true)
    }
    
    func tapPrevSongImage(_ sender: UIImageView?) {
        playSongService.playPrev()
        
        currentSongIndex = playSongService.currentPlaySong
        currentSongIndexChange()
        
        changeTitleText()
        changeBackgroundBlurImage()
        changeProgressAndText(0, duration: 0)
        changeSongLyricPosition(0)
        if sender != nil {
            changeDisc(0)
        }
        self.songLyric = nil
        playSongService.getSongLyric { (songLyric) in self.songLyric = songLyric }
    }
    
    func tapNextSongImage(_ sender: UIImageView?) {
        playSongService.playNext()
        
        currentSongIndex = playSongService.currentPlaySong
        currentSongIndexChange()
        
        changeTitleText()
        changeBackgroundBlurImage()
        changeProgressAndText(0, duration: 0)
        changeSongLyricPosition(0)
        if sender != nil {
            changeDisc(1)
        }
        self.songLyric = nil
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
        if !swipableDiscView.isHidden {
            UIView.animate(withDuration: 0.2, animations: {
                self.lyricTableView.isHidden = false
                self.swipableDiscView.isHidden = true
                self.needleImageView.isHidden = true
                self.discMaskImageView.isHidden = true
                self.controlStackView.isHidden = true
                self.swipableDiscView.isUserInteractionEnabled = false
                self.lyricTableView.isUserInteractionEnabled = true
                }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.swipableDiscView.isHidden = false
                self.lyricTableView.isHidden = true
                self.lyricStateLabel.isHidden = true
                self.needleImageView.isHidden = false
                self.discMaskImageView.isHidden = false
                self.controlStackView.isHidden = false
                self.swipableDiscView.isUserInteractionEnabled = true
                self.lyricTableView.isUserInteractionEnabled = false
                }, completion: nil)
        }
        self.lyricTableView.changeLyricPoint(true)
        
        if songLyric == nil && !lyricTableView.isHidden {
            playSongService.getSongLyric({ (songLyric) in self.songLyric = songLyric })
        }
    }
    
    override func tapBackButton() {
        self.navigationController?.popViewController(animated: true)
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
            self.lyricTableView.songLyric = songLyric
        }
    }
    
    var isPlaying = false
    var isLike = false
    var playMode = PlayMode.order
    
    let playSongService = PlaySongService.sharedInstance
    var userDragging = false
    var isSwipeLeft = false
    var isNeedleUp = false
        
    fileprivate lazy var marqueeTitleLabel: MarqueeLabel = {
        let label =  MarqueeLabel.init(frame: CGRect(x: 0, y: 0, width: 200, height: 24), duration: 10, fadeLength:10)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.type = .continuous
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    fileprivate lazy var singerNameLabel: UILabel = {
        let label = UILabel.init(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 11)
        label.center = CGPoint(x: 100, y: 33)
        label.textAlignment = .center
        return label
    }()
    
    fileprivate lazy var discLeft: DiscView = {
        let screenWidth = UIScreen.main.bounds.size.width
        let discWidth: CGFloat = 240
        let paddingToEdge = (screenWidth - discWidth) / 2
        return DiscView.init(frame: CGRect(x: paddingToEdge, y: 0, width: discWidth, height: discWidth))
    }()
    
    fileprivate lazy var discMiddle: DiscView = {
        let screenWidth = UIScreen.main.bounds.size.width
        let discWidth: CGFloat = 240
        let paddingToEdge = (screenWidth - discWidth) / 2
        return DiscView.init(frame: CGRect(x: paddingToEdge + screenWidth, y: 0, width: discWidth, height: discWidth))
    }()
    
    fileprivate lazy var discRight: DiscView = {
        let screenWidth = UIScreen.main.bounds.size.width
        let discWidth: CGFloat = 240
        let paddingToEdge = (screenWidth - discWidth) / 2
        return DiscView.init(frame: CGRect(x: paddingToEdge + 2 * screenWidth, y: 0, width: discWidth, height: discWidth))
    }()
    
    // MARK: Override method
    
    override func viewDidLoad() {
        self.needProgramInsertNavigationBar = false
        super.viewDidLoad()
        dataInit()
        viewsInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .default
        setAnchorPoint(CGPoint(x: 0.5, y: 0.5), forView: self.needleImageView)
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
            self.picUrl = da.tracks[currentSongIndex].album.picUrl
            self.blurPicUrl = da.tracks[currentSongIndex].album.blurPicUrl
            self.songname = da.tracks[currentSongIndex].name
            self.singers = da.tracks[currentSongIndex].artists[0].name
        }
    }
    
    func playModeChange() {
        playSongService.playMode = playMode
    }
    
    func sliderValueChanged(_ sender: UISlider) {
        playSongService.playStartPoint(sender.value)
    }
    
    func tapLyricTimeImageView() {
        if let lyric = songLyric {
            playSongService.playStartTime(Float64((lyric.lyricTimeArray[self.lyricTableView.getMiddleRow()])))
        }
    }
    
    // MARK: Supporting For View
    
    // viewsInit called only once
    func viewsInit() {
        // blurBackgroundImageView
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visualEffectView.frame = blurBackgroundImageView.bounds
        blurBackgroundImageView.addSubview(visualEffectView)
        blurBackgroundImageView.backgroundColor = UIColor.black
        
        // swipableDiscView
        let screenWidth = UIScreen.main.bounds.size.width
        let discWidth: CGFloat = 240
        swipableDiscView.contentSize = CGSize(width: 3 * screenWidth, height: discWidth)
        swipableDiscView.contentOffset = CGPoint(x: screenWidth, y: 0)
        swipableDiscView.showsHorizontalScrollIndicator = false
        swipableDiscView.delegate = self
        swipableDiscView.isPagingEnabled = true
        swipableDiscView.addSubview(self.discLeft)
        swipableDiscView.addSubview(self.discMiddle)
        swipableDiscView.addSubview(self.discRight)
        swipableDiscView.isHidden = false
        let swipableTapGest = UITapGestureRecognizer.init(target: self, action: #selector(tapDiscScrollViewOrLyricTableView))
        swipableTapGest.numberOfTapsRequired = 1
        swipableDiscView.addGestureRecognizer(swipableTapGest)
        swipableDiscView.tag = 1
    
        // lyricTableView
        lyricTableView.delegate = self.lyricTableView
        lyricTableView.dataSource = self.lyricTableView
        lyricTableView.isHidden = true
        lyricTableView.backgroundColor = UIColor.clear
        let lyricTapGest = UITapGestureRecognizer.init(target: self, action: #selector(tapDiscScrollViewOrLyricTableView))
        lyricTapGest.numberOfTapsRequired = 1
        lyricTableView.addGestureRecognizer(lyricTapGest)
        lyricTableView.tag = 2
        lyricTableView.rowHeight = UITableViewAutomaticDimension
        lyricTableView.showsVerticalScrollIndicator = false
        lyricTableView.estimatedRowHeight = 50
        lyricTableView.tableHeaderView = UIView.init(frame:  CGRect(x: 0, y: 0, width: lyricTableView.bounds.size.width, height: lyricTableView.bounds.size.height/2))
        lyricTableView.tableFooterView = UIView.init(frame:  CGRect(x: 0, y: 0, width: lyricTableView.bounds.size.width, height: lyricTableView.bounds.size.height/2))
        lyricTableView.tableHeaderView?.backgroundColor = UIColor.clear
        lyricTableView.tableFooterView?.backgroundColor = UIColor.clear
        lyricTableView.lyricStateLabel = self.lyricStateLabel
        lyricTableView.lyricTimeImageView = self.lyricTimeImageView
        lyricTableView.lineView = self.lineView
        lyricTableView.lyricTimeLabel = self.lyricTimeLabel
        lyricTableView.changeLyricPoint(true)
        lyricTableView.lyricStateLabel?.isHidden = true
        
        // lyricTimeImageView
        let lyricTimeImageTapGest = UITapGestureRecognizer.init(target: self, action: #selector(tapLyricTimeImageView))
        lyricTimeImageTapGest.numberOfTapsRequired = 1
        lyricTimeImageView.addGestureRecognizer(lyricTimeImageTapGest)

        
        // loveImageView
        let tapGest = UITapGestureRecognizer.init(target: self, action: #selector(tapLoveImage))
        tapGest.numberOfTapsRequired = 1
        loveImageView.addGestureRecognizer(tapGest)
        
        // currentLocationSlider
        currentLocationSlider.setThumbImage(UIImage.init(named: "cm2_fm_playbar_btn"), for: UIControlState())
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
        
        currentLocationSlider.isContinuous = false
        currentLocationSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        
        backButton.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(tapShareButton), for: .touchUpInside)
        
        
        
        changeTitleText()
        changeBackgroundBlurImage()
        changePlayModeImage()
        changePlayImage()
//        changeNeedlePosition(false)
        changeProgressAndText(0, duration: 0)
        
        
        if let songInfo = self.playSongService.getCurrentSongInfo() {
            discMiddle.headPicCycleImageView.sd_setImage(with: URL.init(string: songInfo.picUrl)!, placeholderImage: UIImage.init(named: "cm2_default_cover_play"))
            discMiddle.resumeHeadPicImageViewAnimate()
//            needleDown(true)
        }
    }
    
    func setAnchorPoint(_ anchorPoint: CGPoint, forView view: UIView) {
        var newPoint = CGPoint(x: view.bounds.size.width * anchorPoint.x, y: view.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x: view.bounds.size.width * view.layer.anchorPoint.x, y: view.bounds.size.height * view.layer.anchorPoint.y)
        
        newPoint = newPoint.applying(view.transform)
        oldPoint = oldPoint.applying(view.transform)
        
        var position = view.layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        view.layer.position = position
        view.layer.anchorPoint = anchorPoint
    }
    
    
    func needleUp(_ animate: Bool) {
        if isNeedleUp {
            return
        }
        let angle = -CGFloat(M_PI/360 * 50)
        let point = self.view.convert(CGPoint(x: self.view.bounds.size.width/2, y: 64), to: self.needleImageView)
        let anchorPoint = CGPoint(x: point.x/self.needleImageView.bounds.size.width, y: point.y/self.needleImageView.bounds.size.height)
        self.setAnchorPoint(anchorPoint, forView: self.needleImageView)
        if animate {
            UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions(), animations: {
                self.needleImageView.transform = self.needleImageView.transform.rotated(by: angle)
                }, completion: nil)
        } else {
            self.needleImageView.transform = CGAffineTransform(rotationAngle: angle)
        }
        isNeedleUp = true
    }
    
    func needleDown(_ animate: Bool) {
        if !isNeedleUp {
            return
        }
        let angle = CGFloat(M_PI/360 * 50)
        if self.needleImageView.transform == CGAffineTransform.identity.rotated(by: angle) {
            return
        }
        let point = self.view.convert(CGPoint(x: self.view.bounds.size.width/2, y: 64), to: self.needleImageView)
        let anchorPoint = CGPoint(x: point.x/self.needleImageView.bounds.size.width, y: point.y/self.needleImageView.bounds.size.height)
        self.setAnchorPoint(anchorPoint, forView: self.needleImageView)
        
        if animate {
            UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions(), animations: {
                self.needleImageView.transform = self.needleImageView.transform.rotated(by: angle)
                }, completion: nil)
        } else {
            self.needleImageView.transform = CGAffineTransform(rotationAngle: angle)
        }
        isNeedleUp = false
    }
    
    func changeTitleText() {
        marqueeTitleLabel.text = songname
        singerNameLabel.text = singers
    }
    
    func changeBackgroundBlurImage() {
        blurBackgroundImageView?.sd_setImage(with: URL.init(string: blurPicUrl))
    }
    
    func changePlayModeImage() {
        switch playMode {
        case PlayMode.shuffle:
            playModeImageView.image = UIImage.init(named: "cm2_icn_shuffle")
            playModeImageView.highlightedImage = UIImage.init(named: "cm2_icn_shuffle_prs")
            break
        case PlayMode.cycle:
            playModeImageView.image = UIImage.init(named: "cm2_icn_loop")
            playModeImageView.highlightedImage = UIImage.init(named: "cm2_icn_loop_prs")
            break
        case PlayMode.repeat:
            playModeImageView.image = UIImage.init(named: "cm2_icn_one")
            playModeImageView.highlightedImage = UIImage.init(named: "cm2_icn_one_prs")
            break
        case PlayMode.order:
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
    
    func changeNeedlePosition(_ animate: Bool) {
        if isPlaying {
            needleDown(animate)
        } else {
            needleUp(animate)
        }
    }
    
    func changeLikeImage(_ animate: Bool) {
        if isLike {
            loveImageView.image = UIImage.init(named: "cm2_play_icn_loved")
            if animate {
                UIView.animate(withDuration: 0.1, animations: {
                    self.loveImageView.transform = CGAffineTransform.identity.scaledBy(x: 1.2, y: 1.2)
                    }, completion: { (finished) in
                        UIView.animate(withDuration: 0.1, animations: {
                            self.loveImageView.transform = self.loveImageView.transform.scaledBy(x: 0.8, y: 0.8)
                            }, completion: { (finished) in
                                UIView.animate(withDuration: 0.1, animations: {
                                    self.loveImageView.transform = self.loveImageView.transform.scaledBy(x: 1, y: 1)
                                    }, completion: { (finished) in
                                        self.loveImageView.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
                                })
                        })
                })
            }
        } else {
            loveImageView.image = UIImage.init(named: "cm2_play_icn_love")
        }
    }
    
    func changeProgressAndText(_ current: Float64, duration: Float64) {
        self.totalTimeLabel.text = SongLyric.getFormatTimeStringFromNumValue(duration)
        self.timePointLabel.text = SongLyric.getFormatTimeStringFromNumValue(current)
        if self.currentLocationSlider.isTracking {
            return
        }
        if duration != 0 && !duration.isNaN && !current.isNaN {
            self.currentLocationSlider.setValue(Float(current / duration) , animated: true)
        } else {
            self.currentLocationSlider.setValue(0 , animated: true)
        }
    }
    
    func changeSongLyricPosition(_ current: Float64) {
        if let lyric = self.songLyric {
            var lastValue:Float64 = 0
            for (idx, value) in lyric.lyricTimeArray.enumerated() {
                if current <= value && current > lastValue{
                    let row = idx == 0 ? 0 : idx - 1
                    for cell in self.lyricTableView.visibleCells {
                        cell.textLabel?.textColor = UIColor.lightGray
                    }
                    var theCell: UITableViewCell!
                    
                    if let cell = self.lyricTableView.cellForRow(at: IndexPath.init(row: row, section: 0)) {
                        theCell = cell
                    } else {
                        if let firstCell = self.lyricTableView.visibleCells.first {
                            if row < self.lyricTableView.indexPath(for: firstCell)!.row {
                                theCell = firstCell
                            }
                        } else if let lastCell = self.lyricTableView.visibleCells.last {
                            if row > self.lyricTableView.indexPath(for: lastCell)!.row {
                                theCell = lastCell
                            }
                        } else {
                            if self.lyricTableView.contentOffset.y < 0 {
                                self.lyricTableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                            } else {
                                self.lyricTableView.setContentOffset(CGPoint(x: 0, y: self.lyricTableView.contentSize.height + self.lyricTableView.bounds.height/2), animated: true)
                            }
                            return
                        }
                    }
                    let startContentOffset = CGPoint(x: 0, y: -self.lyricTableView.bounds.size.height / 2 + theCell.frame.origin.y)
                    self.lyricTableView.setContentOffset(CGPoint(x: startContentOffset.x, y: startContentOffset.y + theCell.bounds.size.height/2), animated: true)
                    theCell.textLabel?.textColor = UIColor.white
                    break;
                }
                lastValue = value
            }
        }
    }
    
    func changeDisc(_ direction: Int) {
        let screenWidth = UIScreen.main.bounds.size.width
        self.discLeft.headPicCycleImageView.image = UIImage.init(named: "cm2_default_cover_play");
        self.discRight.headPicCycleImageView.image = UIImage.init(named: "cm2_default_cover_play")
        discMiddle.pauseHeadPicImageViewAnimate()
        needleUp(true)
        
        if direction == 0 {
            // to left disc
            if let songInfo = self.playSongService.getCurrentSongInfo() {
                discLeft.headPicCycleImageView.sd_setImage(with: URL.init(string: songInfo.picUrl)!, placeholderImage: UIImage.init(named: "cm2_default_cover_play"))
            }
            UIView.animate(withDuration: 0.5, animations: {
                self.swipableDiscView.contentOffset = CGPoint(x: 0, y: 0)
                self.swipableDiscView.isUserInteractionEnabled = false
                }, completion: { (finished) in
                    self.swipableDiscView.setContentOffset(CGPoint(x: screenWidth, y: 0), animated: false)
                    self.swipableDiscView.isUserInteractionEnabled = true
                    self.discMiddle.resumeHeadPicImageViewAnimate()
                    self.needleDown(true)
                    if let songInfo = self.playSongService.getCurrentSongInfo() {
                        self.discMiddle.headPicCycleImageView.sd_setImage(with: URL.init(string: songInfo.picUrl)!, placeholderImage: UIImage.init(named: "cm2_default_cover_play"))
                    }
            })
        } else if direction == 1 {
            // to right disc
            if let songInfo = self.playSongService.getCurrentSongInfo() {
                discRight.headPicCycleImageView.sd_setImage(with: URL.init(string: songInfo.picUrl)!, placeholderImage: UIImage.init(named: "cm2_default_cover_play"))
            }
            UIView.animate(withDuration: 0.5, animations: {
                self.swipableDiscView.contentOffset = CGPoint(x: 2 * screenWidth, y: 0)
                self.swipableDiscView.isUserInteractionEnabled = false
                }, completion: { (finished) in
                    self.swipableDiscView.setContentOffset(CGPoint(x: screenWidth, y: 0), animated: false)
                    self.swipableDiscView.isUserInteractionEnabled = false
                    self.discMiddle.resumeHeadPicImageViewAnimate()
                    self.needleDown(true)
                    if let songInfo = self.playSongService.getCurrentSongInfo() {
                        self.discMiddle.headPicCycleImageView.sd_setImage(with: URL.init(string: songInfo.picUrl)!, placeholderImage: UIImage.init(named: "cm2_default_cover_play"))
                    }
            })
        }
    }
}

extension PlaySongViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.userDragging {
            if scrollView.panGestureRecognizer.translation(in: scrollView.superview).x > 0 {
                // right means prev
                if let songInfo = self.playSongService.getPrevSongInfo() {
                    self.discLeft.headPicCycleImageView.sd_setImage(with: URL.init(string: songInfo.picUrl)!, placeholderImage: UIImage.init(named:"cm2_default_cover_play"))
                }
                self.isSwipeLeft = false
            } else {
                // left means next
                if let songInfo = self.playSongService.getNextSongInfo() {
                    self.discRight.headPicCycleImageView.sd_setImage(with: URL.init(string: songInfo.picUrl)!, placeholderImage: UIImage.init(named:"cm2_default_cover_play"))
                }
                self.isSwipeLeft = true
            }
            needleUp(true)
            discMiddle.pauseHeadPicImageViewAnimate()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.userDragging = false
        scrollView.isUserInteractionEnabled = false
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.userDragging = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let screenWidth = UIScreen.main.bounds.size.width
        var contentOffSet = scrollView.contentOffset
        if contentOffSet.x == 2 * screenWidth {
            // play next
            tapNextSongImage(nil)
        } else if contentOffSet.x == 0 {
            // play prev
            tapPrevSongImage(nil)
        }
        contentOffSet.x = screenWidth
        scrollView.setContentOffset(contentOffSet, animated: false)
        if let songInfo = self.playSongService.getCurrentSongInfo() {
            discMiddle.headPicCycleImageView.sd_setImage(with: URL.init(string: songInfo.picUrl)!, placeholderImage: UIImage.init(named: "cm2_default_cover_play"))
            discMiddle.resumeHeadPicImageViewAnimate()
            needleDown(true)
        }
        scrollView.isUserInteractionEnabled = true
    }
}

extension PlaySongViewController: PlaySongServiceDelegate {
    func updateProgress(_ currentTime: Float64, durationTime: Float64) {
        changeProgressAndText(currentTime, duration: durationTime)
        if self.lyricTimeImageView.isHidden {
            changeSongLyricPosition(currentTime)
        }
    }
    
    func didChangeSong() {
        currentSongIndex = playSongService.currentPlaySong
        currentSongIndexChange()
        
        changeTitleText()
        changeBackgroundBlurImage()
        changeProgressAndText(0, duration: 0)
        
        changeSongLyricPosition(0)
        changeDisc(1)
        self.songLyric = nil
        playSongService.getSongLyric { (songLyric) in self.songLyric = songLyric }
    }
}
