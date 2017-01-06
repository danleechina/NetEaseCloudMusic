//
//  RadioDetailListViewController.swift
//  NetEaseCloudMusic
//
//  Created by Dan.Lee on 2017/1/4.
//  Copyright © 2017年 Ampire_Dan. All rights reserved.
//

import UIKit

// This view controller implements parallax effect which has a difference to common effect.
// scroll down will make the final image become the background image of navigation bar.
class RadioDetailListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 70
        let cellNib = UINib.init(nibName: RadioDetailListViewCell.identifier, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: RadioDetailListViewCell.identifier)
        tableView.tableHeaderView = self.tableHeaderView
        tableView.backgroundColor = UIColor.clear
        tableView.tag = 0
        return tableView
    }()
    
    fileprivate lazy var tableHeaderView: RadioDetailListHeaderView = {
        let headerNib = UINib.init(nibName: "RadioDetailListHeaderView", bundle: nil)
        let tableHeaderView = headerNib.instantiate(withOwner: nil, options: nil).last as! RadioDetailListHeaderView
//        tableHeaderView.backgroundImageView.image = UIImage.init(named: "1.jpg")
        tableHeaderView.authorImageView.image = UIImage.init(named: "3.jpg")
        tableHeaderView.nameLabel.text = "尖子入眠"
        tableHeaderView.subscribeButton.setTitle("订阅（1333)", for: .normal)
        tableHeaderView.subscribeButton.setImage(UIImage.init(named: "cm2_list_icn_subscribe"), for: .normal)
        tableHeaderView.titleLabel.text = "在此见字如面"
        tableHeaderView.detailInfoLabel.text = "fsfa的房间啊三闾大夫；见阿三；房间啊是否见阿三；地理放假啊放假啊；的手机发呆思考了；富士康大楼附近开了仨的肌肤；阿世界的饭卡的身份；阿的索科洛夫集散地；发生的；肌肤；阿里斯顿发见阿三；就发生；房间阿莱克斯；房间啊时间发；是否见阿三；了看的就发生"
        tableHeaderView.backgroundColor = UIColor.clear
        return tableHeaderView
    }()
    
    let heigthForHeader: CGFloat = 310
    let headerScrollViewHeight: CGFloat = 64 + 180
    
    fileprivate lazy var backgroundScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.tag = 1
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.headerScrollViewHeight)
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 2
        
        scrollView.addSubview(self.mergeView)
        scrollView.contentSize = scrollView.frame.size
        self.backgroundImageView.frame = CGRect(x: 0, y: 0, width: scrollView.width, height: scrollView.height)
        self.blurView.frame = CGRect(x: 0, y: 0, width: scrollView.width, height: scrollView.height)
        self.mergeView.frame = CGRect(x: 0, y: 0, width: scrollView.width, height: scrollView.height)
        return scrollView
    }()
    
    fileprivate lazy var mergeView: UIView = {
        let view = UIView()
        view.addSubview(self.backgroundImageView)
        view.addSubview(self.blurView)
        return view
    }()
    
    fileprivate let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.init(named: "a.jpg")
        imageView.contentMode = .scaleAspectFill
        return imageView
        
    }()
    
    fileprivate let blurView: UIView = {
        let blurView = UIView()
        blurView.backgroundColor = UIColor.black
        blurView.alpha = 0.5
        return blurView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        
        if let tabbarHeight = self.tabBarController?.tabBar.frame.size.height {
            tableView.frame = CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height - 64 - tabbarHeight)
        } else {
            tableView.frame = CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height - 64)
        }
        tableHeaderView.height = heigthForHeader
        view.addSubview(backgroundScrollView)
        view.addSubview(tableView)
        view.backgroundColor = UIColor.white
        
        makeACommonNavigationBar(isBlackIcon: false)
        navigationBar.titleString = "电台"
        navigationBar.titleLabel.textColor = UIColor.white
        navigationBar.backgroundColor = UIColor.clear
        statusBar.backgroundColor = UIColor.clear
        navigationBar.lineView.isHidden = true
        view.addSubview(statusBar)
        
    }
    
    func updateHeaderView() {
        let offsetY = tableView.contentOffset.y
        let tableHeaderView = tableView.tableHeaderView as! RadioDetailListHeaderView
        tableHeaderView.backgroundImageViewHeightConstraint.constant = offsetY <= 0 ? -offsetY : 0
    }
    
    @objc fileprivate func sortAction() {
        
    }
    
    // MARK: ScrollView Delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == 0 {
            updateHeaderView()
            let offsetY = min(scrollView.contentOffset.y, 180)
            backgroundScrollView.height = headerScrollViewHeight - offsetY
            backgroundImageView.height = backgroundScrollView.height
            blurView.height = backgroundScrollView.height
            mergeView.height = backgroundScrollView.height
        }
    }
    
    // MARK: UITableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = RadioDetailListViewSection()
        view.backgroundColor = UIColor.lightGray
        view.totalNumberLabel.text = "共12期"
        view.sortButton.setTitle("⬆️排序", for: .normal)
        view.sortButton.setImage(UIImage.init(named: ""), for: .normal)
        view.sortButton.addTarget(self, action: #selector(sortAction), for: .touchUpInside)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    // MARK: UITableView DataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RadioDetailListViewCell.identifier, for: indexPath) as! RadioDetailListViewCell
        cell.rankLabel.text = indexPath.row < 9 ? "0\(indexPath.row + 1)" : "\(indexPath.row + 1)" 
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
}

class RadioDetailListHeaderView: UIView {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subscribeButton: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var isVUserImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    
    @IBOutlet weak var detailInfoLabel: UILabel!
    @IBOutlet weak var expandButton: UIButton!
    
    @IBOutlet weak var backgroundImageViewHeightConstraint: NSLayoutConstraint!
}

class RadioDetailListViewCell: UITableViewCell {
    static let identifier = "RadioDetailListViewCell"
    
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var thumbUpLabel: UILabel!
    @IBOutlet weak var subscribeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    
    @IBOutlet weak var seperateLineView: UIView!
}

class RadioDetailListViewSection: UIView {
    let totalNumberLabel = UILabel()
    let sortButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(totalNumberLabel)
        addSubview(sortButton)
        
        totalNumberLabel.textColor = UIColor.gray
        totalNumberLabel.font = UIFont.systemFont(ofSize: 14)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        totalNumberLabel.frame = CGRect(x: 0, y: 0, width: 100, height: frame.height)
        sortButton.frame = CGRect(x: frame.width - 40, y: 0, width: 30, height: frame.height)
    }
}
