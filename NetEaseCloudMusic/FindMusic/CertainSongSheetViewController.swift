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
                self.tableView.reloadData()
            })

        }
    }
    
    var certainSongSheetTableViewHeadView: CertainSongSheetTableViewHeadView? {
        didSet {
            certainSongSheetTableViewHeadView?.headImageView.starImageView.hidden = true
            certainSongSheetTableViewHeadView?.headImageView.authorLabel.hidden = true
            certainSongSheetTableViewHeadView?.headImageView.bottomMaskView.hidden = true
            certainSongSheetTableViewHeadView?.backgroundColor = UIColor.redColor()
            
            
            if let nndata = self.data {
                self.certainSongSheetTableViewHeadView?.headImageView.imageView.sd_setImageWithURL(NSURL.init(string: nndata.coverImgUrl))
                self.certainSongSheetTableViewHeadView?.titleLabel.text = nndata.name
                self.certainSongSheetTableViewHeadView?.authorLabel.text = nndata.creator.nickname
                
                self.certainSongSheetTableViewHeadView?.favoriteButton.setTitle("\(nndata.subscribedCount)", forState: .Normal)
                self.certainSongSheetTableViewHeadView?.commentButton.setTitle("\(nndata.commentCount)", forState: .Normal)
                self.certainSongSheetTableViewHeadView?.shareButton.setTitle("\(nndata.shareCount)", forState: .Normal)
                self.certainSongSheetTableViewHeadView?.downloadButton.setTitle("下载", forState: .Normal)
            }

        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clearColor()
        tableView.estimatedRowHeight = 64
        tableView.tableHeaderView = CertainSongSheetTableViewHeadView.init(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 190))
        tableView.tableFooterView = UIView()
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
        cell.titleLabel.text = (data!.tracks[indexPath.row]).name
        cell.detailLabel.text = "detail content"
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
    
}

class CertainSongSheetCell: UITableViewCell {
    static let identifier = "CertainSongSheetCell"
    
    lazy var orderLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .Center
        label.textColor = UIColor.lightGrayColor()
        return label
    }()
    
    lazy var titleLabel = UILabel()
    lazy var detailLabel = UILabel()
    lazy var leftView = UIView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        orderLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.snp_left)
            make.width.equalTo(44)
            make.centerY.equalTo(self.snp_centerY)
        }
        
        titleLabel.snp_makeConstraints { (make) in
            make.left.equalTo(orderLabel.snp_right)
            make.right.equalTo(leftView.snp_left)
            make.top.equalTo(self.snp_top)
            make.bottom.equalTo(self.snp_centerY)
        }
        
        detailLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.snp_centerY)
            make.left.equalTo(titleLabel.snp_left)
            make.right.equalTo(titleLabel.snp_right)
            make.bottom.equalTo(self.snp_bottom)
        }
        
        leftView.snp_makeConstraints { (make) in
            make.width.equalTo(44)
            make.right.equalTo(self.snp_right)
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
        addSubview(leftView)
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
        addSubview(headImageView)
        addSubview(titleLabel)
        addSubview(authorLabel)
        addSubview(bottomControlsStackView)
        
        bottomControlsStackView.addArrangedSubview(favoriteButton)
        bottomControlsStackView.addArrangedSubview(commentButton)
        bottomControlsStackView.addArrangedSubview(shareButton)
        bottomControlsStackView.addArrangedSubview(downloadButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
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
        button.imageEdgeInsets =  UIEdgeInsetsMake(-(10 + spacing), 0, 0, -10)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -30, -(30 + spacing), 0)
        button.contentHorizontalAlignment = .Center
        button.contentVerticalAlignment = .Center
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.setImage(normalImage, forState: .Normal)
        button.setImage(highlightedImage, forState: .Highlighted)
        return button
    }
}