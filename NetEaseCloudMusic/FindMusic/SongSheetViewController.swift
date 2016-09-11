//
//  SongSheetViewController.swift
//  NetEaseCloudMusic
//
//  Created by Ampire_Dan on 16/6/14.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit
import SDWebImage

class SongSheetViewController: BaseViewController {
    private var collectData = [SongSheet]() {
        didSet {
            collectionView.reloadData()
        }
    }
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
        let vc = CertainSongSheetViewController()
        vc.playListID = self.collectData[indexPath.row].playListID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}




class SongSheetCollectionViewCell: UICollectionViewCell {
    static let identifier = "SongSheetCollectionViewCell"
    
    var modelData: SongSheet? = SongSheet() {
        didSet {
            if modelData != nil {
                titleLabel.text = modelData!.name
                imageContentView.authorLabel.text = modelData!.nickname
                imageContentView.subscribeLabel.text = "\(modelData!.subscribedCount)"
                imageContentView.imageView.sd_setImageWithURL(NSURL.init(string: self.modelData!.coverImgUrl)!)
            } else {
                imageContentView.authorLabel.text = nil
                imageContentView.subscribeLabel.text = nil
                imageContentView.imageView.image = nil
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
    
    private lazy var imageContentView: CertainSongSheetHeadImage = {
        let view = CertainSongSheetHeadImage()
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        addSubview(imageContentView)
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
    }
    
    override func prepareForReuse() {
        modelData = nil
        titleLabel.text = ""
    }
    
    
}

class CertainSongSheetHeadImage: UIView {
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage.init(named: ""))
        return imageView
    }()
    
    lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.text = "Dan Lee"
        label.font = UIFont.systemFontOfSize(12)
        label.textColor = UIColor.whiteColor()
        return label
    }()
    
    lazy var starImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage.init(named: "cm2_btm_icn_friend"))
        return imageView
    }()
    
    lazy var subscribeLabel: UILabel = {
        let label = UILabel()
        label.text = "1234567"
        label.font = UIFont.systemFontOfSize(12)
        label.textColor = UIColor.whiteColor()
        return label
    }()
    
    
    lazy var infoImageView: UIImageView = {
        let image = UIImageView.init(image: UIImage.init(named: "cm2_list_detail_icn_infor"))
        return image
    }()
    
    lazy var topMaskView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        return view
    }()
    
    lazy var bottomMaskView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(topMaskView)
        addSubview(bottomMaskView)
        addSubview(starImageView)
        addSubview(authorLabel)
        addSubview(subscribeLabel)
        addSubview(infoImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.snp_makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        
        starImageView.snp_makeConstraints { (make) in
            make.left.equalTo(imageView.snp_left).offset(5)
            make.centerY.equalTo(self.bottomMaskView.snp_centerY)
            make.height.equalTo(15)
            make.width.equalTo(15)
        }
        
        authorLabel.snp_makeConstraints { (make) in
            make.left.equalTo(starImageView.snp_right).offset(5)
            make.centerY.equalTo(self.bottomMaskView.snp_centerY)
        }
        
        subscribeLabel.snp_makeConstraints { (make) in
            make.right.equalTo(imageView.snp_right)
            make.top.equalTo(imageView.snp_top)
        }
        
        infoImageView.snp_makeConstraints { (make) in
            make.right.equalTo(self.snp_right)
            make.centerY.equalTo(self.bottomMaskView.snp_centerY)
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        
        bottomMaskView.snp_makeConstraints { (make) in
            make.bottom.equalTo(self.snp_bottom)
            make.width.equalTo(self.snp_width)
            make.height.equalTo(25)
            make.left.equalTo(self.snp_left)
        }
        
        topMaskView.snp_makeConstraints { (make) in
            make.top.equalTo(self.snp_top)
            make.width.equalTo(self.snp_width)
            make.height.equalTo(30)
            make.left.equalTo(self.snp_left)
        }
    }
    
}
