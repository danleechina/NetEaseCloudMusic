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
    var playListID = "" {
        didSet {
            if playListID != "" {
                CertainSongSheet.loadSongSheetData(self.playListID) { (data, error) in
                    if error == nil && data != nil {
                        self.data = data!
                    }
                }
            }
        }
    }
    
    var data: CertainSongSheet? {
        didSet {
            dispatch_async(dispatch_get_main_queue(), {
                if let nndata = self.data {
                    let attr1 = [NSForegroundColorAttributeName: UIColor.blackColor(),NSFontAttributeName: UIFont.systemFontOfSize(14)]
                    let attr2 = [NSForegroundColorAttributeName: UIColor.lightGrayColor(), NSFontAttributeName: UIFont.systemFontOfSize(11)]
                    let str1 = NSMutableAttributedString.init(string: "播放全部", attributes: attr1)
                    str1.appendAttributedString(NSAttributedString.init(string: "（共\(nndata.tracks.count)首）", attributes: attr2))
                    self.defaultStyleCertainSongSheetSection.leftButton.setAttributedTitle(str1, forState: .Normal)

                }
                self.tableView.reloadData()
            })

        }
    }
    
    var certainSongSheetTableViewHeadView: CertainSongSheetTableViewHeadView? {
        didSet {
            certainSongSheetTableViewHeadView?.headImageView.starImageView.hidden = true
            certainSongSheetTableViewHeadView?.headImageView.authorLabel.hidden = true
            certainSongSheetTableViewHeadView?.headImageView.bottomMaskView.hidden = true
            
            if let nndata = self.data {
                self.certainSongSheetTableViewHeadView?.headImageView.imageView.sd_setImageWithURL(NSURL.init(string: nndata.coverImgUrl))
                self.certainSongSheetTableViewHeadView?.blurBackgroundImageView.sd_setImageWithURL(NSURL.init(string: nndata.coverImgUrl))
                self.certainSongSheetTableViewHeadView?.titleLabel.text = nndata.name
                self.certainSongSheetTableViewHeadView?.authorLabel.text = nndata.creator.nickname
                
                self.certainSongSheetTableViewHeadView?.favoriteButton.setTitle("\(nndata.subscribedCount)", forState: .Normal)
                self.certainSongSheetTableViewHeadView?.commentButton.setTitle("\(nndata.commentCount)", forState: .Normal)
                self.certainSongSheetTableViewHeadView?.shareButton.setTitle("\(nndata.shareCount)", forState: .Normal)
                self.certainSongSheetTableViewHeadView?.downloadButton.setTitle("下载", forState: .Normal)
            }

        }
    }
    
    lazy var defaultStyleCertainSongSheetSection: CertainSongSheetSection = {
        let certainSongSheetSection = CertainSongSheetSection()
        certainSongSheetSection.leftButton.setImage(UIImage.init(named: "cm2_list_btn_play"), forState: .Normal)
        certainSongSheetSection.leftButton.setImage(UIImage.init(named: "cm2_list_btn_play_prs"), forState: .Highlighted)
        certainSongSheetSection.leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10)
        certainSongSheetSection.leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        certainSongSheetSection.leftButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        certainSongSheetSection.leftButton.contentHorizontalAlignment = .Left
        certainSongSheetSection.rightButton.setImage(UIImage.init(named: "cm2_list_icn_multi"), forState: .Normal)
        certainSongSheetSection.rightButton.setImage(UIImage.init(named: "cm2_list_icn_multi_prs"), forState: .Highlighted)
        certainSongSheetSection.backgroundColor = UIColor.whiteColor()
        return certainSongSheetSection
    }()
    
    var selectedStyleCertainSongSheetSection: CertainSongSheetSection = {
        let certainSongSheetSection = CertainSongSheetSection()
        certainSongSheetSection.leftButton.setImage(UIImage.init(named: "cm2_list_checkbox"), forState: .Normal)
        certainSongSheetSection.leftButton.setImage(UIImage.init(named: "cm2_list_checkbox_ok"), forState: .Selected)
        certainSongSheetSection.leftButton.setTitle("全选", forState: .Normal)
        certainSongSheetSection.leftButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        certainSongSheetSection.leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10)
        certainSongSheetSection.leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        certainSongSheetSection.leftButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        certainSongSheetSection.leftButton.contentHorizontalAlignment = .Left
        certainSongSheetSection.rightButton.setTitle("完成", forState: .Normal)
        certainSongSheetSection.rightButton.setTitleColor(FixedValue.mainRedColor, forState: .Normal)
        certainSongSheetSection.backgroundColor = UIColor.whiteColor()
        return certainSongSheetSection
    }()

    var isSectionInSelectedStyle = false
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clearColor()
        tableView.estimatedRowHeight = 64
        tableView.tableHeaderView = CertainSongSheetTableViewHeadView.init(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 190))
        tableView.tableFooterView = UIView()
        tableView.alwaysBounceVertical = true
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        self.certainSongSheetTableViewHeadView = self.tableView.tableHeaderView as? CertainSongSheetTableViewHeadView
        view.backgroundColor = UIColor.whiteColor()
    }
    
}


extension CertainSongSheetViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let d = data {
            return d.tracks.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = CertainSongSheetCell.cellFor(tableView) as! CertainSongSheetCell
        cell.orderLabel.text = "\(indexPath.row)"
        let val = (data!.tracks[indexPath.row])
        cell.titleLabel.text = val.name
        cell.detailLabel.text = "\(val.artists[0].name)-\(val.album.name)"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let vc = PlaySongViewController()
        vc.data = data
        vc.currentSongIndex = indexPath.row
        vc.isPlaying = true
        
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return isSectionInSelectedStyle ? self.selectedStyleCertainSongSheetSection : self.defaultStyleCertainSongSheetSection
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

class CertainSongSheetCell: UITableViewCell {
    static let identifier = "CertainSongSheetCell"
    
    lazy var orderLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .Center
        label.textColor = UIColor.lightGrayColor()
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .Left
        label.textColor = UIColor.blackColor()
        return label
    }()
    
    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .Left
        label.textColor = UIColor.lightGrayColor()
        label.font = UIFont.systemFontOfSize(12)
        return label
    }()
    
    lazy var moreButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.init(named: "cm2_list_btn_more"), forState: .Normal)
        button.setImage(UIImage.init(named: "cm2_list_btn_more_prs"), forState: .Highlighted)
        return button
    }()
    
    lazy var mvButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.init(named: "cm2_list_btn_icn_mv_new"), forState: .Normal)
        button.setImage(UIImage.init(named: "cm2_list_btn_icn_mv_new"), forState: .Highlighted)
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        orderLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.snp_left)
            make.width.equalTo(44)
            make.centerY.equalTo(self.snp_centerY)
        }
        
        titleLabel.snp_makeConstraints { (make) in
            make.left.equalTo(orderLabel.snp_right)
            make.right.equalTo(mvButton.snp_left)
            make.top.equalTo(self.snp_top)
            make.bottom.equalTo(self.snp_centerY)
        }
        
        detailLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.snp_centerY)
            make.left.equalTo(titleLabel.snp_left)
            make.right.equalTo(titleLabel.snp_right)
            make.bottom.equalTo(self.snp_bottom)
        }
        
        mvButton.snp_makeConstraints { (make) in
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.right.equalTo(moreButton.snp_left).offset(-10)
            make.centerY.equalTo(self.snp_centerY)
        }
        
        moreButton.snp_makeConstraints { (make) in
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.right.equalTo(self.snp_right).offset(-10)
            make.centerY.equalTo(self.snp_centerY)
        }
    }
    
    class func cellFor(tableView: UITableView) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(CertainSongSheetCell.identifier)
        if cell == nil {
            cell = CertainSongSheetCell.init(style: .Default, reuseIdentifier: CertainSongSheetCell.identifier)
        }
        
        return cell!
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(orderLabel)
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
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
    let backView = UIView()
    
    var blurBackgroundImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    var headImageView: CertainSongSheetHeadImage = {
        let headImageView = CertainSongSheetHeadImage()
        return headImageView
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.systemFontOfSize(14)
        label.numberOfLines = 2
        label.backgroundColor = UIColor.blackColor()
        return label
    }()
    
    var authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGrayColor()
        label.font = UIFont.systemFontOfSize(12)
        label.backgroundColor = UIColor.blackColor()
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
        stackView.axis = .Horizontal
        stackView.alignment = .Top
        stackView.spacing = 20
        stackView.distribution = .EqualCentering
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(blurBackgroundImageView)
        addSubview(backView)
        addSubview(headImageView)
        addSubview(titleLabel)
        addSubview(authorLabel)
        addSubview(bottomControlsStackView)
        blurBackgroundImageView.addSubview(visualEffectView)
        
        bottomControlsStackView.addArrangedSubview(favoriteButton)
        bottomControlsStackView.addArrangedSubview(commentButton)
        bottomControlsStackView.addArrangedSubview(shareButton)
        bottomControlsStackView.addArrangedSubview(downloadButton)
        
        backView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        blurBackgroundImageView.snp_makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        
        visualEffectView.snp_makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        
        backView.snp_makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        
        headImageView.snp_makeConstraints { (make) in
            make.top.equalTo(self.snp_top).offset(5)
            make.left.equalTo(self.snp_left).offset(5)
            make.width.equalTo(120)
            make.height.equalTo(120)
        }
        
        titleLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.headImageView.snp_top)
            make.left.equalTo(self.headImageView.snp_right).offset(10)
            make.right.equalTo(self.snp_right).offset(-5)
            make.bottom.equalTo(self.headImageView.snp_centerY).offset(-5)
        }
        
        authorLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.headImageView.snp_centerY)
            make.left.equalTo(self.titleLabel.snp_left)
            make.right.equalTo(self.titleLabel.snp_right)
            make.bottom.equalTo(self.headImageView.snp_bottom)
        }
        
        bottomControlsStackView.snp_makeConstraints { (make) in
            make.left.equalTo(self.headImageView.snp_left)
            make.right.equalTo(self.titleLabel.snp_right)
            make.top.equalTo(self.headImageView.snp_bottom).offset(10)
            make.bottom.equalTo(self.snp_bottom)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getCommonButton(normalImage: UIImage, highlightedImage: UIImage) -> UIButton {
        let button = UIButton()
        button.frame = CGRectMake(0, 0, 25, 50)
        let spacing:CGFloat = 5.0
        button.contentHorizontalAlignment = .Center
        button.contentVerticalAlignment = .Center
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(12)
        button.setImage(normalImage, forState: .Normal)
        button.setImage(highlightedImage, forState: .Highlighted)
        button.imageEdgeInsets =  UIEdgeInsetsMake(0, 0, 0, 0)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -25, -(40 + spacing), 0)

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
        
        leftButton.snp_makeConstraints { (make) in
            make.left.equalTo(self.snp_left)
            make.centerY.equalTo(self.snp_centerY)
            make.height.equalTo(40)
            make.right.equalTo(rightButton.snp_left)
        }
        
        rightButton.snp_makeConstraints { (make) in
            make.right.equalTo(self.snp_right).offset(-5)
            make.centerY.equalTo(self.snp_centerY)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}