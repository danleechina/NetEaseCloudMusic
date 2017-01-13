//
//  SliderViewController.swift
//  NetEaseCloudMusic
//
//  Created by Dan.Lee on 2016/12/29.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit

class DefaultStyleAttribute {
    static let indicatorViewColor = UIColor.init(red: 183/255.0, green: 39/255.0, blue: 18/255.0, alpha: 1)
    static let indicatorViewHeight: CGFloat = 3
    static let indicatorViewWidthDiff: CGFloat = 4
    static let seperateLineColor = UIColor.lightGray
    static let seperateLineOffset: CGFloat = 4
    
    static let cellTitleLabelFont = UIFont.systemFont(ofSize: 15)
    static let cellTitleLabelTextColor = UIColor.black
    static let cellTitleLabelHighlightTextColor = UIColor.init(red: 183/255.0, green: 39/255.0, blue: 18/255.0, alpha: 1)
    static let navigationViewCellDefaultWidth: CGFloat = 44
}

class SliderViewController: UIViewController, UIScrollViewDelegate {
    var contentViewControllers = [UIViewController]()
    var currentIndex: Int = 0
    var titleTexts = [String]()
    var isNeedSeperateLineForEachItem = false
    
    
    fileprivate let navigationView = InternalNavigationView()
    fileprivate let contentView = InternalContentView()
    fileprivate var isClickedNavigationView = false
    fileprivate var nextIndex = 0
    fileprivate var isFirstShow = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(contentView)
        view.addSubview(navigationView)
        
        automaticallyAdjustsScrollViewInsets = false
        contentView.delegate = self
        contentView.frame = CGRect(x: 0, y: 44, width: view.frame.width, height: view.frame.height - 44)
        if let tabbarHeight = self.tabBarController?.tabBar.frame.height {
            contentView.frame = CGRect(x: 0, y: 44, width: view.frame.width, height: view.frame.height - 44 - tabbarHeight)
        }
        contentView.contentSize = CGSize(width: contentView.frame.width * CGFloat(contentViewControllers.count), height: contentView.frame.height)
        contentView.isPagingEnabled = true
        contentView.bounces = false
        contentView.showsVerticalScrollIndicator = false
        contentView.showsHorizontalScrollIndicator = false
        
        navigationView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44)
        navigationView.titleTexts = titleTexts
        navigationView.action = navigationViewSelectedAction
        navigationView.currentIndex = currentIndex
        navigationView.isNeedFullWidthForIndicatorView = true
        navigationView.isNeedSeperateLineForEachItem = isNeedSeperateLineForEachItem
        navigationView.adjustIndicatorViewFrame(accordingToRelativeOffsetX: CGFloat(currentIndex) * contentView.frame.width / CGFloat(contentViewControllers.count))
        
        goTo(viewAtIndex: currentIndex, isUserClicked: false)
        isFirstShow = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard contentViewControllers.count > 0 && currentIndex < contentViewControllers.count else { return }
        contentViewControllers[currentIndex].beginAppearanceTransition(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard contentViewControllers.count > 0 && currentIndex < contentViewControllers.count else { return }
        contentViewControllers[currentIndex].endAppearanceTransition()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard contentViewControllers.count > 0 && currentIndex < contentViewControllers.count else { return }
        contentViewControllers[currentIndex].beginAppearanceTransition(false, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard contentViewControllers.count > 0 && currentIndex < contentViewControllers.count else { return }
        contentViewControllers[currentIndex].endAppearanceTransition()
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
        guard contentViewControllers.count > 0 && index < contentViewControllers.count else { return }
        if index != currentIndex || isFirstShow {
            let oldVc = contentViewControllers[currentIndex]
            oldVc.willMove(toParentViewController: nil)
            oldVc.beginAppearanceTransition(false, animated: false)
            oldVc.endAppearanceTransition()
            oldVc.removeFromParentViewController()
            
            let nowVC = contentViewControllers[index]
            self.addChildViewController(nowVC)
            if !isFirstShow {
                nowVC.beginAppearanceTransition(true, animated: false)
                add(viewFromIndex: index)
                nowVC.endAppearanceTransition()
            }
        }
        
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
    var isNeedSeperateLineForEachItem = false
//    var usingDefaultNavigationViewCellWidth = false
    
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
    
    fileprivate lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = DefaultStyleAttribute.seperateLineColor
        return view
    }()
    
    fileprivate func customInit() {
        addSubview(collectionView)
        addSubview(lineView)
        addSubview(indicatorView)
    }
    
    override var frame: CGRect {
        didSet {
            collectionView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
            adjustIndicatorViewFrame(accordingToRelativeOffsetX: CGFloat(currentIndex) * frame.width / CGFloat(titleTexts.count))
            lineView.frame = CGRect(x: 0, y: frame.height - 0.5, width: frame.width, height: 0.5)
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
        let highlightIndex = (relativeOffsetX + itemFullWith / 2) / itemFullWith
        adjustNavigationCellTextColor(highlightIndex: Int(highlightIndex))
    }
    
    fileprivate func adjustNavigationCellTextColor(highlightIndex: Int) {
        for genericCell in collectionView.visibleCells {
            let concreteCell = genericCell as! InternalNavigationCell
            concreteCell.titleLabel.textColor = DefaultStyleAttribute.cellTitleLabelTextColor
        }
        if let cell = collectionView.cellForItem(at: IndexPath.init(row: highlightIndex, section: 0)) as? InternalNavigationCell {
            cell.titleLabel.textColor = DefaultStyleAttribute.cellTitleLabelHighlightTextColor
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
        adjustNavigationCellTextColor(highlightIndex: currentIndex)
        cell.lineView.isHidden = !isNeedSeperateLineForEachItem || indexPath.row == collectionView.numberOfItems(inSection: 0) - 1
        return cell
    }
    
    // MARK: - Collection View Layout Delegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if !usingDefaultNavigationViewCellWidth {
            return CGSize(width: collectionView.frame.width/CGFloat(titleTexts.count), height: collectionView.frame.height)
//        }
//        return CGSize(width: DefaultStyleAttribute.navigationViewCellDefaultWidth, height: collectionView.frame.height)
    }
}

class InternalNavigationCell: UICollectionViewCell {
    static let identifier = "InternalNavigationCell"
    
    let titleLabel = UILabel()
    let containerView = UIView()
    let lineView = UIView()
    override var frame: CGRect {
        didSet {
            containerView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
            titleLabel.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
            lineView.frame = CGRect(x: frame.width - 0.5, y: DefaultStyleAttribute.seperateLineOffset, width: 0.5, height: frame.height - DefaultStyleAttribute.seperateLineOffset * 2)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        titleLabel.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }
    
    fileprivate func customInit() {
        titleLabel.font = DefaultStyleAttribute.cellTitleLabelFont
        titleLabel.textColor = DefaultStyleAttribute.cellTitleLabelTextColor
        titleLabel.textAlignment = .center
        lineView.backgroundColor = DefaultStyleAttribute.seperateLineColor
        addSubview(containerView)
        addSubview(lineView)
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
