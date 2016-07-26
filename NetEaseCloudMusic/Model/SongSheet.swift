//
//  SongSheet.swift
//  NetEaseCloudMusic
//
//  Created by Ampire_Dan on 2016/7/12.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit

class SongSheet: NSObject {
    var name = ""
    var subscribedCount = 123
    var coverImgUrl = ""
    var nickname = ""
    var playListID = ""
    
    class func getFilePath() -> NSURL? {
        if let dir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .AllDomainsMask, true).first {
            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent("SongSheet")
            return path;
        }
        return nil
    }
    
    class func loadSongSheetData(completion:(data: [SongSheet]?, error: NSError?) -> Void) {
        if NSUserDefaults.standardUserDefaults().boolForKey("songsheetcache") {
            let data = try! NSString(contentsOfURL: getFilePath()!, encoding: NSUTF8StringEncoding)
            completion(data: transfer(data as String), error: nil)
        }
        
        let netease = NetworkMusicApi()
        netease.top_playlists { (data, error) in
            if let err = error {
                print(err)
            } else {
                do {
                    if data != nil {
                        do {
                            try data?.writeToURL(getFilePath()!, atomically: false, encoding: NSUTF8StringEncoding)
                        }
                        let songSheets = transfer(data)
                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "songsheetcache")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        completion(data: songSheets, error: nil)
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
        }
    }
    
    class func transfer(data: String?) -> Array<SongSheet>? {
        
        let dict = try! NSJSONSerialization.JSONObjectWithData((data?.dataUsingEncoding(NSUTF8StringEncoding))!, options: []) as? [String:AnyObject]
        let playLists = dict!["playlists"] as! Array< Dictionary<String, AnyObject> >
        var songSheets = [SongSheet]()
        for item in playLists {
            let songSheet = SongSheet()
            songSheet.name = item["name"] as! String
            songSheet.subscribedCount = item["subscribedCount"] as! Int
            songSheet.coverImgUrl = item["coverImgUrl"] as! String
            songSheet.nickname = item["creator"]!["nickname"] as! String
            songSheet.playListID = "\(item["id"]!)"
            songSheets.append(songSheet)
        }
        return songSheets
    }
//        let path = NSBundle.mainBundle().pathForResource("SongSheets", ofType: "geojson")
//        let data = NSData(contentsOfFile: path!)
//        if data != nil {
//            let dict: NSDictionary = (try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)) as! NSDictionary
//            let playLists = dict["playlists"] as! Array< Dictionary<String, AnyObject> >
//            var songSheets = [SongSheet]()
//            for item in playLists {
//                let songSheet = SongSheet()
//                songSheet.name = item["name"] as! String
//                songSheet.subscribedCount = item["subscribedCount"] as! Int
//                songSheet.coverImgUrl = item["coverImgUrl"] as! String
//                songSheet.nickname = item["creator"]!["nickname"] as! String
//                songSheets.append(songSheet)
//            }
//            
//            completion(data: songSheets, error: nil)
//        }
}
