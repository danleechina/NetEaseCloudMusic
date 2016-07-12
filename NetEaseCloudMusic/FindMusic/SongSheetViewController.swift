//
//  SongSheetViewController.swift
//  NetEaseCloudMusic
//
//  Created by Ampire_Dan on 16/6/14.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit

class SongSheetViewController: UIViewController {
    private var collectData = [SongSheet]()
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
        layout.itemSize = CGSizeMake(145, 170)
        layout.minimumLineSpacing = 2
        layout.sectionInset = UIEdgeInsetsMake(2, 0, 5, 0)
        return layout
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        view.addSubview(self.collectionView)
        
        SongSheet.loadSongSheetData { (data, error) in
            if error == nil {
                self.collectData = data!
            }
        }
    }

}


extension SongSheetViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: - DataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectData.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(SongSheetCollectionViewCell.identifier, forIndexPath: indexPath) as! SongSheetCollectionViewCell
        cell.modelData = collectData[indexPath.row]
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
    
    var modelData: SongSheet? = SongSheet() {
        didSet {
            if modelData != nil {
                titleLabel.text = modelData!.name
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    let imageData = NSData.init(contentsOfURL: NSURL.init(string: self.modelData!.coverImgUrl)!)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.imageView.image = UIImage.init(data: imageData!)
                    })
                }
                authorLabel.text = modelData!.nickname
                subscribeLabel.text = "\(modelData!.subscribedCount)"
            }
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.preferredMaxLayoutWidth = 145
        label.text = "this is title"
        label.textAlignment = .Center
        label.font = UIFont.systemFontOfSize(13)
        label.numberOfLines = 0
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
        label.font = UIFont.systemFontOfSize(10)
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
        label.font = UIFont.systemFontOfSize(10)
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
            make.edges.equalTo(self).inset(UIEdgeInsetsMake(0, 0, 40, 0))
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
    
    override func prepareForReuse() {
        modelData = nil
        titleLabel.text = ""
        imageView.image = nil
        authorLabel.text = ""
        subscribeLabel.text = ""
    }
    
    
}
