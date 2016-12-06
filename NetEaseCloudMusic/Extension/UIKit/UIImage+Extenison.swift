//
//  UIImage+Extenison.swift
//  NetEaseCloudMusic
//
//  Created by Dan.Lee on 2016/12/6.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit

extension UIImage {
    func renderContent(toColor color: UIColor) -> UIImage? {
        guard let originalCGImage = self.cgImage else {
            return nil
        }
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.clip(to: rect, mask: originalCGImage)
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
