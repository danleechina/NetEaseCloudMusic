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
            commentInfoLabel.text = "回复我：dsfaddsfsdfsdfa"
        }
    }
    
    
    @IBOutlet weak var originalCommentInfoLabel: UILabel! {
        didSet {
            originalCommentInfoLabel.text = "dsfafdfadfasdfa"
        }
    }
    
    static let reuseIdentifier = "CommentCell"
    static func cellFor(table: UITableView) -> CommentCell {
        if let cell =  table.dequeueReusableCellWithIdentifier(reuseIdentifier) as? CommentCell{
            
            cell.headIconView.image = UIImage.init(named: "first")
            cell.headIconView.number = 0
            cell.headIconView.rank = "V"
            cell.setNeedsUpdateConstraints()
            cell.updateConstraintsIfNeeded()
            return cell
        }
        assert(false)
        return CommentCell()
    }
    
    
}
