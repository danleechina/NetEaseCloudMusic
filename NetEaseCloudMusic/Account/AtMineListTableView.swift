//
//  AtMineListTableView.swift
//  NetEaseCloudMusic
//
//  Created by Ampire_Dan on 16/6/19.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit

class AtMineListTableView: BaseTableView {

}


class AtMineCell: BaseTableViewCell {
    static let reuseIdentifier = "AtMineCell"
    static func cellFor(table: UITableView) -> AtMineCell {
        var cell = table.dequeueReusableCellWithIdentifier(reuseIdentifier) as? AtMineCell
        if cell == nil {
            cell = AtMineCell.init(style: .Default, reuseIdentifier: reuseIdentifier)
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