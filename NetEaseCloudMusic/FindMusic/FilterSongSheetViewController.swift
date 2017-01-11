//
//  FilterSongSheetViewController.swift
//  NetEaseCloudMusic
//
//  Created by Dan.Lee on 2017/1/11.
//  Copyright © 2017年 Ampire_Dan. All rights reserved.
//

import UIKit

class FilterSongSheetViewController: BaseViewController {
    
    
    fileprivate lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: self.collectionViewFlowLayout)
        collectionView.frame = CGRect(x: 0, y: 0, width:self.view.bounds.width, height:self.view.bounds.height)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        let contentInsetValue: CGFloat = 10
        collectionView.contentInset = UIEdgeInsetsMake(contentInsetValue, contentInsetValue, contentInsetValue, contentInsetValue)
        collectionView.register(FilterSongSheetViewCell.self, forCellWithReuseIdentifier: FilterSongSheetViewCell.identifier)
        collectionView.register(FilterSongSheetViewSection.self, forSupplementaryViewOfKind: FilterSongSheetViewSection.kind, withReuseIdentifier: FilterSongSheetViewSection.identifier)
        collectionView.backgroundColor = UIColor.black
        return collectionView
    }()
    
    fileprivate lazy var collectionViewFlowLayout: UICollectionViewGridLayout = {
        let layout = UICollectionViewGridLayout()
        layout.delegate = self
        layout.sectionMargin = 5
        let inset: CGFloat = 0
        layout.insets = UIEdgeInsetsMake(inset, inset, inset, inset)
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
    
    fileprivate let sectionSize = [(4,1), (4,2), (4,7), (4,4), (4,4), (4,5),]
//    fileprivate let sectionSize = [(2,1), (2,2),]
}

extension FilterSongSheetViewController: UICollectionViewGridLayoutDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionSize.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        let ret = sectionSize[section].0 * sectionSize[section].1 - 2
        return ret
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterSongSheetViewCell.identifier, for: indexPath) as! FilterSongSheetViewCell
        cell.label.text = "R\(indexPath.section)-\(indexPath.row)"
        cell.label.textColor = UIColor.black
        if cell.backgroundColor == nil {
            cell.backgroundColor = UIColor.randomColor()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: FilterSongSheetViewSection.kind, withReuseIdentifier: FilterSongSheetViewSection.identifier, for: indexPath) as! FilterSongSheetViewSection
        view.label.text = "S\(indexPath.section)-\(indexPath.row)"
        view.label.textColor = UIColor.black
        if view.backgroundColor == nil {
            view.backgroundColor = UIColor.randomColor()
        }
        return view
    }
    
    // MARK: Delegate
    
    // MARK: UICollectionViewGridLayoutDelegate
    func numberOfColumnAndRow(inSection section: Int) -> (col: Int, row: Int) {
        return sectionSize[section]
    }
    
    func unitSize(inSection section: Int) -> CGSize {
        return CGSize(width: 70, height: 40)
    }
    
    func sectionPostion(inSection section: Int) -> (startPosition: UnitPosition, endPosition: UnitPosition) {
        if section == 0 {
            return (UnitPosition(x: 0, y: 0), UnitPosition(x: 4, y: 1))
        } else if section == 1 {
            return (UnitPosition(x: 0, y: 0), UnitPosition(x: 1, y: 2))
        } else if section == 2 {
            return (UnitPosition(x: 1, y: 2), UnitPosition(x: 3, y: 5))
        } else if section == 3 {
            
            return (UnitPosition(x: 3, y: 2), UnitPosition(x: 4, y: 4))
        } else if section == 4 {
            return (UnitPosition(x: 3, y: 0), UnitPosition(x: 4, y: 2))
        } else if section == 5 {
            
            return (UnitPosition(x: 0, y: 2), UnitPosition(x: 1, y: 5))
        }
        return (UnitPosition(x: 0, y: 0), UnitPosition(x: 1, y: 2))
    }
}

class FilterSongSheetViewCell: UICollectionViewCell {
    static let identifier = "FilterSongSheetViewCell"
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        label.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = self.bounds
    }
}

class FilterSongSheetViewSection: UICollectionReusableView {
    static let identifier = "FilterSongSheetViewSection_ID"
    static let kind = "section"
    
    let label = UILabel()
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        label.textAlignment = .center
//        addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = self.bounds
    }
}

extension UIColor {
    class func randomColor() -> UIColor {
        return UIColor.init(red: randomBetweenNumbers(firstNum: 0, secondNum: 1),
                            green: randomBetweenNumbers(firstNum: 0, secondNum: 1),
                            blue: randomBetweenNumbers(firstNum: 0, secondNum: 1),
                            alpha: 1)
    }
    
    class func randomBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat{
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
}
