//
//  CommentListTableView.swift
//  NetEaseCloudMusic
//
//  Created by Ampire_Dan on 16/6/19.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit

class CommentListTableView: BaseTableView {

}


class CommentCell: BaseTableViewCell {
    
    static let reuseIdentifier = "CommentCell"
    static func cellFor(table: UITableView) -> CommentCell {
        var cell = table.dequeueReusableCellWithIdentifier(reuseIdentifier) as? CommentCell
        if cell == nil {
            cell = CommentCell.init(style: .Default, reuseIdentifier: reuseIdentifier)
        }
        return cell!
    }
    
    override func setData() -> Void {
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}