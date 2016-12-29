//
//  SliderViewController.swift
//  NetEaseCloudMusic
//
//  Created by Dan.Lee on 2016/12/29.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit

class SliderViewController: UIViewController, UIScrollViewDelegate {
    var contentViewControllers = [UIViewController]()
    var currentIndex: Int = 0
    
    fileprivate let navigationView = InternalNavigationView()
    fileprivate let contentView = InternalContentView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(navigationView)
        view.addSubview(contentView)
        
        contentView.delegate = self
        contentView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        contentView.contentSize = CGSize(width: view.frame.width * CGFloat(contentViewControllers.count), height: view.frame.height)
        contentView.isPagingEnabled = true
        contentView.bounces = false
        contentView.backgroundColor = UIColor.purple
        contentView.showsVerticalScrollIndicator = false
        contentView.showsHorizontalScrollIndicator = false
        
        add(viewFromIndex: currentIndex)
    }
    
    func add(viewFromIndex index: Int) {
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
    
    // - MARK: Scroll View Delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let nextIndex = ceilf(Float(scrollView.contentOffset.x / scrollView.bounds.width))
        add(viewFromIndex: Int(nextIndex))
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

class InternalNavigationView: UIView {
    var currentIndex: Int = 0 {
        didSet {
            if currentIndex != previousIndex {
                
            }
        }
    }
    
    var heightForView = 44 {
        didSet {
            
        }
    }
    
    
    fileprivate var previousIndex = 0
    
    func scroll(to index: Int, needAnimate animated: Bool, progressive progressiveHandler: ()->()) {
        
    }
}
