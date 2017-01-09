//
//  CertainSongSheetViewController.swift
//  NetEaseCloudMusic
//
//  Created by Ampire_Dan on 2016/7/14.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit
import SnapKit

class CertainSongSheetViewController: BaseViewController {
    
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    let backView = UIView()
    
    var blurBackgroundImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
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
                        self.certainSongSheetTableViewHeadView?.headImageView.imageView.sd_setImage(with: URL.init(string: coverImgUrl))
                        self.blurBackgroundImageView.sd_setImage(with: URL.init(string: coverImgUrl))
                    }
                    self.certainSongSheetTableViewHeadView?.titleLabel.text = nndata.name
                    self.marqueeTitleLabel.text = nndata.name ?? "歌单"
                    self.certainSongSheetTableViewHeadView?.authorLabel.text = nndata.creator?.nickname ?? "用户名"
                    self.certainSongSheetTableViewHeadView?.favoriteButton.setTitle("\(nndata.subscribedCount)", for: UIControlState())
                    self.certainSongSheetTableViewHeadView?.commentButton.setTitle("\(nndata.commentCount)", for: UIControlState())
                    self.certainSongSheetTableViewHeadView?.shareButton.setTitle("\(nndata.shareCount)", for: UIControlState())
                    self.certainSongSheetTableViewHeadView?.downloadButton.setTitle("下载", for: UIControlState())
                }
                self.tableView.reloadData()
            })

        }
    }
    
    let playSongService: PlaySongService = PlaySongService.sharedInstance
    
    var certainSongSheetTableViewHeadView: CertainSongSheetTableViewHeadView? {
        didSet {
            certainSongSheetTableViewHeadView?.headImageView.starImageView.isHidden = true
            certainSongSheetTableViewHeadView?.headImageView.authorLabel.isHidden = true
            certainSongSheetTableViewHeadView?.headImageView.bottomMaskView.isHidden = true
        }
    }
    
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
        tableView.estimatedRowHeight = 64
        tableView.tableHeaderView = CertainSongSheetTableViewHeadView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 190))
        tableView.tableFooterView = UIView()
        tableView.alwaysBounceVertical = true
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
        self.certainSongSheetTableViewHeadView = self.tableView.tableHeaderView as? CertainSongSheetTableViewHeadView
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
        let cell = CertainSongSheetCell.cellFor(tableView) as! CertainSongSheetCell
        cell.orderLabel.text = "\((indexPath as NSIndexPath).row + 1)"
        let val = (data!.tracks[(indexPath as NSIndexPath).row])
        cell.titleLabel.text = val.name
        cell.detailLabel.text = "\(val.artists[0].name!)-\(val.album?.name ?? "")"
        if playSongService.currentPlaySong == (indexPath as NSIndexPath).row && playSongService.playLists?.id == Int(playListID) {
            cell.orderLabel.isHidden = true
            cell.isPlayingImageView.isHidden = false
        } else {
            cell.orderLabel.isHidden = false
            cell.isPlayingImageView.isHidden = true
        }
        
        if val.mvid == 0 {
            cell.mvButton.isHidden = true
        } else {
            cell.mvButton.isHidden = false
        }
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
        return 50
    }
}

class CertainSongSheetCell: UITableViewCell {
    static let identifier = "CertainSongSheetCell"
    
    lazy var orderLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.lightGray
        return label
    }()
    
    lazy var isPlayingImageView: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "cm2_icn_volume"))
        imageView.contentMode = .center
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.black
        return label
    }()
    
    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    lazy var moreButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.init(named: "cm2_list_btn_more"), for: UIControlState())
        button.setImage(UIImage.init(named: "cm2_list_btn_more_prs"), for: .highlighted)
        return button
    }()
    
    lazy var mvButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.init(named: "cm2_list_btn_icn_mv_new"), for: UIControlState())
        button.setImage(UIImage.init(named: "cm2_list_btn_icn_mv_new"), for: .highlighted)
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        orderLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left)
            make.width.equalTo(44)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        isPlayingImageView.snp.makeConstraints { (make) in
            make.width.equalTo(20)
            make.height.equalTo(20)
            make.centerY.equalTo(self.snp.centerY)
            make.centerX.equalTo(self.snp.left).offset(22)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(orderLabel.snp.right)
            make.right.equalTo(mvButton.snp.left)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.centerY)
        }
        
        detailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.centerY)
            make.left.equalTo(titleLabel.snp.left)
            make.right.equalTo(titleLabel.snp.right)
            make.bottom.equalTo(self.snp.bottom)
        }
        
        mvButton.snp.makeConstraints { (make) in
            make.width.equalTo(44)
            make.height.equalTo(44)
            make.right.equalTo(moreButton.snp.left)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        moreButton.snp.makeConstraints { (make) in
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.right.equalTo(self.snp.right).offset(-10)
            make.centerY.equalTo(self.snp.centerY)
        }
    }
    
    class func cellFor(_ tableView: UITableView) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: CertainSongSheetCell.identifier)
        if cell == nil {
            cell = CertainSongSheetCell.init(style: .default, reuseIdentifier: CertainSongSheetCell.identifier)
        }
        
        return cell!
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(orderLabel)
        addSubview(isPlayingImageView)
        addSubview(titleLabel)
        addSubview(detailLabel)
        addSubview(moreButton)
        addSubview(mvButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CertainSongSheetTableViewHeadView: UIView {
    
    var headImageView: CertainSongSheetHeadImage = {
        let headImageView = CertainSongSheetHeadImage()
        return headImageView
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 2
        label.backgroundColor = UIColor.black
        return label
    }()
    
    var authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.backgroundColor = UIColor.black
        return label
    }()
    
    lazy var favoriteButton: UIButton = {
        return self.getCommonButton(UIImage.init(named: "cm2_list_detail_icn_fav_new")!, highlightedImage: UIImage.init(named: "cm2_list_detail_icn_fav_new_prs")!)
    }()
    
    lazy var commentButton: UIButton = {
        return self.getCommonButton(UIImage.init(named: "cm2_list_detail_icn_cmt")!, highlightedImage: UIImage.init(named: "cm2_list_detail_icn_cmt_prs")!)
    }()
    
    lazy var shareButton: UIButton = {
        return self.getCommonButton(UIImage.init(named: "cm2_list_detail_icn_share")!, highlightedImage: UIImage.init(named: "cm2_list_detail_icn_share_prs")!)

    }()
    
    lazy var downloadButton: UIButton = {
        return self.getCommonButton(UIImage.init(named: "cm2_list_detail_icn_dld")!, highlightedImage: UIImage.init(named: "cm2_list_detail_icn_dld_prs")!)

    }()
    
    var bottomControlsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.spacing = 20
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headImageView)
        addSubview(titleLabel)
        addSubview(authorLabel)
        addSubview(bottomControlsStackView)
        
        bottomControlsStackView.addArrangedSubview(favoriteButton)
        bottomControlsStackView.addArrangedSubview(commentButton)
        bottomControlsStackView.addArrangedSubview(shareButton)
        bottomControlsStackView.addArrangedSubview(downloadButton)
        self.backgroundColor = UIColor.clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        headImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(5)
            make.left.equalTo(self.snp.left).offset(5)
            make.width.equalTo(120)
            make.height.equalTo(120)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.headImageView.snp.top)
            make.left.equalTo(self.headImageView.snp.right).offset(10)
            make.right.equalTo(self.snp.right).offset(-5)
            make.bottom.equalTo(self.headImageView.snp.centerY).offset(-5)
        }
        
        authorLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.headImageView.snp.centerY)
            make.left.equalTo(self.titleLabel.snp.left)
            make.right.equalTo(self.titleLabel.snp.right)
            make.bottom.equalTo(self.headImageView.snp.bottom)
        }
        
        bottomControlsStackView.snp.makeConstraints { (make) in
            make.left.equalTo(self.headImageView.snp.left)
            make.right.equalTo(self.titleLabel.snp.right)
            make.top.equalTo(self.headImageView.snp.bottom).offset(10)
            make.bottom.equalTo(self.snp.bottom)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getCommonButton(_ normalImage: UIImage, highlightedImage: UIImage) -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 25, height: 50)
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setImage(normalImage, for: UIControlState())
        button.setImage(highlightedImage, for: .highlighted)
        button.imageEdgeInsets =  UIEdgeInsetsMake(0, normalImage.size.width/2, 0, 0)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -normalImage.size.width/2, -normalImage.size.height, 0)
        return button
    }
}

class CertainSongSheetSection: UIView {
    let leftButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    let rightButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
//    let bottomLine
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(leftButton)
        addSubview(rightButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        leftButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left)
            make.centerY.equalTo(self.snp.centerY)
            make.height.equalTo(40)
            make.right.equalTo(rightButton.snp.left)
        }
        
        rightButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.right).offset(-5)
            make.centerY.equalTo(self.snp.centerY)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
