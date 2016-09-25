//
//  BaseNavigationBar.swift
//  NetEaseCloudMusic
//
//  Created by ios on 16/9/13.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit
import SnapKit

class BaseNavigationBar: UIView {
    var titleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    var leftButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        return button
    }()
    
    var rightButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        return button
    }()
    
    var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleView)
        addSubview(leftButton)
        addSubview(rightButton)
        addSubview(lineView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleView.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.width.equalTo(150)
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        leftButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left)
            make.centerY.equalTo(self.snp.centerY)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        
        rightButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.right)
            make.centerY.equalTo(self.snp.centerY)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.width.equalTo(self.snp.width)
            make.left.equalTo(self.snp.left)
            make.bottom.equalTo(self.snp.bottom)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
