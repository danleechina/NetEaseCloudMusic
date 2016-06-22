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
            
        }
    }
    
    @IBOutlet weak var timeLabel: UILabel! {
        didSet {
            
        }
    }
    
    
    @IBOutlet weak var commentInfoLabel: UILabel! {
        didSet {
            
        }
    }
    
    
    @IBOutlet weak var originalCommentInfoLabel: UILabel! {
        didSet {
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    static let reuseIdentifier = "CommentCell"
    static func cellFor(table: UITableView) -> CommentCell {
        var cell = table.dequeueReusableCellWithIdentifier(reuseIdentifier) as? CommentCell
        if cell == nil {
            cell = CommentCell.init(style: .Default, reuseIdentifier: reuseIdentifier)
        }
        return cell!
    }
    
    
}
