//
//  LayoutButton.swift
//  NetEaseCloudMusic
//
//  Created by Dan.Lee on 2016/12/16.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit

enum LayoutBttonDirection {
    case leftTextRightImage
    case leftImageRightText
    case topImageBottomText
    case topTextBottomImage
}

class LayoutButton: UIButton {
    var layoutButtonDirection = LayoutBttonDirection.leftImageRightText
    var defaultGap: CGFloat = 0
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let titleLabel = self.titleLabel, let imageView = self.imageView else { return }
        
        let height = imageView.height + titleLabel.height
        let deltaY = (self.height - height)/2
        
        let width = CGFloat.maximum(imageView.width, titleLabel.width)
        let deltaX = (self.width - width) / 2
        switch layoutButtonDirection {
        case .leftTextRightImage:
            titleLabel.left = 0
            imageView.left = titleLabel.right + defaultGap
            break
        case .leftImageRightText:
            imageView.left = 0
            titleLabel.left = imageView.right + defaultGap
            break
        case .topImageBottomText:
            imageView.left = 0
            imageView.top = 0
            titleLabel.left = 0
            titleLabel.top = imageView.bottom + defaultGap
            break
        case .topTextBottomImage:
            titleLabel.left = 0
            titleLabel.top = 0
            imageView.left = 0
            imageView.top = titleLabel.bottom + defaultGap
            break
        }
        titleLabel.top += deltaY
        imageView.top += deltaY
        titleLabel.left += deltaX
        imageView.left += deltaX
    }
}
