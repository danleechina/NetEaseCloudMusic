//
//  RadioOneTableViewController.swift
//  NetEaseCloudMusic
//
//  Created by Dan.Lee on 2017/1/4.
//  Copyright © 2017年 Ampire_Dan. All rights reserved.
//

import UIKit

class RadioOneTableViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    var dataType = 0
    
    fileprivate let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        let cellNib = UINib.init(nibName: "RadioOneTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: RadioOneTableViewCell.identifier)
        tableView.register(RadioTableOneViewSection.self, forCellReuseIdentifier: RadioTableOneViewSection.identifier)
        tableView.frame = view.bounds
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let margin: CGFloat = 8
        tableView.frame = CGRect(x: margin, y: margin, width: view.bounds.width - 2 * margin, height: view.bounds.height - 2 * margin)
    }

    
    // MARK: UITableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if dataType == 0 && (indexPath.section == 0 || indexPath.section == 4) {
            return 30
        }
        return 100
    }
    
    // MARK: UITableView DataSouce
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataType == 0 ? 3 + 10 : 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if dataType == 0 && (indexPath.section == 0 || indexPath.section == 4) {
            let cell = tableView.dequeueReusableCell(withIdentifier: RadioTableOneViewSection.identifier, for: indexPath) as! RadioTableOneViewSection
            cell.titleLabel.text = "上升最快"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: RadioOneTableViewCell.identifier, for: indexPath) as! RadioOneTableViewCell
            if !(dataType == 0) {
                cell.authorInfoLabel.isHidden = false
                cell.authorInfoLabel.text = "双生子"
            } else {
                cell.authorInfoLabel.isHidden = true
            }
            cell.leftImageView.image = UIImage.init(named: "1.jpg")
            cell.titleLabel.text = "获准的电台"
            cell.infoLabel.text = "听魂准叫音乐"
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.layer.borderWidth = 0.5
            return cell
        }
    }
}

class RadioOneTableViewCell: UITableViewCell {
    static let identifier = "RadioOneTableViewCell"
    
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var seperateLineView: UIView!
    @IBOutlet weak var textContentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorInfoLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
}

class RadioTableOneViewSection: UITableViewCell {
    static let identifier = "RadioTableOneViewSection"
    let indicatorView = UIView()
    let titleLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: RadioTableOneViewSection.identifier)
        
        indicatorView.backgroundColor = FixedValue.mainRedColor
        
        addSubview(indicatorView)
        addSubview(titleLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        indicatorView.frame = CGRect(x: 0, y: 0, width: 4, height: frame.height)
        titleLabel.frame = CGRect(x: 8, y: 0, width: frame.width - 8, height: frame.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
