//
//  ImageSliderView.swift
//  DLDemo
//
//  Created by Dan.Lee on 2016/10/16.
//  Copyright © 2016年 Dan Lee. All rights reserved.
//

import UIKit

enum SlideDirection {
    case Vertical
    case Horizontal
}

/*
 * Attention: need to set automaticallyAdjustsScrollViewInsets false
 * when in container view controller like UINavigationController if
 * you want to use vertical slider.
 */
protocol ImageSliderViewDelegate: class {
    func didSelectAtPage(index: Int);
}


class ImageSliderView: UIView {

    weak var delegate: ImageSliderViewDelegate?
    
    var images: Array<UIImage>? {
        didSet {
            if let images = self.images {
                if images.count >= 3 {
                    leftImageContainerView.image = images.last
                    centerImageContainerView.image = images[0]
                    rightImageContainerView.image = images[1]
                } else if images.count == 2 {
                    leftImageContainerView.image = images[1]
                    centerImageContainerView.image = images[0]
                    rightImageContainerView.image = images[1]
                } else if images.count == 1 {
                    leftImageContainerView.image = images[0]
                    centerImageContainerView.image = nil
                    rightImageContainerView.image = nil
                } else {
                    leftImageContainerView.image = nil
                    centerImageContainerView.image = nil
                    rightImageContainerView.image = nil
                }
                setAppearance()
            }
        }
    }
    
    var slideDirection = SlideDirection.Horizontal {
        didSet {
            setAppearance()
        }
    }
    
    override var frame: CGRect {
        didSet {
            scrollView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
            setAppearance()
        }
    }

    var currentIndex = 0 {
        didSet {
            if let images = self.images {
                if currentIndex >= images.count {
                    currentIndex = 0
                } else if currentIndex < 0 {
                    currentIndex = images.count - 1
                }
                pageController.currentPage = currentIndex
                if let images = self.images {
                    if images.count >= 3 {
                        leftImageContainerView.image = images[currentIndex == 0 ? images.count - 1 : currentIndex - 1]
                        centerImageContainerView.image = images[currentIndex]
                        rightImageContainerView.image = images[currentIndex >= images.count - 1 ? 0 : currentIndex + 1]
                    } else if images.count == 2 {
                        leftImageContainerView.image = images[currentIndex == 0 ? 1 : 0]
                        centerImageContainerView.image = images[currentIndex]
                        rightImageContainerView.image = images[currentIndex == 0 ? 1 : 0]
                    } else if images.count == 1 {
                        leftImageContainerView.image = nil
                        centerImageContainerView.image = images[0]
                        rightImageContainerView.image = nil
                    }
                }
            }
        }
    }
    
    private let scrollView = UIScrollView()
    private let pageController = UIPageControl()
    private let leftImageContainerView = ImageContainerView()
    private let centerImageContainerView = ImageContainerView()
    private let rightImageContainerView = ImageContainerView()
    private var timer: Timer?
    fileprivate var userDragging:Bool = false
    
    func startToSlide() {
        stopSliding()
        
        self.timer = Timer.init(timeInterval: 3, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
        RunLoop.current.add(timer!, forMode: .commonModes)
    }
    
    func stopSliding() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func timerAction() {
        if (self.images != nil) && (self.images?.count)! > 1 {
            if self.scrollView.isDragging
                || self.scrollView.isTracking
                || self.scrollView.isDecelerating
                || self.userDragging {
                return
            }
            self.scrollView.isUserInteractionEnabled = false
            self.scrollView.setContentOffset(self.rightImageContainerView.frame.origin, animated: true)
        }
    }
    
    private func setAppearance() {
        currentIndex = 0
        setPageControl()
        setContainerViewFrame()
        setContentSize()
        setInitContentOffset()
        let tapGest = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        centerImageContainerView.addGestureRecognizer(tapGest)
    }
    
    @objc private func tapAction() {
        if self.images != nil && !(self.images?.isEmpty)! {
            delegate?.didSelectAtPage(index: currentIndex)
        }
    }
    
    private func setPageControl() {
        if let images = self.images {
            pageController.numberOfPages = images.count
            pageController.currentPage = 0
            let minSize = pageController.size(forNumberOfPages: pageController.numberOfPages)
            let superViewWidth = scrollView.frame.width
            let superViewHeight = scrollView.frame.height
            switch slideDirection {
            case .Horizontal:
                pageController.frame = CGRect(origin:CGPoint(x: superViewWidth/2 - minSize.width/2, y: superViewHeight - minSize.height - 10), size: minSize )
                pageController.transform = CGAffineTransform(rotationAngle: 0)
                break
            case .Vertical:
                pageController.frame = CGRect(origin:CGPoint(x: superViewWidth - minSize.width/2 - 10, y: superViewHeight/2 - minSize.height/2), size: minSize )
                let rotate = CGAffineTransform(rotationAngle: CGFloat(M_PI / 2))
                pageController.transform = rotate
                break
            }
        }
    }
    
    private func setContainerViewFrame() {
        if slideDirection == .Horizontal {
            leftImageContainerView.frame    = CGRect(x: 0,                  y: 0, width: frame.width, height: frame.height)
            centerImageContainerView.frame  = CGRect(x: frame.width,        y: 0, width: frame.width, height: frame.height)
            rightImageContainerView.frame   = CGRect(x: frame.width * 2,    y: 0, width: frame.width, height: frame.height)
        } else {
            leftImageContainerView.frame    = CGRect(x: 0, y: 0,                width: frame.width, height: frame.height)
            centerImageContainerView.frame  = CGRect(x: 0, y: frame.height,     width: frame.width, height: frame.height)
            rightImageContainerView.frame   = CGRect(x: 0, y: frame.height * 2, width: frame.width, height: frame.height)
        }
        
        if let images = self.images {
            if images.count <= 1 {
                centerImageContainerView.frame  = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
            }
        }
    }
    
    private func setContentSize() {
        switch slideDirection {
        case .Horizontal:
            scrollView.contentSize = CGSize(width:frame.width * 3, height:frame.height)
            break
        case .Vertical:
            scrollView.contentSize = CGSize(width:frame.width, height:frame.height * 3)
            break
        }
        if let images = self.images {
            if images.count <= 1 {
                scrollView.contentSize = CGSize(width:frame.width, height:frame.height)
            }
        } else {
            scrollView.contentSize = CGSize(width:frame.width, height:frame.height)
        }
    }
    
    private func setInitContentOffset() {
        switch slideDirection {
        case .Horizontal:
            scrollView.setContentOffset(CGPoint(x: frame.width, y:0), animated: false)
            break
        case .Vertical:
            scrollView.setContentOffset(CGPoint(x: 0, y: frame.height), animated: false)
            break
        }
        
        if let images = self.images {
            if images.count <= 1 {
                scrollView.contentOffset = CGPoint(x:0, y:0)
            }
        }
    }
    
    fileprivate func didScrollToNextPage() {
        let contentOffSet = scrollView.contentOffset
        let pageWidth = scrollView.frame.width
        let pageHeight = scrollView.frame.height
        
        if (contentOffSet.x == 0 && slideDirection == .Horizontal)
            || (contentOffSet.y == 0 && slideDirection == .Vertical)  {
            currentIndex -= 1
        } else if (abs(contentOffSet.x - pageWidth * 2) < 1 && slideDirection == .Horizontal)
            || (abs(contentOffSet.y - pageHeight * 2) < 1 && slideDirection == .Vertical)  {
            currentIndex += 1
        }
        setInitContentOffset()
    }
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        addSubview(scrollView)
        addSubview(pageController)
        
        scrollView.isPagingEnabled = true
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.clipsToBounds = true
        scrollView.addSubview(leftImageContainerView)
        scrollView.addSubview(centerImageContainerView)
        scrollView.addSubview(rightImageContainerView)
        
        pageController.currentPageIndicatorTintColor = UIColor.red
        pageController.pageIndicatorTintColor = UIColor.blue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ImageContainerView: UIView {
    var imageView = UIImageView()
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    override var frame: CGRect {
        didSet {
            imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        
        imageView.contentMode = .scaleAspectFit
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ImageSliderView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var contentOffset = scrollView.contentOffset
        if slideDirection == .Horizontal {
            contentOffset.y = 0
        } else {
            contentOffset.x = 0
        }
        scrollView.contentOffset = contentOffset
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.userDragging = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollView.isUserInteractionEnabled = false
        self.userDragging = false
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollView.isUserInteractionEnabled = true
        self.didScrollToNextPage()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollView.isUserInteractionEnabled = true
        self.didScrollToNextPage()
    }
}
