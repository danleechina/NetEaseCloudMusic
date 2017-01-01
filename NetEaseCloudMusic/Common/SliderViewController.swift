//
//  SliderViewController.swift
//  NetEaseCloudMusic
//
//  Created by Dan.Lee on 2016/12/29.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit

class DefaultStyleAttribute {
    static let indicatorViewColor = UIColor.green
    static let indicatorViewHeight: CGFloat = 4
    static let indicatorViewWidthDiff: CGFloat = 4
    
    static let cellTitleLabelFont = UIFont.systemFont(ofSize: 15)
}

class SliderViewController: UIViewController, UIScrollViewDelegate {
    var contentViewControllers = [UIViewController]()
    var currentIndex: Int = 0
    var titleTexts = [String]()
    
    
    fileprivate let navigationView = InternalNavigationView()
    fileprivate let contentView = InternalContentView()
    fileprivate var isClickedNavigationView = false
    fileprivate var nextIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(contentView)
        view.addSubview(navigationView)
        
        contentView.delegate = self
        contentView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        contentView.contentSize = CGSize(width: view.frame.width * CGFloat(contentViewControllers.count), height: view.frame.height)
        contentView.isPagingEnabled = true
        contentView.bounces = false
        contentView.showsVerticalScrollIndicator = false
        contentView.showsHorizontalScrollIndicator = false
        
        navigationView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44)
        navigationView.titleTexts = titleTexts
        navigationView.action = navigationViewSelectedAction
        navigationView.currentIndex = currentIndex
        navigationView.isNeedFullWidthForIndicatorView = true
        navigationView.adjustIndicatorViewFrame(accordingToRelativeOffsetX: CGFloat(currentIndex) * contentView.frame.width / CGFloat(contentViewControllers.count))
        
        
//        add(viewFromIndex: currentIndex)
        goTo(viewAtIndex: currentIndex, isUserClicked: false)
    }
    
    func navigationViewSelectedAction(selectedIndex: Int) {
        isClickedNavigationView = true
        goTo(viewAtIndex: selectedIndex, isUserClicked: true)
    }
    
    func add(viewFromIndex index: Int) {
        guard index >= 0 && index < self.contentViewControllers.count else { return }
        
        let vc = self.contentViewControllers[index]
        if vc.view.superview == nil {
            let offsetX = self.contentView.bounds.width * CGFloat(index)
            let frame = CGRect(x: offsetX, y: 0, width: self.contentView.bounds.width, height: self.contentView.bounds.height)
            vc.view.frame = frame
            contentView.addSubview(vc.view)
        }
    }
    
    func goTo(viewAtIndex index: Int, isUserClicked: Bool) {
        add(viewFromIndex: index)
        
        let oldOffsetX = contentView.contentOffset.x
        contentView.setContentOffset(CGPoint(x: contentView.bounds.width * CGFloat(index), y: contentView.contentOffset.y), animated: false)
        var relativeOffsetX = oldOffsetX / contentView.contentSize.width * contentView.frame.width
        navigationView.adjustIndicatorViewFrame(accordingToRelativeOffsetX: relativeOffsetX)
        
        currentIndex = index
        navigationView.currentIndex = index
        
        relativeOffsetX = contentView.contentOffset.x / contentView.contentSize.width * contentView.frame.width
        if isUserClicked {
            UIView.animate(withDuration: 0.2, animations: {
                UIView.setAnimationCurve(.easeInOut)
                self.navigationView.adjustIndicatorViewFrame(accordingToRelativeOffsetX: relativeOffsetX)
            })
        } else {
            navigationView.adjustIndicatorViewFrame(accordingToRelativeOffsetX: relativeOffsetX)
        }
    }
    
    // - MARK: Scroll View Delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let vx = scrollView.panGestureRecognizer.velocity(in: scrollView.superview).x
        nextIndex = vx > 0 ? currentIndex - 1 : (vx != 0 ? currentIndex + 1 : nextIndex)
        add(viewFromIndex: nextIndex)
        
        let relativeOffsetX = scrollView.contentOffset.x / scrollView.contentSize.width * scrollView.frame.width
        navigationView.adjustIndicatorViewFrame(accordingToRelativeOffsetX: relativeOffsetX)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let nextIndex = Int(scrollView.contentOffset.x / scrollView.bounds.width + 0.5)
        goTo(viewAtIndex: nextIndex, isUserClicked: false)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            let nextIndex = Int(scrollView.contentOffset.x / scrollView.bounds.width + 0.5)
            goTo(viewAtIndex: nextIndex, isUserClicked: false)
        }
    }
}

class InternalNavigationView: UIView,UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var action: ((_ selectedIndex: Int) -> ())?
    var titleTexts = [String]()
    var currentIndex = 0
    var isNeedFullWidthForIndicatorView = false
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView.init(frame: self.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(InternalNavigationCell.self, forCellWithReuseIdentifier: InternalNavigationCell.identifier)
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        
        return collectionView
    }()
    
    fileprivate lazy var indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = DefaultStyleAttribute.indicatorViewColor
        return view
    }()
    
    fileprivate func customInit() {
        addSubview(collectionView)
        addSubview(indicatorView)
    }
    
    override var frame: CGRect {
        didSet {
            collectionView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
            adjustIndicatorViewFrame(accordingToRelativeOffsetX: 0)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    func adjustIndicatorViewFrame(accordingToRelativeOffsetX relativeOffsetX: CGFloat) {
        guard titleTexts.count > 0 else { return }
        
        let offsetY = frame.height - DefaultStyleAttribute.indicatorViewHeight
        let itemFullWith = frame.width / CGFloat(titleTexts.count)
        if !isNeedFullWidthForIndicatorView {
            indicatorView.frame = CGRect(x: relativeOffsetX, y: offsetY, width: itemFullWith, height: DefaultStyleAttribute.indicatorViewHeight)
        } else {
            let preIndex = Int(relativeOffsetX / itemFullWith)
            let nxtIndex = min(Int(relativeOffsetX / itemFullWith) + 1, titleTexts.count - 1)
            let percent = relativeOffsetX/itemFullWith - CGFloat(preIndex)
            
            let preStr = titleTexts[preIndex] as NSString
            let nxtStr = titleTexts[nxtIndex] as NSString
            
            let preStrWidth = preStr.size(attributes: [NSFontAttributeName: DefaultStyleAttribute.cellTitleLabelFont]).width + DefaultStyleAttribute.indicatorViewWidthDiff
            let nxtStrWidth = nxtStr.size(attributes: [NSFontAttributeName: DefaultStyleAttribute.cellTitleLabelFont]).width + DefaultStyleAttribute.indicatorViewWidthDiff
            let curWidth = preStrWidth + percent * (nxtStrWidth - preStrWidth)
            
            let preOffsetX = (itemFullWith - preStrWidth) / 2
            let nxtOffsetX = (itemFullWith - nxtStrWidth) / 2
            let curOffsetX = preOffsetX + percent * (nxtOffsetX - preOffsetX)
            indicatorView.frame = CGRect(x: curOffsetX + relativeOffsetX, y: offsetY, width: curWidth, height: DefaultStyleAttribute.indicatorViewHeight)
        }
    }
    
    // MARK: - Collection View Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        action?(indexPath.row)
    }
    
    // MARK: - Collection View Datasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleTexts.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InternalNavigationCell.identifier, for: indexPath) as! InternalNavigationCell
        cell.titleLabel.text = titleTexts[indexPath.row]
        return cell
    }
    
    // MARK: - Collection View Layout Delegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/CGFloat(titleTexts.count), height: collectionView.frame.height)
    }
}

class InternalNavigationCell: UICollectionViewCell {
    static let identifier = "InternalNavigationCell"
    
    let titleLabel = UILabel()
    let containerView = UIView()
    
    override var frame: CGRect {
        didSet {
            containerView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
            titleLabel.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        titleLabel.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }
    
    fileprivate func customInit() {
        titleLabel.font = DefaultStyleAttribute.cellTitleLabelFont
        titleLabel.textAlignment = .center
        
        addSubview(containerView)
        containerView.addSubview(titleLabel)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
}

class InternalContentView: UIScrollView, UIGestureRecognizerDelegate {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        panGestureRecognizer.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        panGestureRecognizer.delegate = self
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else {
            return true
        }
        return !(contentOffset.x < 1e-6 && panGestureRecognizer.velocity(in: self).x > 1e-6)
    }
}
