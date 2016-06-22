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


class CommentListDAD: NSObject, UITableViewDelegate, UITableViewDataSource {
    var models:Array<PrivateMessageModel> = [PrivateMessageModel]()
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = CommentCell.cellFor(tableView)
//        cell.model = CommentCell.dictToModel(nil)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return models.count
        return 2
    }
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 110
//    }
}