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
    
    
    class func loadSongSheetData(playListID: String, completion:(data: CertainSongSheet?, error: NSError?) -> Void) {
        let netease = NetworkMusicApi()
        netease.playlist_detail(playListID) { (data, error) in
            if let err = error {
                print(err)
            } else {
                do {
                    if data != nil {
                        
                        let dict = try NSJSONSerialization.JSONObjectWithData((data?.dataUsingEncoding(NSUTF8StringEncoding))!, options: []) as? [String:AnyObject]
                        let result = dict!["result"] as! Dictionary<String, AnyObject>
                        let tracks = result["tracks"] as! Array<Dictionary<String, AnyObject>>
                        let certainSongSheet = CertainSongSheet()
                        certainSongSheet.tracks = tracks
                        completion(data: certainSongSheet, error: nil)
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
        }

//        let path = NSBundle.mainBundle().pathForResource("SongSheetDetails", ofType: "geojson")
//        let data = NSData(contentsOfFile: path!)
//        if data != nil {
//            let dict: NSDictionary = (try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)) as! NSDictionary
//            let result = dict["result"] as! Dictionary<String, AnyObject>
//            let tracks = result["tracks"] as! Array<Dictionary<String, AnyObject>>
//            let certainSongSheet = CertainSongSheet()
//            certainSongSheet.tracks = tracks
//            completion(data: certainSongSheet, error: nil)
//        }
    }
}
