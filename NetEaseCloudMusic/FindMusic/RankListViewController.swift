//
//  RankListViewController.swift
//  NetEaseCloudMusic
//
//  Created by Ampire_Dan on 16/6/14.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit

// TODO: 
// 1. 数据请求优化
// 2. 数据缓存
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
        loadData()
    }
    
    fileprivate func loadData() {
        for id in topListID {
            loadRankSongListData(index: id)
        }
    }
    
    fileprivate func loadRankSongListData(index: String) {
        PlayList.loadSongSheetData(index) { (playList, error) in
            if let err = error {
                print(err)
            } else {
                self.data[index] = playList
            }
        }
    }
    
    fileprivate let numberOfItemsArray = [4, 20, 2]
    fileprivate let sectionTexts = ["云音乐官方榜", "全球榜", "用户榜"]
    fileprivate let updateTexts = ["每天更新", "每天更新", "每周四更新", "每周四更新",
                                   
                                   "每周五更新","每周四更新","每周一更新",
                                   "每周一更新","每周一更新","每周四更新",
                                   "每周三更新","每周四更新","每周一更新",
                                   "每周三更新","每周五更新","每周一更新",
                                   "每周一更新", "每周五更新", "每周一更新",
                                   "每周一更新", "每周一更新", "每周五更新",
                                   "每周一更新", "每周五更新",
                                   
                                   "每周一更新", "每周一更新",
                                   ]
    fileprivate let titleTexts = ["云音乐飙升榜", "云音乐新歌榜", "原创歌曲榜", "云音乐热歌榜",
                                  
                                  "云音乐电音榜", "云音乐ACG音乐榜", "韩国Melon排行榜周榜",
                                  "韩国Melon原声周榜", "韩国Mnet排行榜周榜", "Beatport全球电子舞曲榜",
                                  "日本Oricon周榜", "云音乐古典音乐榜", "UK排行榜周榜",
                                  "美国Billboard周榜", "法国 NRJ Vos Hits 周榜", "iTunes榜",
                                  "Hit FM Top榜", "KTV唛榜", "台湾Hito排行榜",
                                  "中国TOP排行榜（港台榜）", "中国TOP排行榜（内地榜）", "香港电台中文歌曲龙虎榜",
                                  "华语金曲榜", "中国嘻哈榜",
                                  
                                  "音乐达人榜", "音乐新人榜",
                                  ]
    
    fileprivate let topListID = ["19723756", "3779629", "2884035", "3778678",
                                 
                          "10520166", "71385702", "3733003",
                          "46772709", "60255", "3812895",
                          "60131", "71384707", "180106",
                          "60198", "27135204", "11641012",
                          "120001", "21845217", "112463",
                          "112504", "64016", "10169002",
                          "4395559", "1899724",
                          ]
    fileprivate var data = [String:PlayList]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

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
            cell.indicatorLabel.text = updateTexts[indexPath.row]
            if let data = self.data[topListID[indexPath.row]] {
                cell.leftImageView.sd_setImage(with: URL.init(string: data.coverImgUrl!))
                cell.firstLabel.text = data.tracks.count > 0 ? "1. \(data.tracks[0].name ?? "")" : ""
                cell.secondLabel.text = data.tracks.count > 1 ? "2. \(data.tracks[1].name ?? "")" : ""
                cell.thirdLabel.text = data.tracks.count > 2 ? "3. \(data.tracks[2].name ?? "")" : ""
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendViewCell.identifier, for: indexPath) as! RecommendViewCell
            if indexPath.section == 1 {
                if let data = self.data[topListID[indexPath.row + numberOfItemsArray[0]]] {
                    cell.mainImageView.sd_setImage(with: URL.init(string: data.coverImgUrl!))
                }
            } else {
                cell.mainImageView.image = UIImage.init(named: "1.jpg")!
            }
            cell.topLeftLabel.isHidden = true
            cell.topRightLabel.isHidden = true
            cell.bottomLeftLabel.isHidden = true
            cell.bottomRightLabel.isHidden = true
            
            let startOffset = indexPath.section == 1 ?
                numberOfItemsArray[indexPath.section - 1] : numberOfItemsArray[indexPath.section - 1] + numberOfItemsArray[indexPath.section - 2]
            cell.bottomLeftLabel.text = updateTexts[indexPath.row + startOffset]
            cell.bottomLeftLabel.isHidden = false
            cell.mainTitleLabel.text = titleTexts[indexPath.row + startOffset]

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
        } else if indexPath.section == 1 {
            let vc = CertainSongSheetViewController()
            vc.playListID = topListID[indexPath.row + numberOfItemsArray[0]]
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.section == 0 {
            let vc = CertainSongSheetViewController()
            vc.playListID = topListID[indexPath.row]
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
            return CGSize(width: collectionView.bounds.width/3 - 40/3, height: collectionView.bounds.width/3 - 40/3 + 40)
        }
    }

}

class RankListViewCell: UICollectionViewCell {
    static let identifier = "RankListViewCell"
    
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var indicatorLabel: UILabel!
    
    @IBOutlet weak var lineView: UIView!
}
