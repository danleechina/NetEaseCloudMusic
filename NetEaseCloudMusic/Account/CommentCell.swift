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
            originalCommentInfoLabel.text = "dsfafdfadfasd说到发送 发士大夫撒的发发大发发发的反反复复反反复复发发发发发发发是短发短发短发；发发；身份卡是短发了卡大煞风景阿里斯顿放假啊是短发就啊说发fa"
        }
    }
    
    static let reuseIdentifier = "CommentCell"
    static func cellFor(table: UITableView) -> CommentCell {
        if let cell =  table.dequeueReusableCellWithIdentifier(reuseIdentifier) as? CommentCell{
            return cell
        }
        assert(false)
        return CommentCell()
    }
    
    
}
