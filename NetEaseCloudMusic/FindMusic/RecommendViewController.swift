//
//  RecommendViewController.swift
//  NetEaseCloudMusic
//
//  Created by Ampire_Dan on 16/6/14.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit
import SnapKit

enum RecommentViewSection {
    case header
    case playlist
    case unique
    case newest
    case mv
    case radio
    case footer
}

class RecommendViewController: UICollectionViewController {
//    @IBOutlet var collectionView: UICollectionView! 
//    @IBOutlet weak var collectionView: UICollectionView!{
//        didSet {
//            collectionView.backgroundColor = UIColor.clear
//            let contentInsetValue: CGFloat = 10
//            collectionView.contentInset = UIEdgeInsetsMake(contentInsetValue, contentInsetValue, contentInsetValue, contentInsetValue)
//            collectionView.delegate = self
//            collectionView.dataSource = self
//            collectionView.register(RecommendViewCell.self, forCellWithReuseIdentifier:RecommendViewCell.identifier)
//            //
//            //        collectionView.register(RecommendViewHeader.self, forCellWithReuseIdentifier:RecommendViewHeader.identifier)
//            //        collectionView.register(RecommendViewFooter.self, forCellWithReuseIdentifier:RecommendViewFooter.identifier)
//            //        collectionView.register(RecommendViewSection.self, forCellWithReuseIdentifier:RecommendViewSection.identifier)
//            collectionView.register(RecommendViewHeader.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier:RecommendViewHeader.identifier)
//            collectionView.register(RecommendViewFooter.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier:RecommendViewFooter.identifier)
//            collectionView.register(RecommendViewSection.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier:RecommendViewSection.identifier)
//        }
//    }
//    fileprivate lazy var collectionView: UICollectionView = {
////        let collectionView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: self.collectionViewFlowLayout)
////        collectionView.frame = CGRect(x: 0, y:40 + 64, width:self.view.bounds.width, height:self.view.bounds.height - 40 - self.tabBarController!.tabBar.frame.size.height - 64)
//        collectionView.backgroundColor = UIColor.clear
//        let contentInsetValue: CGFloat = 10
//        collectionView.contentInset = UIEdgeInsetsMake(contentInsetValue, contentInsetValue, contentInsetValue, contentInsetValue)
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.register(RecommendViewCell.self, forCellWithReuseIdentifier:RecommendViewCell.identifier)
////        
////        collectionView.register(RecommendViewHeader.self, forCellWithReuseIdentifier:RecommendViewHeader.identifier)
////        collectionView.register(RecommendViewFooter.self, forCellWithReuseIdentifier:RecommendViewFooter.identifier)
////        collectionView.register(RecommendViewSection.self, forCellWithReuseIdentifier:RecommendViewSection.identifier)
//        collectionView.register(RecommendViewHeader.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier:RecommendViewHeader.identifier)
//        collectionView.register(RecommendViewFooter.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier:RecommendViewFooter.identifier)
//        collectionView.register(RecommendViewSection.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier:RecommendViewSection.identifier)
//
//        return collectionView
//    }()
    
    
    
    fileprivate lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
//        layout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 100)
        layout.itemSize = CGSize(width: 145, height: 170)
        layout.minimumLineSpacing = 2
        return layout
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
            collectionView?.backgroundColor = UIColor.clear
            let contentInsetValue: CGFloat = 10
            collectionView?.contentInset = UIEdgeInsetsMake(contentInsetValue, contentInsetValue, contentInsetValue, contentInsetValue)
            collectionView?.delegate = self
            collectionView?.dataSource = self
            collectionView?.register(RecommendViewCell.self, forCellWithReuseIdentifier:RecommendViewCell.identifier)
            //
            //        collectionView.register(RecommendViewHeader.self, forCellWithReuseIdentifier:RecommendViewHeader.identifier)
            //        collectionView.register(RecommendViewFooter.self, forCellWithReuseIdentifier:RecommendViewFooter.identifier)
            //        collectionView.register(RecommendViewSection.self, forCellWithReuseIdentifier:RecommendViewSection.identifier)
            collectionView?.register(RecommendViewHeader.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier:RecommendViewHeader.identifier)
            collectionView?.register(RecommendViewFooter.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier:RecommendViewFooter.identifier)
            collectionView?.register(RecommendViewSection.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier:RecommendViewSection.identifier)
        view.backgroundColor = UIColor.white
        
        
//        let imageSliderView = ImageSliderView.init()
//        let image1 = UIImage.init(named: "1.jpg")!
//        let image2 = UIImage.init(named: "2.jpg")!
//        let image3 = UIImage.init(named: "3.jpg")!
//        imageSliderView.images = [image1, image2, image3]
//        imageSliderView.startToSlide()
//        imageSliderView.frame = CGRect(x: 10, y: 70, width: 200, height: 200)
//        self.view.addSubview(imageSliderView)
    }
    
    
    
    // MARK: - DataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RecommendViewHeader.identifier, for: indexPath)
        return view
    }
    
    
    // MARK: - Delegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

extension RecommendViewController:  UICollectionViewDelegateFlowLayout {
    
    
    // Flow layout Delegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            // Global Header
            return CGSize(width: collectionView.frame.width, height: self.view.width * 0.666)
        } else if section == collectionView.numberOfSections - 1 {
            // Global Footer
            return CGSize(width: collectionView.frame.width, height: 100)
        } else {
            // Section Header
            return CGSize(width: collectionView.frame.width, height: 30)
        }
    }
}

class RecommendViewHeader: UICollectionReusableView {
    static let identifier = "RecommendViewHeader"
    
    @IBOutlet weak var imageSliderContainerView: UIView! {
        didSet {
            let imageSliderView = ImageSliderView()
            let image1 = UIImage.init(named: "1.jpg")!
            let image2 = UIImage.init(named: "2.jpg")!
            let image3 = UIImage.init(named: "3.jpg")!
            imageSliderView.images = [image1, image2, image3]
            imageSliderView.startToSlide()
            imageSliderView.imageContentMode = .scaleToFill
            imageSliderContainerView.addSubview(imageSliderView)
        }
    }
    
//    var imageSliderView: ImageSliderView!
//    var personalFMButton: LayoutButton!
//    var daysSingRecommendButton: LayoutButton!
//    var hotMusicButton: LayoutButton!
//    
//    var controlButtonView: UIView!
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        imageSliderView = ImageSliderView()
//        personalFMButton = LayoutButton()
//        daysSingRecommendButton = LayoutButton()
//        hotMusicButton = LayoutButton()
//        
//        personalFMButton.layoutButtonDirection = .topImageBottomText
//        daysSingRecommendButton.layoutButtonDirection = .topImageBottomText
//        hotMusicButton.layoutButtonDirection = .topImageBottomText
//        
//        personalFMButton.setTitle("私人FM", for: .normal)
//        daysSingRecommendButton.setTitle("每日歌曲推荐", for: .normal)
//        hotMusicButton.setTitle("云音乐热歌榜", for: .normal)
//        
//        personalFMButton.setBackgroundImage(UIImage.init(named: "cm2_discover_icn_daily"), for: .normal)
//        daysSingRecommendButton.setBackgroundImage(UIImage.init(named: "cm2_discover_icn_daily"), for: .normal)
//        hotMusicButton.setBackgroundImage(UIImage.init(named: "cm2_discover_icn_daily"), for: .normal)
//        
//        personalFMButton.setTitleColor(FixedValue.mainRedColor, for: .normal)
//        daysSingRecommendButton.setTitleColor(FixedValue.mainRedColor, for: .normal)
//        hotMusicButton.setTitleColor(FixedValue.mainRedColor, for: .normal)
//        
//        personalFMButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
//        hotMusicButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
//        daysSingRecommendButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
//        
//        personalFMButton.titleLabel?.sizeToFit()
//        hotMusicButton.titleLabel?.sizeToFit()
//        daysSingRecommendButton.titleLabel?.sizeToFit()
//        
//        personalFMButton.setImage(UIImage.init(named: "cm2_discover_icn_fm"), for: .normal)
//        personalFMButton.setImage(UIImage.init(named: "cm2_discover_icn_fm_prs"), for: .highlighted)
//
//        daysSingRecommendButton.setImage(UIImage.init(named: "cm2_discover_icn_upbill"), for: .normal)
//        daysSingRecommendButton.setImage(UIImage.init(named: "cm2_discover_icn_upbill"), for: .highlighted)
//        
//        hotMusicButton.setImage(UIImage.init(named: "cm2_discover_icn_upbill"), for: .normal)
//        hotMusicButton.setImage(UIImage.init(named: "cm2_discover_icn_upbill_prs"), for: .highlighted)
//        
//        self.addSubview(imageSliderView)
//        
//        controlButtonView = UIView()
//        self.addSubview(controlButtonView)
//        controlButtonView.addSubview(personalFMButton)
//        controlButtonView.addSubview(daysSingRecommendButton)
//        controlButtonView.addSubview(hotMusicButton)
//        
//        let image1 = UIImage.init(named: "1.jpg")!
//        let image2 = UIImage.init(named: "2.jpg")!
//        let image3 = UIImage.init(named: "3.jpg")!
//        imageSliderView.images = [image1, image2, image3]
//        imageSliderView.startToSlide()
//        imageSliderView.imageContentMode = .scaleToFill
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        imageSliderView.snp.makeConstraints { (make) in
//            make.top.left.width.equalTo(self)
//            make.height.equalTo(self.snp.width).multipliedBy(0.366)
//        }
//        
//        controlButtonView.snp.makeConstraints { (make) in
//            make.top.equalTo(self.imageSliderView.snp.bottom)
//            make.bottom.left.right.equalTo(self)
//        }
//        
//        let width =
//        personalFMButton.snp.makeConstraints { (make) in
//            make.centerX.equalTo(self.controlButtonView.snp.centerX).dividedBy(3)
//            make.width.height.equalTo(44)
//            make.centerY.equalTo(self.controlButtonView)
//        }
//        
//        daysSingRecommendButton.snp.makeConstraints { (make) in
//            make.centerX.equalTo(self.controlButtonView.snp.centerX)
//            make.width.height.equalTo(44)
//            make.centerY.equalTo(self.controlButtonView)
//        }
//        
//        hotMusicButton.snp.makeConstraints { (make) in
////            make.left.equalTo(self.controlButtonView.snp.width).multipliedBy(0.333)
//            make.width.height.equalTo(44)
//            make.centerY.equalTo(self.controlButtonView)
//        }
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
}

class RecommendViewFooter: UICollectionReusableView {
    static let identifier = "RecommendViewFooter"
    
    var label: UILabel!
    var button: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label = UILabel()
        label.text = "现在可以根据个人喜好，自由调整首页栏目顺序啦~"
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        
        button = UIButton()
        button.setTitle("调整栏目顺序", for: .normal)
        button.setTitleColor(FixedValue.mainRedColor, for: .normal)
        button.layer.cornerRadius = 8
        
        self.addSubview(label)
        self.addSubview(button)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(20)
        }
        
        button.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self.label.snp.bottom).offset(15)
            make.width.equalTo(100)
        }
    }
}

class RecommendViewSection: UICollectionReusableView {
    static let identifier = "RecommendViewSection"
    
    var iconImageView: UIImageView!
    var titleLabel: UILabel!
    var moreButton: UIButton!
    var moreArrImageView: UIImageView!
    
    override init(frame: CGRect) {
        iconImageView = UIImageView()
        titleLabel = UILabel()
        moreButton = UIButton()
        moreArrImageView = UIImageView()
        
        moreArrImageView.image = UIImage.init(named: "cm2_discover_icn_more")
        
        
        super.init(frame: frame)
        
        self.addSubview(iconImageView)
        self.addSubview(titleLabel)
        self.addSubview(moreButton)
        self.addSubview(moreArrImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.iconImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(16)
            make.centerY.equalTo(self)
            make.width.equalTo(30)
            make.height.equalTo(self)
        }
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.iconImageView.snp.right).offset(4)
            make.centerY.equalTo(self)
            make.right.equalTo(self.moreButton.snp.left)
            make.height.equalTo(self)
        }
        
        self.moreButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.moreArrImageView.snp.left).offset(-4)
            make.width.equalTo(12)
            make.centerY.equalTo(self)
            make.height.equalTo(self)
        }
        
        self.moreArrImageView.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-16)
            make.width.equalTo(12)
            make.centerY.equalTo(self)
            make.height.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RecommendViewCell: UICollectionViewCell {
    static let identifier = "RecommendViewCell"
    
}
