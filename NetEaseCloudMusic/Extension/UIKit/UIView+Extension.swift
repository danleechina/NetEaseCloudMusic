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
    
    var left: CGFloat {
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
        get {
            return frame.origin.x
        }
    }
    
    var right: CGFloat {
        set {
            var frame = self.frame
            frame.origin.x = newValue - frame.width
            self.frame = frame
        }
        get {
            return frame.origin.x + frame.width
        }
    }
    
    var top: CGFloat {
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
        get {
            return frame.origin.y
        }
    }
    
    var bottom: CGFloat {
        set {
            var frame = self.frame
            frame.origin.y = newValue - frame.height
            self.frame = frame
        }
        get {
            return frame.origin.y + frame.height
        }
    }
    
    var centerY: CGFloat {
        set {
            var frame = self.frame
            frame.origin.y = newValue - frame.height/2
            self.frame = frame
        }
        get {
            return frame.origin.y + frame.height/2
        }
    }
    
    var centerX: CGFloat {
        set {
            var frame = self.frame
            frame.origin.x = newValue - frame.width/2
            self.frame = frame
        }
        get {
            return frame.origin.x + frame.width/2
        }
    }
    
    
    var height: CGFloat {
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
        get {
            return frame.height
        }
    }
    
    var width: CGFloat {
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
        get {
            return frame.width
        }
    }
}
