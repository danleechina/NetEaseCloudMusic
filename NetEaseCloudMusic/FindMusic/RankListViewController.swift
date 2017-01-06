//
//  RankListViewController.swift
//  NetEaseCloudMusic
//
//  Created by Ampire_Dan on 16/6/14.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit

class RankListViewController: BaseViewController {
    
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
        
        let sectionNib = UINib.init(nibName: "SongSheetViewSection", bundle: nil)
        collectionView.register(sectionNib, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier:SongSheetViewSection.identifier)
        let cellNib = UINib.init(nibName: "RecommendViewCell", bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier:RecommendViewCell.identifier)
        let cell1Nib = UINib.init(nibName: "RankListViewCell", bundle: nil)
        collectionView.register(cell1Nib, forCellWithReuseIdentifier:RankListViewCell.identifier)
        
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
    
    fileprivate let numberOfItemsArray = [5, 20, 2]
    fileprivate let sectionTexts = ["云音乐官方榜", "全球榜", "用户榜",]
    
}

extension RankListViewController:  UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItemsArray[section]
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RankListViewCell.identifier, for: indexPath) as! RankListViewCell
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
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SongSheetViewSection.identifier, for: indexPath) as! SongSheetViewSection
        view.rightButton.isHidden = true
        view.titleLabel.text = sectionTexts[indexPath.section]
        return view
    }
    
    
    // MARK: - Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            let vc = RankUserViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // Flow layout Delegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionView.bounds.width - 16, height: 100)
        } else {
            return CGSize(width: collectionView.bounds.width/3 - 40/3, height: collectionView.bounds.width/3 - 40/3 + 30)
        }
    }

}

class RankListViewCell: UICollectionViewCell {
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var indicatorLabel: UILabel!
    
    @IBOutlet weak var lineView: UIView!
    
    
    static let identifier = "RankListViewCell"
}
