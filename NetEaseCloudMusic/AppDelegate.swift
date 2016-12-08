//
//  AppDelegate.swift
//  NetEaseCloudMusic
//
//  Created by Ampire_Dan on 16/6/14.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        NetworkMusicApi.shareInstance.getCurrentLoginUserFollows { (data, error) in
//            guard let dict = data?.jsonDict else {
//                if let err = error {
//                    print(err)
//                } else {
//                    print("data cannot be transferred to jsonDict")
//                }
//                return
//            }
//            if dict["code"] as? Int != 200 {
//                print("code =\(dict["code"] as? Int)")
//                return
//            }
//            DatabaseManager.shareInstance.storeFollowsData(data: dict)
//        }
        
        var backImage = UIImage.init(named: "cm2_icn_back")
        backImage = backImage?.resizableImage(withCapInsets: UIEdgeInsetsMake(0, backImage!.size.width - 1, 0, 0))
        let barbutton = UIBarButtonItem.appearance()
        barbutton.setBackButtonBackgroundImage(backImage, for: UIControlState(), barMetrics: .default)
        barbutton.setTitlePositionAdjustment(UIOffsetMake(0, -60), for: .default)
        return true
    }
    
    
    
}

