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

class RecommendViewController: BaseViewController {
    fileprivate lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: self.collectionViewFlowLayout)
        collectionView.frame = CGRect(x: 0, y:40 + 64, width:self.view.bounds.width, height:self.view.bounds.height - 40 - self.tabBarController!.tabBar.frame.size.height - 64)
        collectionView.backgroundColor = UIColor.clear
        let contentInsetValue: CGFloat = 10
        collectionView.contentInset = UIEdgeInsetsMake(contentInsetValue, contentInsetValue, contentInsetValue, contentInsetValue)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(RecommendViewCell.self, forCellWithReuseIdentifier:RecommendViewCell.identifier)
//        
//        collectionView.register(RecommendViewHeader.self, forCellWithReuseIdentifier:RecommendViewHeader.identifier)
//        collectionView.register(RecommendViewFooter.self, forCellWithReuseIdentifier:RecommendViewFooter.identifier)
//        collectionView.register(RecommendViewSection.self, forCellWithReuseIdentifier:RecommendViewSection.identifier)
        collectionView.register(RecommendViewHeader.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier:RecommendViewHeader.identifier)
        collectionView.register(RecommendViewFooter.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier:RecommendViewFooter.identifier)
        collectionView.register(RecommendViewSection.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier:RecommendViewSection.identifier)

        return collectionView
    }()
    
    fileprivate lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
//        layout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 100)
        layout.itemSize = CGSize(width: 145, height: 170)
        layout.minimumLineSpacing = 2
        layout.sectionInset = UIEdgeInsetsMake(2, 0, 5, 0)
        return layout
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
    }
}

extension RecommendViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: - DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return UICollectionReusableView()
    }
    
    // MARK: - Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    // Flow layout Delegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            // Global Header
            return CGSize(width: collectionView.frame.width, height: 120)
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
}

class RecommendViewFooter: UICollectionReusableView {
    static let identifier = "RecommendViewFooter"
    
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
