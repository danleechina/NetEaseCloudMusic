//
//  HasInfoSegmentedControl.swift
//  NetEaseCloudMusic
//
//  Created by Ampire_Dan on 16/6/19.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit


//TODO: 圆角处理
class HasInfoSegmentedControl: UIControl {
    static let height:CGFloat = FixedValue.segementHeight * 0.7
    static let offsetFromCenterY:CGFloat = 3
    var currentSelectedIndex = 0 {
        didSet {
            for button in titleButtons {
                button.setTitleColor(UIColor.black, for: UIControlState())
            }
            titleButtons[currentSelectedIndex].setTitleColor(UIColor.white, for: UIControlState())
            
            let length = numbers.count
            let width:CGFloat = self.bounds.size.width/CGFloat(length)
            self.maskBackgroundView.frame = CGRect(x: CGFloat(currentSelectedIndex) * width, y: 0, width: width, height: HasInfoSegmentedControl.height)
            self.sendActions(for: .valueChanged)
        }
    }
    
    var titles = [String]() {
        didSet {
            
        }
    }
    
    var numbers = [Int]() {
        didSet {
            
        }
    }
    
    fileprivate var titleButtons = [UIButton]()
    fileprivate var roundNumberLabels = [RoundNumberLabel]()
    fileprivate var seperateLineViews = [UIView]()
    fileprivate var maskBackgroundView = UIView()
    fileprivate var contentView = UIView()
    
    init(frame: CGRect, numbers: Array<Int>, items: Array<String>) {
        super.init(frame: frame)
        let length = numbers.count < items.count ? numbers.count : items.count
        
        contentView.addSubview(maskBackgroundView)
        self.maskBackgroundView.backgroundColor = UIColor.lightGray
        
        for index in 0 ..< length {
            self.titles.append(items[index])
            self.numbers.append(numbers[index])
            let button = getAButton(items[index], tag: index)
            if index == 0 || index == length - 1 {
                button.layer.cornerRadius = 3
            }
            titleButtons.append(button)
            contentView.addSubview(titleButtons[index])
        }
        
        for index in 0 ..< length {
            if isNeedLeftBorder(index, total: length) {
                seperateLineViews.append(getASeperateLine())
                contentView.addSubview(seperateLineViews[index])
            }
        }
        
        addSubview(contentView)
        
        for index in 0 ..< length {
            roundNumberLabels.append(getARoundNumberLabel(numbers[index], tag: index))
            addSubview(roundNumberLabels[index])
        }
        
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.borderWidth = 0.5
        contentView.layer.cornerRadius = 3
        contentView.backgroundColor = UIColor.white
        contentView.clipsToBounds = true
        
        currentSelectedIndex = 0
        titleButtons[currentSelectedIndex].setTitleColor(UIColor.white, for: UIControlState())
    }
    
    func isNeedLeftBorder(_ index: Int, total: Int) -> Bool {
        if index < total {
            return true
        }
        return false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let length = numbers.count
        let width:CGFloat = self.bounds.size.width/CGFloat(length)
        self.contentView.frame = CGRect(x: 0, y: FixedValue.segementHeight/2 - HasInfoSegmentedControl.height/2, width: self.bounds.size.width, height: HasInfoSegmentedControl.height)
        for index in 0 ..< length {
            titleButtons[index].frame = CGRect(x: CGFloat(index) * width, y: 0, width: width, height: HasInfoSegmentedControl.height)
            
            roundNumberLabels[index].sizeToFit()
            let constraintRect = CGSize(width: width, height: HasInfoSegmentedControl.height)
            let sizeOfText = titleButtons[index].currentTitle!.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:
                titleButtons[index].titleLabel!.font], context: nil)
            let roundNumberLabelSize = roundNumberLabels[index].bounds.size
            roundNumberLabels[index].frame = CGRect(x: CGFloat(index) * width + width/2 + sizeOfText.width/2, y: FixedValue.segementHeight/2  - sizeOfText.height/2 - HasInfoSegmentedControl.offsetFromCenterY - roundNumberLabelSize.height/2, width: roundNumberLabelSize.width, height: roundNumberLabelSize.height)
            
        }
        
        for index in 0 ..< length {
            seperateLineViews[index].frame = CGRect(x: CGFloat(index) * width, y: 0, width: 0.5, height: HasInfoSegmentedControl.height)
        }
        self.maskBackgroundView.frame = CGRect(x: CGFloat(currentSelectedIndex) * width, y: 0, width: width, height: HasInfoSegmentedControl.height)
    }
    
    func getAButton(_ text: String, tag: Int) -> UIButton {
        let button = UIButton()
        button.setTitle(text, for: UIControlState())
//        button.setTitleColor(UIColor.whiteColor(), forState: [.Selected])
        button.setTitleColor(UIColor.black, for: UIControlState())
        button.addTarget(self, action: #selector(changeApperance), for: .touchUpInside)
        button.tag = tag
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.backgroundColor = UIColor.clear
        return button
    }
    
    func getARoundNumberLabel(_ number: Int, tag: Int) -> RoundNumberLabel {
        let roundNumberLabel = RoundNumberLabel()
        roundNumberLabel.number = number
        roundNumberLabel.tag = tag
        return roundNumberLabel
    }
    
    func getASeperateLine() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }
    
    func changeApperance(_ sender: UIButton) -> Void {
        if currentSelectedIndex != sender.tag {
            currentSelectedIndex = sender.tag
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

