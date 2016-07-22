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
    var data = CertainSongSheet()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clearColor()
        tableView.estimatedRowHeight = 64
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        view.backgroundColor = UIColor.whiteColor()
        CertainSongSheet.loadSongSheetData { (data, error) in
            if error == nil && data != nil{
                self.data = data!
            }
        }
    }

}


extension CertainSongSheetViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.tracks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = CertainSongSheetCell.cellFor(tableView) as! CertainSongSheetCell
        cell.orderLabel.text = "\(indexPath.row)"
        cell.titleLabel.text = data.tracks[indexPath.row]["name"] as? String
        cell.detailLabel.text = "detail content"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let vc = PlaySongViewController()
        vc.mp3Url = data.tracks[indexPath.row]["mp3Url"] as! String
        vc.picUrl = data.tracks[indexPath.row]["album"]!["picUrl"] as! String
        vc.blurPicUrl = data.tracks[indexPath.row]["album"]!["blurPicUrl"] as! String
        vc.songname = data.tracks[indexPath.row]["name"] as! String
        vc.singers = data.tracks[indexPath.row]["artists"]![0]["name"] as! String
        
        
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
//        playMusic
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