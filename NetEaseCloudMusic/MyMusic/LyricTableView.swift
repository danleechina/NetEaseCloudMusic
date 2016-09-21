//
//  LyricTableView.swift
//  NetEaseCloudMusic
//
//  Created by Zhengda Lee on 9/10/16.
//  Copyright © 2016 Ampire_Dan. All rights reserved.
//

import UIKit
import SnapKit

class LyricTableView: UITableView {
    
    weak var lyricStateLabel: UILabel?
    weak var lyricTimeImageView: UIImageView?
    weak var lineView: UIView?
    weak var lyricTimeLabel: UILabel?
    var isUserDragging = false
    
    var songLyric: SongLyric? {
        didSet {
            dispatch_async(dispatch_get_main_queue()) {
                self.lyricStateLabel?.hidden = !((self.songLyric == nil) && !self.hidden)
                self.reloadData()
                if self.numberOfRowsInSection(0) <= 0 {
                    return
                }
                let indexPath = NSIndexPath.init(forRow: 0, inSection: 0)
                self.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Middle, animated: true)
            }
        }
    }
    func changeLyricPoint(isHidden: Bool) {
        lyricTimeLabel?.hidden = isHidden
        lyricTimeImageView?.hidden = isHidden
        lineView?.hidden = isHidden
    }
    
    func lyricTimeButtonTap() {
    }
    
    func getMiddleRow() -> Int {
        var ans = 0
        let currentMidY = CGRectGetMinY(self.bounds) + self.tableHeaderView!.bounds.size.height
        if self.visibleCells.count > 0 {
            for (idx, cell) in self.visibleCells.enumerate().reverse() {
                let cellY = CGRectGetMinY(cell.frame)
                ans = idx
                if cellY < currentMidY {
                    break
                }
            }
            let indexPath = self.indexPathForCell(self.visibleCells[ans])
            ans = indexPath!.row
        }
        return ans
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension LyricTableView: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("LyricCell")
        if cell == nil {
            cell = UITableViewCell.init(style: .Default, reuseIdentifier: "LyricCell")
            cell?.backgroundColor = UIColor.clearColor()
            cell?.textLabel?.textAlignment = .Center
            cell?.textLabel?.numberOfLines = 0
        }
        cell?.textLabel?.textColor = UIColor.lightGrayColor()
        cell?.textLabel?.text = songLyric?.lyricArray[indexPath.row]
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = songLyric?.lyricArray.count {
            return count
        }
        return 0
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if let indexPath = self.indexPathForRowAtPoint(CGPointMake(0, CGRectGetMinY(self.bounds) + self.tableHeaderView!.bounds.height)) {
            self.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Middle, animated: true)
        } else {
            if scrollView.contentOffset.y > 0 {
                if self.numberOfRowsInSection(0) == 0 {
                    return
                }
                let indexPath = NSIndexPath.init(forRow: self.numberOfRowsInSection(0) - 1, inSection: 0)
                self.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Middle, animated: true)
            }
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            if self.hidden || !self.dragging || !self.isUserDragging {
                self.changeLyricPoint(true)
            }
        })
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {

    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if let lyric = self.songLyric {
            let ans = getMiddleRow()
            lyricTimeLabel?.text = SongLyric.getFormatTimeStringFromNumValue(lyric.lyricTimeArray[ans])
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            if let indexPath = self.indexPathForRowAtPoint(CGPointMake(0, CGRectGetMinY(self.bounds) + self.tableHeaderView!.bounds.size.height)) {
                self.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Middle, animated: true)
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                if self.hidden || !self.dragging || !self.isUserDragging{
                    self.changeLyricPoint(true)
                }
            })
        }
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.isUserDragging = false
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.isUserDragging = true
        changeLyricPoint(false)
    }
}

class LyricCell: UITableViewCell {
    
}
