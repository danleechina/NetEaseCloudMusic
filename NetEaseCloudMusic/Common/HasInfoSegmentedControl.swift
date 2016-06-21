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
            for button in self.titleButtons {
                button.selected = false
            }
            titleButtons[currentSelectedIndex].selected = true
            
            let length = numbers.count
            let width:CGFloat = self.bounds.size.width/CGFloat(length)
            self.maskBackgroundView.frame = CGRectMake(CGFloat(currentSelectedIndex) * width, 0, width, HasInfoSegmentedControl.height)
            self.sendActionsForControlEvents(.ValueChanged)
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
    
    private var titleButtons = [UIButton]()
    private var roundNumberLabels = [RoundNumberLabel]()
    private var seperateLineViews = [UIView]()
    private var maskBackgroundView = UIView()
    private var contentView = UIView()
    
    init(frame: CGRect, numbers: Array<Int>, items: Array<String>) {
        super.init(frame: frame)
        let length = numbers.count < items.count ? numbers.count : items.count
        
        contentView.addSubview(maskBackgroundView)
        self.maskBackgroundView.backgroundColor = UIColor.lightGrayColor()
        
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
        
        contentView.layer.borderColor = UIColor.lightGrayColor().CGColor
        contentView.layer.borderWidth = 0.5
        contentView.layer.cornerRadius = 3
        contentView.backgroundColor = UIColor.whiteColor()
        contentView.clipsToBounds = true
        
        currentSelectedIndex = 0
        titleButtons[currentSelectedIndex].selected = true
    }
    
    func isNeedLeftBorder(index: Int, total: Int) -> Bool {
        if index < total {
            return true
        }
        return false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let length = numbers.count
        let width:CGFloat = self.bounds.size.width/CGFloat(length)
        self.contentView.frame = CGRectMake(0, FixedValue.segementHeight/2 - HasInfoSegmentedControl.height/2, self.bounds.size.width, HasInfoSegmentedControl.height)
        for index in 0 ..< length {
            titleButtons[index].frame = CGRectMake(CGFloat(index) * width, 0, width, HasInfoSegmentedControl.height)
            
            roundNumberLabels[index].sizeToFit()
            let constraintRect = CGSize(width: width, height: HasInfoSegmentedControl.height)
            let sizeOfText = titleButtons[index].currentTitle!.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:
                titleButtons[index].titleLabel!.font], context: nil)
            let roundNumberLabelSize = roundNumberLabels[index].bounds.size
            roundNumberLabels[index].frame = CGRectMake(CGFloat(index) * width + width/2 + sizeOfText.width/2, FixedValue.segementHeight/2  - sizeOfText.height/2 - HasInfoSegmentedControl.offsetFromCenterY - roundNumberLabelSize.height/2, roundNumberLabelSize.width, roundNumberLabelSize.height)
            
        }
        
        for index in 0 ..< length {
            seperateLineViews[index].frame = CGRectMake(CGFloat(index) * width, 0, 0.5, HasInfoSegmentedControl.height)
        }
        self.maskBackgroundView.frame = CGRectMake(CGFloat(currentSelectedIndex) * width, 0, width, HasInfoSegmentedControl.height)
    }
    
    func getAButton(text: String, tag: Int) -> UIButton {
        let button = UIButton()
        button.setTitle(text, forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: [.Selected])
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button.addTarget(self, action: #selector(changeApperance), forControlEvents: .TouchUpInside)
        button.tag = tag
        button.titleLabel?.font = UIFont.systemFontOfSize(12)
        button.backgroundColor = UIColor.clearColor()
        return button
    }
    
    func getARoundNumberLabel(number: Int, tag: Int) -> RoundNumberLabel {
        let roundNumberLabel = RoundNumberLabel()
        roundNumberLabel.number = number
        roundNumberLabel.tag = tag
        return roundNumberLabel
    }
    
    func getASeperateLine() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.lightGrayColor()
        return view
    }
    
    func changeApperance(sender: UIButton) -> Void {
        if currentSelectedIndex != sender.tag {
            currentSelectedIndex = sender.tag
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

