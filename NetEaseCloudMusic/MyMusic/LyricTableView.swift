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
            DispatchQueue.main.async {
                self.lyricStateLabel?.isHidden = !((self.songLyric == nil) && !self.isHidden)
                self.reloadData()
                if self.numberOfRows(inSection: 0) <= 0 {
                    return
                }
                let indexPath = IndexPath.init(row: 0, section: 0)
                self.scrollToRow(at: indexPath, at: .middle, animated: true)
            }
        }
    }
    func changeLyricPoint(_ isHidden: Bool) {
        lyricTimeLabel?.isHidden = isHidden
        lyricTimeImageView?.isHidden = isHidden
        lineView?.isHidden = isHidden
    }
    
    func lyricTimeButtonTap() {
    }
    
    func getMiddleRow() -> Int {
        var ans = 0
        let currentMidY = self.bounds.minY + self.tableHeaderView!.bounds.size.height
        if self.visibleCells.count > 0 {
            for (idx, cell) in self.visibleCells.enumerated().reversed() {
                let cellY = cell.frame.minY
                ans = idx
                if cellY < currentMidY {
                    break
                }
            }
            let indexPath = self.indexPath(for: self.visibleCells[ans])
            ans = (indexPath! as NSIndexPath).row
        }
        return ans
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension LyricTableView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "LyricCell")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "LyricCell")
            cell?.backgroundColor = UIColor.clear
            cell?.textLabel?.textAlignment = .center
            cell?.textLabel?.numberOfLines = 0
        }
        cell?.textLabel?.textColor = UIColor.lightGray
        cell?.textLabel?.text = songLyric?.lyricArray[(indexPath as NSIndexPath).row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = songLyric?.lyricArray.count {
            return count
        }
        return 0
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let indexPath = self.indexPathForRow(at: CGPoint(x: 0, y: self.bounds.minY + self.tableHeaderView!.bounds.height)) {
            self.scrollToRow(at: indexPath, at: .middle, animated: true)
        } else {
            if scrollView.contentOffset.y > 0 {
                if self.numberOfRows(inSection: 0) == 0 {
                    return
                }
                let indexPath = IndexPath.init(row: self.numberOfRows(inSection: 0) - 1, section: 0)
                self.scrollToRow(at: indexPath, at: .middle, animated: true)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            if self.isHidden || !self.isDragging || !self.isUserDragging {
                self.changeLyricPoint(true)
            }
        })
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let lyric = self.songLyric {
            let ans = getMiddleRow()
            if ans >= lyric.lyricTimeArray.count {
                return;
            }
            lyricTimeLabel?.text = SongLyric.getFormatTimeStringFromNumValue(lyric.lyricTimeArray[ans])
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            if let indexPath = self.indexPathForRow(at: CGPoint(x: 0, y: self.bounds.minY + self.tableHeaderView!.bounds.size.height)) {
                self.scrollToRow(at: indexPath, at: .middle, animated: true)
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                if self.isHidden || !self.isDragging || !self.isUserDragging{
                    self.changeLyricPoint(true)
                }
            })
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.isUserDragging = false
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isUserDragging = true
        changeLyricPoint(false)
    }
}

class LyricCell: UITableViewCell {
    
}
