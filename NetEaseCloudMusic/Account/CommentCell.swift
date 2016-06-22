//
//  CommentCell.swift
//  NetEaseCloudMusic
//
//  Created by Ampire_Dan on 16/6/22.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    
    @IBOutlet weak var headIconView: HeadIconView! {
        didSet {
            headIconView.image = UIImage.init(named: "first")
            headIconView.number = 0
            headIconView.rank = "V"
        }
    }
    
    @IBOutlet weak var nickNameLabel: UILabel! {
        didSet {
            nickNameLabel.text = "ampiredan leee"
        }
    }
    
    @IBOutlet weak var timeLabel: UILabel! {
        didSet {
            timeLabel.text = "10021dsaf"
        }
    }
    
    
    @IBOutlet weak var commentInfoLabel: UILabel! {
        didSet {
            commentInfoLabel.text = "dsfaddsfsdfsdfa"
        }
    }
    
    
    @IBOutlet weak var originalCommentInfoLabel: UILabel! {
        didSet {
            originalCommentInfoLabel.text = "dsfafdfadfasdfa"
        }
    }
    
    static let reuseIdentifier = "CommentCell"
    static func cellFor(table: UITableView) -> CommentCell {
        var cell = table.dequeueReusableCellWithIdentifier(reuseIdentifier) as? CommentCell
        if cell == nil {
            table.registerNib(UINib.init(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
            cell = table.dequeueReusableCellWithIdentifier(reuseIdentifier) as? CommentCell
        }
        return cell!
    }
    
    
}
