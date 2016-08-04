//
//  CertainSongSheet.swift
//  NetEaseCloudMusic
//
//  Created by Ampire_Dan on 2016/7/14.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit

class CertainSongSheet: NSObject {

    var tracks = Array<Dictionary<String, AnyObject>>()
    var id = -1
    
    class func getFilePath() -> NSURL? {
        if let dir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .AllDomainsMask, true).first {
            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent("CertainSongSheet")
            return path;
        }
        return nil
    }
    
    
    class func loadSongSheetData(playListID: String, completion:(data: CertainSongSheet?, error: NSError?) -> Void) {
        if NSUserDefaults.standardUserDefaults().boolForKey("CertainSongSheetCache+\(playListID)") {
            let date = NSUserDefaults.standardUserDefaults().objectForKey("CertainSongSheetTime+\(playListID)") as! NSDate
            let dateDay = NSCalendar.currentCalendar().component(.Day, fromDate: date)
            
            let currentDate = NSDate()
            let currentDay = NSCalendar.currentCalendar().component(.Day, fromDate: currentDate)
            
            if dateDay == currentDay {
                let data = try! NSString(contentsOfURL: getFilePath()!, encoding: NSUTF8StringEncoding)
                completion(data: transfer(data as String), error: nil)
                return
            }
            
        }
        
        let netease = NetworkMusicApi.shareInstance
        netease.playlist_detail(playListID) { (data, error) in
            if let err = error {
                print(err)
            } else {
                if let nndata = data {
                    do {
                        try nndata.writeToURL(getFilePath()!, atomically: false, encoding: NSUTF8StringEncoding)
                    } catch let error as NSError {
                        print(error)
                    }
                    let tranData = transfer(nndata)
                    completion(data: tranData, error: nil)
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "CertainSongSheetCache+\(tranData.id)" )
                    NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: "CertainSongSheetTime+\(tranData.id)")
                    NSUserDefaults.standardUserDefaults().synchronize()
                }
            }
        }
    }
    
    class func transfer(data: String?) -> CertainSongSheet {
        let certainSongSheet = CertainSongSheet()
        do {
            let dict = try NSJSONSerialization.JSONObjectWithData((data?.dataUsingEncoding(NSUTF8StringEncoding))!, options: []) as? [String:AnyObject]
            let result = dict!["result"] as! Dictionary<String, AnyObject>
            let tracks = result["tracks"] as! Array<Dictionary<String, AnyObject>>
            certainSongSheet.tracks = tracks
            certainSongSheet.id = result["id"] as! Int
        } catch let error as NSError {
            print(error)
        }
        return certainSongSheet
    }
}
