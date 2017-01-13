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
    static let SongSheetCategory = "SongSheetCategory"
    fileprivate var collectData = [SongSheet]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    fileprivate lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: self.collectionViewFlowLayout)
        collectionView.frame = CGRect(x: 0, y: 0, width:self.view.bounds.width, height:self.view.bounds.height)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        let contentInsetValue: CGFloat = 10
        collectionView.contentInset = UIEdgeInsetsMake(contentInsetValue, contentInsetValue, contentInsetValue, contentInsetValue)
        
        let cellNib = UINib.init(nibName: "RecommendViewCell", bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier:RecommendViewCell.identifier)
        let headerNib = UINib.init(nibName: "SongSheetViewHeader", bundle: nil)
        collectionView.register(headerNib, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier:SongSheetViewHeader.identifier)
        let sectionNib = UINib.init(nibName: "SongSheetViewSection", bundle: nil)
        collectionView.register(sectionNib, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier:SongSheetViewSection.identifier)

        return collectionView
    }()
    
    fileprivate lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: self.view.width/2 - 30/2, height: self.view.width/2 - 30/2 + 40)
        return layout
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = self.view.bounds
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(self.collectionView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var category = "全部"
        if let c = UserDefaults.standard.value(forKey: SongSheetViewController.SongSheetCategory) as? String {
            category = c
        }
        SongSheet.loadSongSheetData(category: category, offset: 0, limited: 100) { (data, error) in
            if error == nil {
                self.collectData = data!
            }
        }

        sectionText = category == "全部" ? "全部歌单" : category
    }
    
    fileprivate var sectionText = "全部歌单" {
        didSet {
            
        }
    }
    
    func clickAllCategory(sender: UIButton) {
        let vc = FilterSongSheetViewController()
        vc.selectedText = sectionText
        self.navigationController?.pushViewController(vc, animated: true)
    }

}


extension SongSheetViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: - DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 0 : collectData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendViewCell.identifier, for: indexPath) as! RecommendViewCell
        let data =  collectData[indexPath.row]
        cell.mainTitleLabel.text = data.name
        cell.bottomLeftLabel.text = data.nickname
        cell.topRightLabel.text = "\(data.subscribedCount)"
        cell.topLeftLabel.isHidden = true
        cell.bottomRightLabel.isHidden = true
        cell.mainImageView.sd_setImage(with: URL.init(string: data.coverImgUrl)!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SongSheetViewSection.identifier, for: indexPath) as! SongSheetViewSection
            view.rightButton.addTarget(self, action: #selector(clickAllCategory(sender:)), for: .touchUpInside)
            return view
        } else {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SongSheetViewHeader.identifier, for: indexPath) as! SongSheetViewHeader
            view.leftImageView.image = UIImage.init(named: "1.jpg")
            return view
        }
    }
    
    // MARK: - Delegate
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if let sView = view as? SongSheetViewSection {
            sView.titleLabel.text = sectionText
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = CertainSongSheetViewController()
        vc.playListID = self.collectData[(indexPath as NSIndexPath).row].playListID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: - Layout Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: collectionView.bounds.width, height: 30)
        } else {
            return CGSize(width: collectionView.bounds.width, height: 90)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}

class SongSheetViewSection: UICollectionReusableView {
    static let identifier = "SongSheetViewSection"
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rightButton: UIButton!
}

class SongSheetViewHeader: UICollectionReusableView {
    static let identifier = "SongSheetViewHeader"
    
    @IBOutlet weak var leftImageView: UIImageView!
    
    @IBOutlet weak var rightControl: UIControl! {
        didSet {
        }
    }
    @IBOutlet weak var rcIconImageView: UIImageView!
    
    @IBOutlet weak var rcTitleLabel: UILabel!
    @IBOutlet weak var rcDetailLabel: UILabel!
    @IBOutlet weak var rcMoreImageView: UIImageView!
    
    @IBAction func touchRightControl(_ sender: UIControl) {
        print("touchRightControl")
    }
    
    
}
