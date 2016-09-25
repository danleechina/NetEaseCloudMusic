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
    fileprivate var collectData = [SongSheet]() {
        didSet {
            collectionView.reloadData()
        }
    }
    fileprivate lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: self.collectionViewFlowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        let contentInsetValue: CGFloat = 10
        collectionView.contentInset = UIEdgeInsetsMake(contentInsetValue, contentInsetValue, contentInsetValue, contentInsetValue)
        collectionView.register(SongSheetCollectionViewCell.self, forCellWithReuseIdentifier:SongSheetCollectionViewCell.identifier)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier:SongSheetCollectionViewCell.identifier)
        return collectionView
    }()
    
    fileprivate lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 100)
        layout.itemSize = CGSize(width: 145, height: 170)
        layout.minimumLineSpacing = 2
        layout.sectionInset = UIEdgeInsetsMake(2, 0, 5, 0)
        return layout
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SongSheetCollectionViewCell.identifier, for: indexPath) as! SongSheetCollectionViewCell
        cell.modelData = collectData[(indexPath as NSIndexPath).row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SongSheetCollectionViewCell.identifier, for: indexPath)
        view.backgroundColor = UIColor.lightGray
        return view
    }
    
    // MARK: - Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = CertainSongSheetViewController()
        vc.playListID = self.collectData[(indexPath as NSIndexPath).row].playListID
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
                imageContentView.imageView.sd_setImage(with: URL.init(string: self.modelData!.coverImgUrl)!)
            } else {
                imageContentView.authorLabel.text = nil
                imageContentView.subscribeLabel.text = nil
                imageContentView.imageView.image = nil
            }
        }
    }
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.preferredMaxLayoutWidth = 145
        label.text = "this is title"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate lazy var imageContentView: CertainSongSheetHeadImage = {
        let view = CertainSongSheetHeadImage()
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        addSubview(imageContentView)
        imageContentView.backgroundColor = UIColor.lightGray
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageContentView.snp.bottom)
            make.centerX.equalTo(imageContentView.snp.centerX)
        }
        
        imageContentView.snp.makeConstraints { (make) in
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
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.white
        return label
    }()
    
    lazy var starImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage.init(named: "cm2_btm_icn_friend"))
        return imageView
    }()
    
    lazy var subscribeLabel: UILabel = {
        let label = UILabel()
        label.text = "1234567"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.white
        return label
    }()
    
    
    lazy var infoImageView: UIImageView = {
        let image = UIImageView.init(image: UIImage.init(named: "cm2_list_detail_icn_infor"))
        return image
    }()
    
    lazy var topMaskView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        return view
    }()
    
    lazy var bottomMaskView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
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
        
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        
        starImageView.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp.left).offset(5)
            make.centerY.equalTo(self.bottomMaskView.snp.centerY)
            make.height.equalTo(15)
            make.width.equalTo(15)
        }
        
        authorLabel.snp.makeConstraints { (make) in
            make.left.equalTo(starImageView.snp.right).offset(5)
            make.centerY.equalTo(self.bottomMaskView.snp.centerY)
        }
        
        subscribeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(imageView.snp.right)
            make.top.equalTo(imageView.snp.top)
        }
        
        infoImageView.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.right)
            make.centerY.equalTo(self.bottomMaskView.snp.centerY)
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        
        bottomMaskView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.snp.bottom)
            make.width.equalTo(self.snp.width)
            make.height.equalTo(25)
            make.left.equalTo(self.snp.left)
        }
        
        topMaskView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.width.equalTo(self.snp.width)
            make.height.equalTo(30)
            make.left.equalTo(self.snp.left)
        }
    }
    
}
