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
        view.addSubview(contentView)
        view.addSubview(navigationView)
        
        contentView.delegate = self
        contentView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        contentView.contentSize = CGSize(width: view.frame.width * CGFloat(contentViewControllers.count), height: view.frame.height)
        contentView.isPagingEnabled = true
        contentView.bounces = false
        contentView.backgroundColor = UIColor.purple
        contentView.showsVerticalScrollIndicator = false
        contentView.showsHorizontalScrollIndicator = false
        
        navigationView.titleTexts = ["this one", "this two", "this three"]
        navigationView.frame = CGRect(x: 0, y: 100, width: view.frame.width, height: 44)
        navigationView.backgroundColor = UIColor.brown
        
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

class InternalNavigationView: UIView, UITableViewDelegate, UITableViewDataSource {
    var currentIndex: Int = 0 {
        didSet {
        }
    }
    
    var heightForView = 44 {
        didSet {
            
        }
    }
    
    var titleTexts = [String]()
    
    fileprivate let tableView = UITableView()
    
    fileprivate func customInit() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsMultipleSelection = false
        tableView.allowsSelectionDuringEditing = false
        tableView.allowsMultipleSelectionDuringEditing = false
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        tableView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI/2))
        tableView.isScrollEnabled = false
        tableView.register(InternalNavigationCell.self, forCellReuseIdentifier: InternalNavigationCell.identifier)
        
        addSubview(tableView)
    }
    
    override var frame: CGRect {
        didSet {
            tableView.frame = CGRect(x: 0, y: 0, width: frame.height, height: frame.width)
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
    
    func scroll(to index: Int, needAnimate animated: Bool, progressive progressiveHandler: ()->()) {
        
    }
    
    
    // MARK: - Table View Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height / CGFloat(titleTexts.count)
    }
    
    // MARK: - Table View Datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleTexts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InternalNavigationCell.identifier, for: indexPath) as! InternalNavigationCell
        cell.titleLabel.text = titleTexts[indexPath.row]
        return cell
    }
}

class InternalNavigationCell: UITableViewCell {
    static let identifier = "InternalNavigationCell"
    
    let titleLabel = UILabel()
    // make sure all your custom views are added to containerView
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
        titleLabel.textColor = UIColor.green
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        
        addSubview(containerView)
        containerView.addSubview(titleLabel)
//        containerView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//        containerView.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI/2))
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
}
