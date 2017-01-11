//
//  CertainSongSheetViewController.swift
//  NetEaseCloudMusic
//
//  Created by Ampire_Dan on 2016/7/14.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit

class CertainSongSheetViewController: BaseViewController {
    
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    let backView = UIView()
    
    var blurBackgroundImageView = UIImageView()    
    var playListID = "" {
        didSet {
            if playListID != "" {
                PlayList.loadSongSheetData(self.playListID) { (data, error) in
                    if error == nil && data != nil {
                        self.data = data!
                    }
                }
            }
        }
    }
    
    var data: PlayList? {
        didSet {
            DispatchQueue.main.async(execute: {
                if let nndata = self.data {
                    let attr1 = [NSForegroundColorAttributeName: UIColor.black,NSFontAttributeName: UIFont.systemFont(ofSize: 14)]
                    let attr2 = [NSForegroundColorAttributeName: UIColor.lightGray, NSFontAttributeName: UIFont.systemFont(ofSize: 11)]
                    let str1 = NSMutableAttributedString.init(string: "播放全部", attributes: attr1)
                    str1.append(NSAttributedString.init(string: "（共\(nndata.tracks.count)首）", attributes: attr2))
                    self.defaultStyleCertainSongSheetSection.leftButton.setAttributedTitle(str1, for: UIControlState())
                    
                    if let coverImgUrl = nndata.coverImgUrl {
                        self.certainSongSheetTableViewHeadView.mainImageView.sd_setImage(with: URL.init(string: coverImgUrl))
                        self.blurBackgroundImageView.sd_setImage(with: URL.init(string: coverImgUrl))
                    }
                    self.certainSongSheetTableViewHeadView.mainTitleLabel.text = nndata.name ?? ""
                    self.marqueeTitleLabel.text = nndata.name ?? "歌单"
                    self.certainSongSheetTableViewHeadView.mainButton.setTitle(nndata.creator?.nickname ?? "", for: .normal)
                    self.certainSongSheetTableViewHeadView.favoriteLabel.text = "\(nndata.subscribedCount)"
                    self.certainSongSheetTableViewHeadView.commentLabel.text = "\(nndata.commentCount)"
                    self.certainSongSheetTableViewHeadView.shareLabel.text = "\(nndata.shareCount)"
                    self.certainSongSheetTableViewHeadView.downloadLabel.text = "下载"
                }
                self.tableView.reloadData()
            })

        }
    }
    
    let playSongService: PlaySongService = PlaySongService.sharedInstance
    
    fileprivate lazy var certainSongSheetTableViewHeadView: CertainSongSheetTableViewHeadView = {
        let nib = UINib.init(nibName: "CertainSongSheetTableViewHeadView", bundle: nil)
        let view = nib.instantiate(withOwner: nil, options: nil).last as! CertainSongSheetTableViewHeadView
        view.topLeftLabel.isHidden = true
        view.topRightLabel.isHidden = true
        view.bottomLeftLabel.isHidden = true
        view.bottomRightLabel.isHidden = true
        return view
    }()
    
    lazy var defaultStyleCertainSongSheetSection: CertainSongSheetSection = {
        let certainSongSheetSection = CertainSongSheetSection()
        certainSongSheetSection.leftButton.setImage(UIImage.init(named: "cm2_list_btn_play"), for: UIControlState())
        certainSongSheetSection.leftButton.setImage(UIImage.init(named: "cm2_list_btn_play_prs"), for: .highlighted)
        certainSongSheetSection.leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10)
        certainSongSheetSection.leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        certainSongSheetSection.leftButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        certainSongSheetSection.leftButton.contentHorizontalAlignment = .left
        certainSongSheetSection.rightButton.setImage(UIImage.init(named: "cm2_list_icn_multi"), for: UIControlState())
        certainSongSheetSection.rightButton.setImage(UIImage.init(named: "cm2_list_icn_multi_prs"), for: .highlighted)
        certainSongSheetSection.backgroundColor = UIColor.white
        return certainSongSheetSection
    }()
    
    var selectedStyleCertainSongSheetSection: CertainSongSheetSection = {
        let certainSongSheetSection = CertainSongSheetSection()
        certainSongSheetSection.leftButton.setImage(UIImage.init(named: "cm2_list_checkbox"), for: UIControlState())
        certainSongSheetSection.leftButton.setImage(UIImage.init(named: "cm2_list_checkbox_ok"), for: .selected)
        certainSongSheetSection.leftButton.setTitle("全选", for: UIControlState())
        certainSongSheetSection.leftButton.setTitleColor(UIColor.black, for: UIControlState())
        certainSongSheetSection.leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10)
        certainSongSheetSection.leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        certainSongSheetSection.leftButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        certainSongSheetSection.leftButton.contentHorizontalAlignment = .left
        certainSongSheetSection.rightButton.setTitle("完成", for: UIControlState())
        certainSongSheetSection.rightButton.setTitleColor(FixedValue.mainRedColor, for: UIControlState())
        certainSongSheetSection.backgroundColor = UIColor.white
        return certainSongSheetSection
    }()

    var isSectionInSelectedStyle = false
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height - 64 - self.navigationController!.toolbar.frame.height)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.rowHeight = 60
        tableView.tableHeaderView = self.certainSongSheetTableViewHeadView
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = true
        
        let cellNib = UINib.init(nibName: "CertainSongSheetCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: CertainSongSheetCell.identifier)
        return tableView
    }()
    
    fileprivate lazy var marqueeTitleLabel: MarqueeLabel = {
        let label =  MarqueeLabel.init(frame: CGRect(x: (self.view.bounds.width - 110 - 150)/2, y: 0, width: 150, height: 44), duration: 10, fadeLength:10)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.type = .continuous
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(blurBackgroundImageView)
        view.addSubview(backView)
        blurBackgroundImageView.addSubview(visualEffectView)
        backView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        blurBackgroundImageView.frame = view.bounds
        visualEffectView.frame = view.bounds
        backView.frame = view.bounds
        
        view.addSubview(tableView)
        self.certainSongSheetTableViewHeadView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.width * 0.6)
        view.backgroundColor = UIColor.white

        self.view.addSubview(self.navigationBar)
        self.navigationBar.leftButton.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
        self.navigationBar.leftButton.setImage(UIImage.init(named: "cm2_icn_back"), for: UIControlState())
        self.navigationBar.leftButton.setImage(UIImage.init(named: "cm2_icn_back"), for: .highlighted)
        self.marqueeTitleLabel.text = self.data?.name ?? "歌单"
        self.navigationBar.titleView.addSubview(marqueeTitleLabel)
        self.navigationBar.rightButton.addTarget(self, action: #selector(goPlaySongVC), for: .touchUpInside)
        self.navigationBar.rightButton.setImage(UIImage.init(named: "cm2_topbar_icn_playing"), for: UIControlState())
        self.navigationBar.rightButton.setImage(UIImage.init(named: "cm2_topbar_icn_playing_prs"), for: .highlighted)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
}


extension CertainSongSheetViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let d = data {
            return d.tracks.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CertainSongSheetCell.identifier, for: indexPath) as! CertainSongSheetCell
        let val = (data!.tracks[(indexPath as NSIndexPath).row])
        cell.tendencyLabel.isHidden = true
        cell.rankLabel.text = indexPath.row < 9 ? "0\(indexPath.row + 1)" : "\(indexPath.row + 1)"
        cell.mainTitleLabel.text = val.name
        cell.detailTitleLabel.text = "\(val.artists[0].name!)-\(val.album?.name ?? "")"
        if playSongService.currentPlaySong == indexPath.row && playSongService.playLists?.id == Int(playListID) {
            cell.rankLabel.isHidden = true
            cell.playingImageView.isHidden = false
        } else {
            cell.rankLabel.isHidden = false
            cell.playingImageView.isHidden = true
        }
        cell.rankLabel.textColor = indexPath.row < 3 ? FixedValue.mainRedColor : UIColor.lightGray
        cell.rankLabelConstraint.isActive = false
        cell.rankLabelCenterConstraint.isActive = true
        cell.mvPlayButton.isHidden = val.mvid == 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = PlaySongViewController()
        if Int(playListID) != playSongService.playLists?.id {
            vc.data = data
        } else {
            vc.data = playSongService.playLists
        }
        vc.currentSongIndex = (indexPath as NSIndexPath).row
        vc.isPlaying = true
        
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return isSectionInSelectedStyle ? self.selectedStyleCertainSongSheetSection : self.defaultStyleCertainSongSheetSection
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CertainSongSheetSection.sectionHeight
    }
}

class CertainSongSheetCell: UITableViewCell {
    static let identifier = "CertainSongSheetCell"
    
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var tendencyLabel: UILabel!
    @IBOutlet weak var playingImageView: UIImageView!
    
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var mvPlayButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    @IBOutlet weak var rankLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var rankLabelCenterConstraint: NSLayoutConstraint!
}

class CertainSongSheetTableViewHeadView: UIView {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var topLeftLabel: UILabel!
    @IBOutlet weak var topRightLabel: UILabel!
    @IBOutlet weak var bottomLeftLabel: UILabel!
    @IBOutlet weak var bottomRightLabel: UILabel!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var mainButton: UIButton!
    
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var downloadLabel: UILabel!
    
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var downloadImageView: UIImageView!
}

class CertainSongSheetSection: UIView {
    static let sectionHeight: CGFloat = 50
    let leftButton = UIButton()
    let rightButton = UIButton()
    let lineView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(leftButton)
        addSubview(rightButton)
        addSubview(lineView)
        
        lineView.backgroundColor = FixedValue.seperateLineColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        rightButton.height = 44
        rightButton.width = 44
        rightButton.right = self.right - 5
        rightButton.centerY = CertainSongSheetSection.sectionHeight/2
        
        leftButton.left = self.left + 10
        leftButton.height = 40
        leftButton.centerY = CertainSongSheetSection.sectionHeight/2
        leftButton.width = self.width - rightButton.width - 20
        
        
        lineView.height = 0.5
        lineView.width = self.width
        lineView.bottom = CertainSongSheetSection.sectionHeight - 0.5
        lineView.left = self.left
    }
}
