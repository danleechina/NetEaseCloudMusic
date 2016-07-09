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
        collectionView.registerClass(SongSheetCollectionViewCell.self, forCellWithReuseIdentifier:SongSheetCollectionViewCell.identifier)
        collectionView.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier:SongSheetCollectionViewCell.identifier)
        return collectionView
    }()
    
    private lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Vertical
        layout.headerReferenceSize = CGSizeMake(CGRectGetWidth(self.view.frame), 100)
        layout.itemSize = CGSizeMake(140, 120)
        
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
        cell.backgroundColor = UIColor.blueColor()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: SongSheetCollectionViewCell.identifier, forIndexPath: indexPath)
        view.backgroundColor = UIColor.redColor()
        return view
    }
    
    // MARK: - Delegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}




class SongSheetCollectionViewCell: UICollectionViewCell {
    static let identifier = "SongSheetCollectionViewCell"
    private var imageView = UIImageView()
    private var titleLabel = UILabel()
    private var authorLabel = UILabel()
    private var starImageView = UIImageView()
    private var subscribeLabel = UILabel()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
}
