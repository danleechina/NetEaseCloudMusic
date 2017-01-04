//
//  RadioDetailListViewController.swift
//  NetEaseCloudMusic
//
//  Created by Dan.Lee on 2017/1/4.
//  Copyright © 2017年 Ampire_Dan. All rights reserved.
//

import UIKit

class RadioDetailListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    fileprivate let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 70
        let cellNib = UINib.init(nibName: RadioDetailListViewCell.identifier, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: RadioDetailListViewCell.identifier)
        let headerNib = UINib.init(nibName: "RadioDetailListHeaderView", bundle: nil)
        let tableHeaderView = headerNib.instantiate(withOwner: nil, options: nil).last as! RadioDetailListHeaderView
        tableView.tableHeaderView = tableHeaderView
        
        tableHeaderView.backgroundImageView.image = UIImage.init(named: "2.jpg")
        tableHeaderView.authorImageView.image = UIImage.init(named: "3.jpg")
        tableHeaderView.nameLabel.text = "尖子入眠"
        tableHeaderView.subscribeButton.setTitle("订阅（1333)", for: .normal)
        tableHeaderView.subscribeButton.setImage(UIImage.init(named: "cm2_list_icn_subscribe"), for: .normal)
        tableHeaderView.titleLabel.text = "在此见字如面"
        tableHeaderView.detailInfoLabel.text = "fsfa的房间啊三闾大夫；见阿三；房间啊是否见阿三；地理放假啊放假啊；的手机发呆思考了；富士康大楼附近开了仨的肌肤；阿世界的饭卡的身份；阿的索科洛夫集散地；发生的；肌肤；阿里斯顿发见阿三；就发生；房间阿莱克斯；房间啊时间发；是否见阿三；了看的就发生"
        
        tableHeaderView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 188)
        tableView.frame = CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height - 64)
        view.addSubview(tableView)
        
        navigationBar.leftButton.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
        navigationBar.leftButton.setImage(UIImage.init(named: "cm2_icn_back")?.renderWith(color: UIColor.black), for: UIControlState())
        navigationBar.leftButton.setImage(UIImage.init(named: "cm2_icn_back")?.renderWith(color: UIColor.black), for: .highlighted)
        navigationBar.titleString = "电台"
        navigationBar.rightButton.addTarget(self, action: #selector(goPlaySongVC), for: .touchUpInside)
        navigationBar.rightButton.setImage(UIImage.init(named: "cm2_topbar_icn_playing")?.renderWith(color: UIColor.black), for: UIControlState())
        navigationBar.rightButton.setImage(UIImage.init(named: "cm2_topbar_icn_playing_prs")?.renderWith(color: UIColor.black), for: .highlighted)
        navigationBar.backgroundColor = UIColor.white
        view.addSubview(statusBar)
        view.addSubview(navigationBar)
    }
    
    @objc fileprivate func sortAction() {
        
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
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var coverBlurView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subscribeButton: UIButton!
    
    
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var isVUserImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    
    @IBOutlet weak var detailInfoLabel: UILabel!
    @IBOutlet weak var expandButton: UIButton!
    
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
