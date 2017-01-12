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

class SeparateLine: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = FixedValue.seperateLineColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// every cell owns one and only one unit, but section can have many units(which can be connected as a large rect)
class UICollectionViewGridLayout: UICollectionViewLayout {
    weak var delegate: UICollectionViewGridLayoutDelegate!
    var sectionMargin: CGFloat
    var insets: UIEdgeInsets
    var separateLineHeight: CGFloat = 0.5
    
    fileprivate var cellLayoutInformation: Dictionary<IndexPath, UICollectionViewLayoutAttributes>
    fileprivate var sectionLayoutInformation: Dictionary<IndexPath, UICollectionViewLayoutAttributes>
    fileprivate var separateLineInformation: Dictionary<IndexPath, UICollectionViewLayoutAttributes>
    fileprivate var calContentSize = CGSize(width: 0, height: 0)
    
    override init() {
        sectionMargin = 10
        insets = UIEdgeInsetsMake(0, 0, 0, 0)
        cellLayoutInformation = [:]
        sectionLayoutInformation = [:]
        separateLineInformation = [:]
        super.init()
        register(SeparateLine.self, forDecorationViewOfKind: "line")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        guard let numberOfSection = self.collectionView?.numberOfSections else { return }
        var golbalStartOffset = CGPoint(x: insets.left, y: insets.top)
        var cnt = 0
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
                            attribute.frame = CGRect(x: startOffset.x + separateLineHeight,
                                                     y: startOffset.y + separateLineHeight,
                                                     width: (unitSize.width + separateLineHeight) * CGFloat(sectionEndPosition.x - sectionStartPosition.x) - separateLineHeight,
                                                     height: (unitSize.height + separateLineHeight) * CGFloat(sectionEndPosition.y - sectionStartPosition.y) - separateLineHeight)
                            sectionLayoutInformation[indexPath] = attribute
                        }
                    } else {
                        // meet cell
                        let indexPath = IndexPath.init(row: itemRow, section: section)
                        itemRow += 1
                        let attribute = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
                        attribute.frame = CGRect(x: startOffset.x + separateLineHeight, y: startOffset.y + separateLineHeight, width: unitSize.width, height: unitSize.height)
                        cellLayoutInformation[indexPath] = attribute
                    }
                    startOffset.x += (unitSize.width + separateLineHeight)
                }
                startOffset.x = insets.left
                startOffset.y += (unitSize.height + separateLineHeight)
            }
            
            let (sectionWidth, sectionHeight) = (CGFloat(col) * unitSize.width, CGFloat(row) * unitSize.height)
            

            // horizontal line
            var indexPath = IndexPath.init(row: cnt, section: 0)
            let line2Attr = UICollectionViewLayoutAttributes.init(forDecorationViewOfKind: "line", with: indexPath)
            line2Attr.frame = CGRect(x: golbalStartOffset.x, y: startOffset.y, width: sectionWidth + CGFloat(col) * separateLineHeight, height: separateLineHeight)
            separateLineInformation[indexPath] = line2Attr
            cnt += 1
            
            // vertical line
            indexPath.row = cnt
            let line1Attr = UICollectionViewLayoutAttributes.init(forDecorationViewOfKind: "line", with: indexPath)
            line1Attr.frame = CGRect(x: golbalStartOffset.x + sectionWidth + CGFloat(col) * separateLineHeight,
                                     y: golbalStartOffset.y,
                                     width: separateLineHeight,
                                     height: sectionHeight + CGFloat(row+1) * separateLineHeight)
            separateLineInformation[indexPath] = line1Attr
            cnt += 1
            
            golbalStartOffset.y = startOffset.y
        }
        
        calContentSize.height = golbalStartOffset.y + separateLineHeight
        
        for attr in cellLayoutInformation.values {
            // horizontal line
            var indexPath = IndexPath.init(row: cnt, section: 0)
            let line1Attr = UICollectionViewLayoutAttributes.init(forDecorationViewOfKind: "line", with: indexPath)
            line1Attr.frame = CGRect(x: attr.frame.origin.x - separateLineHeight, y: attr.frame.origin.y - separateLineHeight, width: attr.frame.width + separateLineHeight, height: separateLineHeight)
            separateLineInformation[indexPath] = line1Attr
            cnt += 1
            
            // vertical line
            indexPath.row = cnt
            let line2Attr = UICollectionViewLayoutAttributes.init(forDecorationViewOfKind: "line", with: indexPath)
            line2Attr.frame = CGRect(x: attr.frame.origin.x - separateLineHeight, y: attr.frame.origin.y, width: separateLineHeight, height: attr.frame.height)
            separateLineInformation[indexPath] = line2Attr
            cnt += 1
        }
        
        for attr in sectionLayoutInformation.values {
            // horizontal line
            var indexPath = IndexPath.init(row: cnt, section: 0)
            let line1Attr = UICollectionViewLayoutAttributes.init(forDecorationViewOfKind: "line", with: indexPath)
            line1Attr.frame = CGRect(x: attr.frame.origin.x - separateLineHeight, y: attr.frame.origin.y - separateLineHeight, width: attr.frame.width + separateLineHeight, height: separateLineHeight)
            separateLineInformation[indexPath] = line1Attr
            cnt += 1
            
            // vertical line
            indexPath.row = cnt
            let line2Attr = UICollectionViewLayoutAttributes.init(forDecorationViewOfKind: "line", with: indexPath)
            line2Attr.frame = CGRect(x: attr.frame.origin.x - separateLineHeight, y: attr.frame.origin.y, width: separateLineHeight, height: attr.frame.height)
            separateLineInformation[indexPath] = line2Attr
            cnt += 1
        }
        
    }
    
    override var collectionViewContentSize: CGSize {
        get {
            guard let numberOfSections = self.collectionView?.numberOfSections else {
                return CGSize(width: 0, height: 0)
            }
            var size = CGSize(width: 0, height: 0)
            for section in 0..<numberOfSections {
                let sectionWidth = (delegate.unitSize(inSection: section).width + separateLineHeight) * CGFloat(delegate.numberOfColumnAndRow(inSection: section).col)
                size.width = max(sectionWidth, size.width)
                
                size.height += ((delegate.unitSize(inSection: section).height + separateLineHeight) * CGFloat(delegate.numberOfColumnAndRow(inSection: section).row) + sectionMargin + separateLineHeight)
            }
            size.width += (insets.left + insets.right)
            size.height += (insets.top + insets.bottom)
            
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
        for lineAttr in separateLineInformation.values {
            if rect.intersects(lineAttr.frame) {
                attrs.append(lineAttr)
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
    
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return separateLineInformation[indexPath]
    }
}
