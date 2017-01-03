//
//  RecommendViewController.swift
//  NetEaseCloudMusic
//
//  Created by Ampire_Dan on 16/6/14.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit
import SnapKit

enum RecommentViewSections {
    case header
    case playlist
    case unique
    case newest
    case mv
    case radio
    case footer
}

class TestViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton()
        button.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        button.backgroundColor = UIColor.black
        button.addTarget(self, action: #selector(test), for: .touchUpInside)
        view.addSubview(button)
    }
    
    func test() {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.red
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

class RecommendViewController: BaseViewController {
    
    fileprivate lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: self.collectionViewFlowLayout)
        collectionView.frame = CGRect(x: 0, y:40 + 64, width:self.view.bounds.width, height:self.view.bounds.height - 40 - self.tabBarController!.tabBar.frame.size.height - 64)
        collectionView.backgroundColor = UIColor.clear
        let contentInsetValue: CGFloat = 0
        collectionView.contentInset = UIEdgeInsetsMake(contentInsetValue, contentInsetValue, contentInsetValue, contentInsetValue)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let headerNib = UINib.init(nibName: "RecommendViewHeader", bundle: nil)
        collectionView.register(headerNib, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier:RecommendViewHeader.identifier)
        let sectionNib = UINib.init(nibName: "RecommendViewSection", bundle: nil)
        collectionView.register(sectionNib, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier:RecommendViewSection.identifier)
        let footerNib = UINib.init(nibName: "RecommendViewFooter", bundle: nil)
        collectionView.register(footerNib, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier:RecommendViewFooter.identifier)
        let cellNib = UINib.init(nibName: "RecommendViewCell", bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier:RecommendViewCell.identifier)
        
        return collectionView
    }()
    
    let numberOfItemsArray = [0, 6, 3, 6, 4, 6, 0,]
    let sectionIconImageNameArray = ["", "cm2_discover_icn_recmd", "cm2_discover_icn_exclusive", "cm2_discover_icn_newest", "cm2_discover_icn_mv", "cm2_discover_icn_radio", "",]
    let sectionTitleNameArray = ["", "推荐歌单", "独家放送", "最新音乐", "推荐MV", "主播电台", "",]
    
    
    fileprivate lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return layout
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        view.backgroundColor = UIColor.white
    }
    
}

extension RecommendViewController:  UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfItemsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItemsArray[section]
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendViewCell.identifier, for: indexPath) as! RecommendViewCell
        cell.mainImageView.image = UIImage.init(named: "1.jpg")!
        
        cell.topLeftLabel.isHidden = true
        cell.topRightLabel.isHidden = true
        cell.bottomLeftLabel.isHidden = true
        cell.bottomRightLabel.isHidden = true
        
        if indexPath.section == 1 {
            cell.topRightLabel.isHidden = false
            
            let attachment = NSTextAttachment()
            attachment.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
            attachment.image = RecommendViewCell.getListenImage()
            let attachmentString = NSAttributedString(attachment: attachment)
            let myString = NSMutableAttributedString(string: "")
            myString.append(attachmentString)
            myString.append(NSAttributedString(string: "18万 "))
            cell.topRightLabel.attributedText = myString
        } else if indexPath.section == 2 {
            cell.topLeftLabel.isHidden = false
            
            let attachment = NSTextAttachment()
            attachment.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
            attachment.image = RecommendViewCell.getActImage()
            let attachmentString = NSAttributedString(attachment: attachment)
            let myString = NSMutableAttributedString(string: " ")
            myString.append(attachmentString)
            cell.topLeftLabel.attributedText = myString
        } else if indexPath.section == 3 {
        } else if indexPath.section == 4 {
            cell.topRightLabel.isHidden = false
            
            let attachment = NSTextAttachment()
            attachment.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
            attachment.image = RecommendViewCell.getVideoImage()
            let attachmentString = NSAttributedString(attachment: attachment)
            let myString = NSMutableAttributedString(string: "")
            myString.append(attachmentString)
            myString.append(NSAttributedString(string: "18万 "))
            cell.topRightLabel.attributedText = myString
        } else if indexPath.section == 5 {
            cell.bottomRightLabel.isHidden = false
        } else {
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 {
            // Global Header
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RecommendViewHeader.identifier, for: indexPath) as! RecommendViewHeader
            let image1 = UIImage.init(named: "1.jpg")!
            let image2 = UIImage.init(named: "2.jpg")!
            let image3 = UIImage.init(named: "3.jpg")!
            view.imageSliderView.images = [image1, image2, image3]
            view.imageSliderView.startToSlide()
            view.imageSliderView.imageContentMode = .scaleToFill
            return view
        } else if indexPath.section == collectionView.numberOfSections - 1 {
            // Global Footer
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RecommendViewFooter.identifier, for: indexPath) as! RecommendViewFooter
            return view
        } else {
            // Section Header
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RecommendViewSection.identifier, for: indexPath) as! RecommendViewSection
            view.iconImageView.image = UIImage.init(named: sectionIconImageNameArray[indexPath.section])
            view.titleLabel.text = sectionTitleNameArray[indexPath.section]
            return view
        }
    }
    
    
    // MARK: - Delegate
     
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = SliderViewController()
        
        let vc1 = TestViewController()
        vc1.view.backgroundColor = UIColor.blue
        let vc2 = UIViewController()
        vc2.view.backgroundColor = UIColor.brown
        let vc3 = UIViewController()
        vc3.view.backgroundColor = UIColor.purple
        
        vc.contentViewControllers = [vc1, vc2, vc3]
        vc.titleTexts = ["Oneoa", "Tw", "Threhhhhhhhh"]
        vc.currentIndex = 1
        vc.isNeedSeperateLineForEachItem = true
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func test() {
        let vvv = UIViewController()
        vvv.view.backgroundColor = UIColor.red
    }
    // Flow layout Delegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            // Global Header
            return CGSize(width: collectionView.bounds.width, height: self.view.width * 0.666)
        } else if section == collectionView.numberOfSections - 1 {
            // Global Footer
            return CGSize(width: collectionView.bounds.width, height: 130)
        } else {
            // Section Header
            return CGSize(width: collectionView.bounds.width, height: 30)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 1 {
            return CGSize(width: collectionView.width/3 - 40/3, height: collectionView.width/3 - 40/3 + 50)
        } else if indexPath.section == 2 {
            if indexPath.row == 2 {
                return CGSize(width: collectionView.width - 20/2, height: collectionView.width/3 - 40/3 + 50)
            }
            return CGSize(width: collectionView.width/2 - 30/2, height: collectionView.width/3 - 40/3 + 50)
        } else if indexPath.section == 3 {
            return CGSize(width: collectionView.width/3 - 40/3, height: collectionView.width/3 - 40/3 + 50)
        } else if indexPath.section == 4 {
            return CGSize(width: collectionView.width/2 - 30/2, height: collectionView.width/3 - 40/3 + 50)
        } else if indexPath.section == 5 {
            return CGSize(width: collectionView.width/3 - 40/3, height: collectionView.width/3 - 40/3 + 50)
        }
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
}

class RecommendViewHeader: UICollectionReusableView {
    static let identifier = "RecommendViewHeader"
    
    @IBOutlet weak var imageSliderView: ImageSliderView!
    @IBOutlet weak var personalFMButton: UIButton!
    @IBOutlet weak var dailySingRecommendButton: UIButton!
    @IBOutlet weak var hotMusicButton: UIButton!
    
}

class RecommendViewFooter: UICollectionReusableView {
    static let identifier = "RecommendViewFooter"
    
    @IBOutlet weak var adjustColButton: UIButton!
}

class RecommendViewSection: UICollectionReusableView {
    static let identifier = "RecommendViewSection"
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var moreButton: UILabel!
    @IBOutlet weak var moreArrowImageView: UIImageView!
}

class RecommendViewCell: UICollectionViewCell {
    static let identifier = "RecommendViewCell"
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var topLeftLabel: UILabel!
    @IBOutlet weak var topRightLabel: UILabel!
    @IBOutlet weak var bottomLeftLabel: UILabel!
    @IBOutlet weak var bottomRightLabel: UILabel!
    
    static func getListeningImage() -> UIImage {
        return UIImage.init(named: "")!
    }
    
    static func getFriendImage() -> UIImage {
        return UIImage.init(named: "cm2_btm_icn_friend")!
    }
    
    static func getInfoImage() -> UIImage {
        return UIImage.init(named: "cm2_discover_icn_i")!
    }
    
    static func getActImage() -> UIImage {
        return UIImage.init(named: "cm2_discover_icn_act")!
    }
    
    static func getVideoImage() -> UIImage {
        return UIImage.init(named: "cm2_discover_icn_video")!
    }
    
    static func getListenImage() -> UIImage {
        return UIImage.init(named: "cm2_note_icn_listen")!
    }
}
