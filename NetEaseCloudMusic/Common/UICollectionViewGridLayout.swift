//
//  UICollectionViewGridLayout.swift
//  NetEaseCloudMusic
//
//  Created by Dan.Lee on 2017/1/11.
//  Copyright © 2017年 Ampire_Dan. All rights reserved.
//

import UIKit

struct UnitPosition {
    var x = 0
    var y = 0
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

protocol UICollectionViewGridLayoutDelegate: UICollectionViewDelegate {
    func numberOfColumnAndRow(inSection section: Int) -> (col: Int, row: Int)
    func unitSize(inSection section: Int) -> CGSize
    func sectionPostion(inSection section: Int) -> (startPosition: UnitPosition, endPosition: UnitPosition)
}

// every cell owns one and only one unit, but section can have many units(which can be connected as a large unit like a rect)
class UICollectionViewGridLayout: UICollectionViewLayout {
    weak var delegate: UICollectionViewGridLayoutDelegate!
    var sectionMargin: CGFloat
    var insets: UIEdgeInsets
    
    fileprivate var cellLayoutInformation: Dictionary<IndexPath, UICollectionViewLayoutAttributes>
    fileprivate var sectionLayoutInformation: Dictionary<IndexPath, UICollectionViewLayoutAttributes>
    
    override init() {
        sectionMargin = 10
        insets = UIEdgeInsetsMake(0, 0, 0, 0)
        cellLayoutInformation = [:]
        sectionLayoutInformation = [:]
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        guard let numberOfSection = self.collectionView?.numberOfSections else { return }
        var golbalStartOffset = CGPoint(x: insets.left, y: insets.top)
        for section in 0..<numberOfSection {
            let (col, row) = delegate.numberOfColumnAndRow(inSection: section)
            let unitSize = delegate.unitSize(inSection: section)
            golbalStartOffset.y += sectionMargin
            
            var startOffset = golbalStartOffset
            let (sectionStartPosition,sectionEndPosition) = delegate.sectionPostion(inSection: section)
            var itemRow = 0
            for r in 0..<row {
                for c in 0..<col {
                    if sectionStartPosition.x <= c && c < sectionEndPosition.x &&
                        sectionStartPosition.y <= r && r < sectionEndPosition.y {
                        // meet section
                        let indexPath = IndexPath.init(row: itemRow, section: section)
                        if sectionStartPosition.x == c && sectionStartPosition.y == r {
                            let attribute = UICollectionViewLayoutAttributes.init(forSupplementaryViewOfKind: "section", with: indexPath)
                            attribute.frame = CGRect(x: startOffset.x, y: startOffset.y, width: unitSize.width * CGFloat(sectionEndPosition.x - sectionStartPosition.x), height: unitSize.height * CGFloat(sectionEndPosition.y - sectionStartPosition.y))
                            sectionLayoutInformation[indexPath] = attribute
                        }
                    } else {
                        // meet cell
                        let indexPath = IndexPath.init(row: itemRow, section: section)
                        itemRow += 1
                        let attribute = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
                        attribute.frame = CGRect(x: startOffset.x, y: startOffset.y, width: unitSize.width, height: unitSize.height)
                        cellLayoutInformation[indexPath] = attribute
                    }
                    startOffset.x += unitSize.width
                }
                startOffset.x = 0
                startOffset.y += unitSize.height
            }
            golbalStartOffset.y = startOffset.y
        }
        
        print("FFFF")
    }
    
    override var collectionViewContentSize: CGSize {
        get {
            guard let numberOfSections = self.collectionView?.numberOfSections else {
                return CGSize(width: 0, height: 0)
            }
            var size = CGSize(width: 0, height: 0)
            for section in 0..<numberOfSections {
                let sectionWidth = delegate.unitSize(inSection: section).width * CGFloat(delegate.numberOfColumnAndRow(inSection: section).col)
                size.width = max(sectionWidth, size.width)
                
                size.height += (delegate.unitSize(inSection: section).height * CGFloat(delegate.numberOfColumnAndRow(inSection: section).row) + sectionMargin)
            }
            size.width += (insets.top + insets.bottom)
            size.height += (insets.left + insets.right)
            return size
            
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attrs = [UICollectionViewLayoutAttributes]()
        for cellAttr in cellLayoutInformation.values {
            if rect.intersects(cellAttr.frame) {
                attrs.append(cellAttr)
            }
        }
        for sectionAttr in sectionLayoutInformation.values {
            if rect.intersects(sectionAttr.frame) {
                attrs.append(sectionAttr)
            }
        }
        return attrs
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cellLayoutInformation[indexPath]
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return sectionLayoutInformation[indexPath]
    }
}
