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
    fileprivate let calWidthLabel = UILabel()
    
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
        
        navigationView.titleTexts = titleTexts
        navigationView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44)
        navigationView.action = navigationViewSelectedAction
        
        customIndicatorViewWith()
        add(viewFromIndex: currentIndex)
    }
    
    func navigationViewSelectedAction(selectedIndex: Int) {
        goTo(viewAtIndex: selectedIndex)
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
    
    func goTo(viewAtIndex index: Int) {
        contentView.contentOffset = CGPoint(x: contentView.bounds.width * CGFloat(index), y: contentView.contentOffset.y)
        add(viewFromIndex: index)
        currentIndex = index
    }
    
    func customIndicatorViewWith() {
        let scrollView = contentView
        var nextIndex = currentIndex
        let panGest = scrollView.panGestureRecognizer
        if panGest.velocity(in: scrollView.superview).x > 0 {
            // left is about to appear
            nextIndex -= 1
        } else {
            // right is about to appear
            nextIndex += 1
        }
        if nextIndex < 0 || nextIndex >= contentViewControllers.count {
            return
        }
        
        let offsetX = scrollView.contentOffset.x / scrollView.contentSize.width * navigationView.frame.width
        calWidthLabel.font = DefaultStyleAttribute.cellTitleLabelFont
        calWidthLabel.text = navigationView.titleTexts[nextIndex]
        calWidthLabel.sizeToFit()
        let resWidth = calWidthLabel.frame.width + DefaultStyleAttribute.indicatorViewWidthDiff
        let startWidth = navigationView.indicatorView.frame.width
        let complete = abs((scrollView.contentOffset.x - scrollView.contentSize.width * CGFloat(self.currentIndex)) / scrollView.frame.width)
        let idWidth = startWidth - resWidth * complete
        navigationView.configIndicatorViewSize(offsetX: offsetX + scrollView.frame.width/CGFloat(titleTexts.count)/2 - idWidth/2, width: idWidth)
    }
    
    // - MARK: Scroll View Delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var nextIndex = currentIndex
        let panGest = scrollView.panGestureRecognizer
        if panGest.velocity(in: scrollView.superview).x > 0 {
            // left is about to appear
            nextIndex -= 1
        } else {
            // right is about to appear
            nextIndex += 1
        }
        add(viewFromIndex: Int(nextIndex))
        customIndicatorViewWith()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let nextIndex = Int(scrollView.contentOffset.x / scrollView.bounds.width + 0.5)
        goTo(viewAtIndex: nextIndex)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            let nextIndex = Int(scrollView.contentOffset.x / scrollView.bounds.width + 0.5)
            goTo(viewAtIndex: nextIndex)
        }
    }
}

class InternalNavigationView: UIView,UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var action: ((_ selectedIndex: Int) -> ())?
    var titleTexts = [String]() {
        didSet {
            if titleTexts.count > 0 {
                configIndicatorViewSize(offsetX: 0, width: frame.width/CGFloat(titleTexts.count))
            }
        }
    }
    
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
            if titleTexts.count > 0 {
                configIndicatorViewSize(offsetX: 0, width: frame.width/CGFloat(titleTexts.count))
            }
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
    
    func configIndicatorViewSize(offsetX: CGFloat, width: CGFloat) {
        indicatorView.frame = CGRect(x: offsetX, y: frame.height - DefaultStyleAttribute.indicatorViewHeight, width: width, height: DefaultStyleAttribute.indicatorViewHeight)
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
