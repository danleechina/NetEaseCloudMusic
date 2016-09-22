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
    
    class func getFilePath() -> URL? {
        if let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true).first {
            let path = URL(fileURLWithPath: dir).appendingPathComponent("SongSheet")
            return path;
        }
        return nil
    }
    
    class func loadSongSheetData(_ completion:@escaping (_ data: [SongSheet]?, _ error: NSError?) -> Void) {
        if UserDefaults.standard.bool(forKey: "SongSheetCache") {
            let date = UserDefaults.standard.object(forKey: "SongSheetCacheTime") as! Date
            let dateDay = (Calendar.current as NSCalendar).component(.day, from: date)
            
            let currentDate = Date()
            let currentDay = (Calendar.current as NSCalendar).component(.day, from: currentDate)
            
            if dateDay == currentDay {
                let data = try! NSString(contentsOf: getFilePath()!, encoding: String.Encoding.utf8.rawValue)
                completion(transfer(data as String), nil)
                return
            }
            
        }
        
        let netease = NetworkMusicApi.shareInstance
        netease.top_playlists { (data, error) in
            if let err = error {
                print(err)
            } else {
                do {
                    if data != nil {
                        do {
                            try data?.write(to: getFilePath()!, atomically: false, encoding: String.Encoding.utf8)
                        }
                        UserDefaults.standard.set(true, forKey: "SongSheetCache")
                        UserDefaults.standard.set(Date(), forKey: "SongSheetCacheTime")
                        UserDefaults.standard.synchronize()
                        let songSheets = transfer(data)
                        completion(songSheets, nil)
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
        }
    }
    
    class func transfer(_ data: String?) -> Array<SongSheet>? {
        
        let dict = try! JSONSerialization.jsonObject(with: (data?.data(using: String.Encoding.utf8))!, options: []) as? [String:AnyObject]
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
}
