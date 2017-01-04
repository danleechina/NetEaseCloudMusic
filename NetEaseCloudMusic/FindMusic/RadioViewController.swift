//
//  RadioViewController.swift
//  NetEaseCloudMusic
//
//  Created by Ampire_Dan on 16/6/14.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit

class RadioViewController: BaseViewController {
    
    fileprivate lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: self.collectionViewFlowLayout)
        collectionView.frame = CGRect(x: 0,
                                      y: 0,
                                      width:self.view.bounds.width,
                                      height:self.view.bounds.height)
        collectionView.backgroundColor = UIColor.clear
        let contentInsetValue: CGFloat = 8
        collectionView.contentInset = UIEdgeInsetsMake(contentInsetValue, contentInsetValue, contentInsetValue, contentInsetValue)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let headerNib = UINib.init(nibName: "RadioViewHeader", bundle: nil)
        collectionView.register(headerNib, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier:RadioViewHeader.identifier)
        let oneCellNib = UINib.init(nibName: "RadioViewOneCell", bundle: nil)
        collectionView.register(oneCellNib, forCellWithReuseIdentifier:RadioViewOneCell.identifier)
        let twoCellNib = UINib.init(nibName: "RadioViewTwoCell", bundle: nil)
        collectionView.register(twoCellNib, forCellWithReuseIdentifier:RadioViewTwoCell.identifier)
        
        let sectionNib = UINib.init(nibName: "SongSheetViewSection", bundle: nil)
        collectionView.register(sectionNib, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier:SongSheetViewSection.identifier)
        let cellNib = UINib.init(nibName: "RecommendViewCell", bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier:RecommendViewCell.identifier)
        return collectionView
    }()
    
    fileprivate lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return layout
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = self.view.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        view.backgroundColor = UIColor.white
    }
    
    fileprivate let numberOfItemsArray = [1, 4, 6, 10]
    fileprivate let sectionTexts = ["", "精彩节目推荐", "每天精选电台-订阅更精彩", "热门电台",]
    
    fileprivate func tapHeaderViewItemAction(sender: UIView?) {
        if let view = sender {
            let label =  view.subviews.filter({ (view) -> Bool in
                return view.isKind(of: UILabel.self)
            }).first as? UILabel
            let vc = RadioListViewController()
            vc.titleText = label?.text ?? "No text"
            vc.titleTexts = ["最近流行", "最热电台"]
            
            let vc1 = RadioOneTableViewController()
            vc1.dataType = 0
            
            let vc2 = RadioOneTableViewController()
            vc2.dataType = 1
            
            vc.contentViewControllers = [vc1, vc2]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    fileprivate func tapRadioViewOneCell() {
        
        let vc1 = RadioTwoTableViewController()
        vc1.dataType = 0
        let vc2 = RadioTwoTableViewController()
        vc1.dataType = 1
        let vc3 = RadioTwoTableViewController()
        vc1.dataType = 2
        
        let vc = RadioListViewController()
        vc.titleText = "主播电台排行榜"
        vc.titleTexts = ["节目", "新晋电台", "最热电台",]
        vc.contentViewControllers = [vc1, vc2, vc3,]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension RadioViewController:  UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItemsArray[section]
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RadioViewOneCell.identifier, for: indexPath) as! RadioViewOneCell
            cell.rightImageView.image = UIImage.init(named: "1.jpg")!
            let detailText = NSMutableAttributedString.init(string: "最火的节目和电台，每天更新", attributes: nil)
            detailText.addAttribute(NSForegroundColorAttributeName, value: FixedValue.mainRedColor, range: NSRange.init(location: 0, length: 9))
            detailText.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGray, range: NSRange.init(location: 9, length: 4))
            cell.detailLabel.attributedText = detailText
            
            let attachment = NSTextAttachment()
            attachment.bounds = CGRect(x: 0, y: 0, width: 10, height: 10)
            attachment.image = UIImage.init(named: "cm2_discover_icn_more")
            let attachmentString = NSAttributedString(attachment: attachment)
            let titleText = NSMutableAttributedString(string: "主播电台排行榜 ")
            titleText.append(attachmentString)
            cell.titleLabel.attributedText = titleText
            return cell
        } else if indexPath.section == 1 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RadioViewTwoCell.identifier, for: indexPath) as! RadioViewTwoCell
            cell.leftImageView.image = UIImage.init(named: "1.jpg")!
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendViewCell.identifier, for: indexPath) as! RecommendViewCell
            cell.mainImageView.image = UIImage.init(named: "1.jpg")!
            
            cell.topLeftLabel.isHidden = true
            cell.topRightLabel.isHidden = true
            cell.bottomLeftLabel.isHidden = true
            cell.bottomRightLabel.isHidden = true
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            // Global Header
        if indexPath.section == 0 {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RadioViewHeader.identifier, for: indexPath) as! RadioViewHeader
            view.tapItemAction = tapHeaderViewItemAction
            view.contentView.frame = CGRect(x: 0, y: 0, width: collectionView.width * 3, height: 135)
            view.scrollView.frame = CGRect(x: 0, y: 0, width: collectionView.width, height: 135)
            view.scrollView.contentSize = CGSize(width: collectionView.width * 3, height: 135)
            return view
        } else {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SongSheetViewSection.identifier, for: indexPath) as! SongSheetViewSection
            view.rightButton.isHidden = true
            view.titleLabel.text = sectionTexts[indexPath.section]
            return view
        }
    }
    
    
    // MARK: - Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0{
            tapRadioViewOneCell()
        } else if indexPath.section >= 2 {
            let vc = RadioDetailListViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // Flow layout Delegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: collectionView.bounds.width * 3, height: 150)
        } else {
            return CGSize(width: collectionView.bounds.width, height: 30)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let margin: CGFloat = 8
        if indexPath.section == 0 {
            return CGSize(width: collectionView.bounds.width - 2 * margin, height: 80)
        } else if indexPath.section == 1 {
            return CGSize(width: collectionView.bounds.width, height: 64)
        } else if indexPath.section == 2 {
            return CGSize(width: collectionView.bounds.width/3 - 40/3, height: collectionView.bounds.width/3 - 40/3 + 30)
        } else if indexPath.section == 3 {
            return CGSize(width: collectionView.bounds.width/2 - 30/2, height: collectionView.bounds.width/2 - 30/2 + 20)
        }
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsetsMake(10, 10, 20, 10)
        }
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
}


class RadioViewHeader: UICollectionReusableView, UIScrollViewDelegate {
    static let identifier = "RadioViewHeader"
    
    var tapItemAction: ((_ sender: UIView?)->())?
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
        }
    }
    @IBOutlet weak var contentView: UIView! {
        didSet {
            for view in contentView.subviews {
                let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(sender:)))
                view.addGestureRecognizer(tap)
            }
        }
    }
    
    @IBAction func changePage(_ sender: UIPageControl) {
        scrollView.setContentOffset(CGPoint(x: CGFloat(sender.currentPage) * scrollView.frame.width, y: 0), animated: false)
    }
    
    func tapAction(sender: UITapGestureRecognizer) {
        tapItemAction?(sender.view)
    }
    
    
    // MARK: Scroll View Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = Int((scrollView.contentOffset.x + scrollView.frame.width/2) / scrollView.frame.width)
        pageControl.currentPage = index
    }
}

class RadioViewOneCell: UICollectionViewCell {
    static let identifier = "RadioViewOneCell"
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
}

class RadioViewTwoCell: UICollectionViewCell {
    static let identifier = "RadioViewTwoCell"
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
}
