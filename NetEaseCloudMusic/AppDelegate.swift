//
//  AppDelegate.swift
//  NetEaseCloudMusic
//
//  Created by Ampire_Dan on 16/6/14.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        var backImage = UIImage.init(named: "cm2_icn_back")
        backImage = backImage?.resizableImageWithCapInsets(UIEdgeInsetsMake(0, backImage!.size.width - 1, 0, 0))
        let barbutton = UIBarButtonItem.appearance()
        barbutton.setBackButtonBackgroundImage(backImage, forState: .Normal, barMetrics: .Default)
        barbutton.setTitlePositionAdjustment(UIOffsetMake(0, -60), forBarMetrics: .Default)
        
        return true
    }
}

