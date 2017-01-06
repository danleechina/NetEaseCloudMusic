//
//  RadioTwoTableViewController.swift
//  NetEaseCloudMusic
//
//  Created by Dan.Lee on 2017/1/4.
//  Copyright © 2017年 Ampire_Dan. All rights reserved.
//

import UIKit

class RadioTwoTableViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    var dataType = 0
    
    
    fileprivate let tableView = UITableView()
    fileprivate lazy var infoView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        
        let blackView = UIView()
        blackView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(blackView)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 80
        let tableHeaderView = RadioTwoTableHeaderView()
        tableView.tableHeaderView = tableHeaderView
        tableView.tableFooterView = UIView()
        let cellNib = UINib.init(nibName: RadioTwoTableViewCell.identifier, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: RadioTwoTableViewCell.identifier)
        tableHeaderView.infoLabel.text = "最近更新：1月4日"
        tableHeaderView.infoButton.setImage(UIImage.init(named: "cm2_list_rank_icn_infor"), for: .normal)
        tableHeaderView.infoButton.addTarget(self, action: #selector(tapTableViewHeaderInfoButton), for: .touchUpInside)
        tableHeaderView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 40)
        
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let margin: CGFloat = 0
        let hasNavigationBar = view.subviews.contains(navigationBar)
        let solveForNavigationBar: CGFloat = hasNavigationBar ? 64 : 0
        tableView.frame = CGRect(x: margin, y: margin + solveForNavigationBar, width: view.bounds.width - 2 * margin, height: view.bounds.height - 2 * margin - solveForNavigationBar)
    }
    
    @objc fileprivate func tapTableViewHeaderInfoButton() {
        
    }
    
    // MARK: UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RadioTwoTableViewCell.identifier, for: indexPath) as! RadioTwoTableViewCell
        cell.rankLabel.text = indexPath.row < 9 ? "0\(indexPath.row+1)" : "\(indexPath.row+1)"
        cell.rankLabel.textColor = indexPath.row < 3 ? FixedValue.mainRedColor : UIColor.lightGray
        
        cell.tendencyLabel.text = "NEW"
        cell.tendencyLabel.textColor = UIColor.green
        
        cell.mainImageView.image = UIImage.init(named: "2.jpg")
        
        cell.titleLabel.text = "你要他有车哟房，那么你得有车有房线啊"
        cell.authorLabel.text = "一个人听的音乐"
        cell.infoLabel.text = "100000"
        return cell
    }
    
    // MARK: UITableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

class RadioTwoTableViewCell: UITableViewCell {
    static let identifier = "RadioTwoTableViewCell"
    
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var tendencyLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var seperateLineView: UIView!
    
}

class RadioTwoTableHeaderView: UIView {
    let infoLabel = UILabel()
    let infoButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(infoButton)
        addSubview(infoLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        infoLabel.frame = CGRect(x: 0, y: 0, width: frame.width - 55, height: frame.height)
        infoButton.frame = CGRect(x: frame.width - 30, y: frame.height/2 - 15, width: 30, height: 30)
    }
}
