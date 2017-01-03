//
//  File.swift
//  NetEaseCloudMusic
//
//  Created by ios on 2016/10/6.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit

extension UIImage {
    func renderWith(color: UIColor) -> UIImage {
        var nimage = self.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(self.size, false, nimage.scale)
        color.set()
        nimage.draw(in: CGRect(x:0, y:0, width: self.size.width, height: nimage.size.height))
        nimage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return nimage
    }
}
