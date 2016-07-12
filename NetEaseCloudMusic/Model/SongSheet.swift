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
    
    class func loadSongSheetData(completion:(data: [SongSheet]?, error: NSError?) -> Void) {
        
        let path = NSBundle.mainBundle().pathForResource("SongSheets", ofType: "geojson")
        let data = NSData(contentsOfFile: path!)
        if data != nil {
            let dict: NSDictionary = (try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)) as! NSDictionary
            let playLists = dict["playlists"] as! Array< Dictionary<String, AnyObject> >
            var songSheets = [SongSheet]()
            for item in playLists {
                let songSheet = SongSheet()
                songSheet.name = item["name"] as! String
                songSheet.subscribedCount = item["subscribedCount"] as! Int
                songSheet.coverImgUrl = item["coverImgUrl"] as! String
                songSheet.nickname = item["creator"]!["nickname"] as! String
                songSheets.append(songSheet)
            }
            
            completion(data: songSheets, error: nil)
        }
    }
}
