//
//  UIView+Extension.swift
//  NetEaseCloudMusic
//
//  Created by Dan.Lee on 2016/12/6.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit

extension UIView {
    func setGradientBackgroundColorInHorizontal(fromColor fcolor: UIColor, toColor tcolor: UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [fcolor, tcolor]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        self.layer.insertSublayer(gradient, at: 0)
        
    }
    
    
    func setGradientBackgroundColorInVertical(fromColor fcolor: UIColor, toColor tcolor: UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [fcolor, tcolor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        self.layer.insertSublayer(gradient, at: 0)
    }
}
