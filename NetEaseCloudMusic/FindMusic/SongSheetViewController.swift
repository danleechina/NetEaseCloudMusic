//
//  SongSheetViewController.swift
//  NetEaseCloudMusic
//
//  Created by Ampire_Dan on 16/6/14.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit

class SongSheetViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: self.collectionViewFlowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clearColor()
        let contentInsetValue: CGFloat = 10
        collectionView.contentInset = UIEdgeInsetsMake(contentInsetValue, contentInsetValue, contentInsetValue, contentInsetValue)
        collectionView.registerClass(SongSheetCollectionViewCell.self, forCellWithReuseIdentifier:SongSheetCollectionViewCell.identifier)
        collectionView.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier:SongSheetCollectionViewCell.identifier)
        return collectionView
    }()
    
    private lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Vertical
        layout.headerReferenceSize = CGSizeMake(CGRectGetWidth(self.view.frame), 100)
        layout.itemSize = CGSizeMake(145, 140)
        layout.minimumLineSpacing = 2
        layout.sectionInset = UIEdgeInsetsMake(2, 0, 5, 0)
        return layout
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        view.addSubview(self.collectionView)
    }

}


extension SongSheetViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: - DataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(SongSheetCollectionViewCell.identifier, forIndexPath: indexPath) as! SongSheetCollectionViewCell
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: SongSheetCollectionViewCell.identifier, forIndexPath: indexPath)
        view.backgroundColor = UIColor.lightGrayColor()
        return view
    }
    
    // MARK: - Delegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}




class SongSheetCollectionViewCell: UICollectionViewCell {
    static let identifier = "SongSheetCollectionViewCell"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "this is title"
        return label
    }()
    
    private lazy var imageContentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage.init(named: ""))
        return imageView
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.text = "Dan Lee"
        label.textColor = UIColor.whiteColor()
        return label
    }()
    
    private lazy var starImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage.init(named: "first"))
        return imageView
    }()
    
    private lazy var subscribeLabel: UILabel = {
        let label = UILabel()
        label.text = "1234567"
        label.textColor = UIColor.whiteColor()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        addSubview(imageContentView)
        
        imageContentView.addSubview(imageView)
        imageContentView.addSubview(starImageView)
        imageContentView.addSubview(authorLabel)
        imageContentView.addSubview(subscribeLabel)
        
        imageContentView.backgroundColor = UIColor.lightGrayColor()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.snp_makeConstraints { (make) in
            make.top.equalTo(imageContentView.snp_bottom)
            make.centerX.equalTo(imageContentView.snp_centerX)
        }
        
        imageContentView.snp_makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsetsMake(0, 0, 20, 0))
        }
        
        imageView.snp_makeConstraints { (make) in
            make.edges.equalTo(imageContentView).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        
        starImageView.snp_makeConstraints { (make) in
            make.left.equalTo(imageView.snp_left)
            make.bottom.equalTo(imageView.snp_bottom)
        }
        
        authorLabel.snp_makeConstraints { (make) in
            make.left.equalTo(starImageView.snp_right)
            make.bottom.equalTo(imageContentView.snp_bottom)
        }
        
        subscribeLabel.snp_makeConstraints { (make) in
            make.right.equalTo(imageView.snp_right)
            make.top.equalTo(imageView.snp_top)
        }
        
        
        
    }
    
}
