//
//  CertainSongSheet.swift
//  NetEaseCloudMusic
//
//  Created by Ampire_Dan on 2016/7/14.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit

//class CertainSongSheet: NSObject {
//
//    var tracks = Array<Dictionary<String, AnyObject>>()
//    var id = -1
//    
//    class func getFilePath(id: Int) -> NSURL? {
//        if let dir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .AllDomainsMask, true).first {
//            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent("CertainSongSheet+\(id)")
//            return path;
//        }
//        return nil
//    }
//    
//    
//    class func loadSongSheetData(playListID: String, completion:(data: CertainSongSheet?, error: NSError?) -> Void) {
//        if NSUserDefaults.standardUserDefaults().boolForKey("CertainSongSheetCache+\(playListID)") {
//            let date = NSUserDefaults.standardUserDefaults().objectForKey("CertainSongSheetTime+\(playListID)") as! NSDate
//            let dateDay = NSCalendar.currentCalendar().component(.Day, fromDate: date)
//            
//            let currentDate = NSDate()
//            let currentDay = NSCalendar.currentCalendar().component(.Day, fromDate: currentDate)
//            
//            if dateDay == currentDay {
//                let data = try! NSString(contentsOfURL: getFilePath(Int(playListID)!)!, encoding: NSUTF8StringEncoding)
//                completion(data: transfer(data as String), error: nil)
//                return
//            }
//            
//        }
//        
//        let netease = NetworkMusicApi.shareInstance
//        netease.playlist_detail(playListID) { (data, error) in
//            if let err = error {
//                print(err)
//            } else {
//                if let nndata = data {
//                    let tranData = transfer(nndata)
//                    completion(data: tranData, error: nil)
//                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "CertainSongSheetCache+\(tranData.id)" )
//                    NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: "CertainSongSheetTime+\(tranData.id)")
//                    NSUserDefaults.standardUserDefaults().synchronize()
//                    do {
//                        try nndata.writeToURL(getFilePath(tranData.id)!, atomically: false, encoding: NSUTF8StringEncoding)
//                    } catch let error as NSError {
//                        print(error)
//                    }
//                }
//            }
//        }
//    }
//    
//    class func transfer(data: String?) -> CertainSongSheet {
//        let certainSongSheet = CertainSongSheet()
//        do {
//            let dict = try NSJSONSerialization.JSONObjectWithData((data?.dataUsingEncoding(NSUTF8StringEncoding))!, options: []) as? [String:AnyObject]
//            let result = dict!["result"] as! Dictionary<String, AnyObject>
//            let tracks = result["tracks"] as! Array<Dictionary<String, AnyObject>>
//            certainSongSheet.tracks = tracks
//            certainSongSheet.id = result["id"] as! Int
//        } catch let error as NSError {
//            print(error)
//        }
//        return certainSongSheet
//    }
//}

//
//	Result.swift
//
//	Create by 政达 李 on 11/9/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class CertainSongSheet : NSObject, NSCoding{
    
    class func getFilePath(_ id: Int) -> URL? {
        if let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true).first {
            let path = URL(fileURLWithPath: dir).appendingPathComponent("CertainSongSheet+\(id)")
            return path;
        }
        return nil
    }
    
    
    class func loadSongSheetData(_ playListID: String, completion:@escaping (_ data: CertainSongSheet?, _ error: NSError?) -> Void) {
        if UserDefaults.standard.bool(forKey: "CertainSongSheetCache+\(playListID)") {
            let date = UserDefaults.standard.object(forKey: "CertainSongSheetTime+\(playListID)") as! Date
            let dateDay = (Calendar.current as NSCalendar).component(.day, from: date)
            
            let currentDate = Date()
            let currentDay = (Calendar.current as NSCalendar).component(.day, from: currentDate)
            
            if dateDay == currentDay {
                let data = try! NSString(contentsOf: getFilePath(Int(playListID)!)!, encoding: String.Encoding.utf8.rawValue)
                completion(transfer(data as String), nil)
                return
            }
            
        }
        
        let netease = NetworkMusicApi.shareInstance
        netease.playlist_detail(playListID) { (data, error) in
            if let err = error {
                print(err)
            } else {
                if let nndata = data {
                    if let tranData = transfer(nndata) {
                        completion(tranData, nil)
                        UserDefaults.standard.set(true, forKey: "CertainSongSheetCache+\(tranData.id)" )
                        UserDefaults.standard.set(Date(), forKey: "CertainSongSheetTime+\(tranData.id)")
                        UserDefaults.standard.synchronize()
                        do {
                            try nndata.write(to: getFilePath(tranData.id)!, atomically: false, encoding: String.Encoding.utf8)
                        } catch let error as NSError {
                            print(error)
                        }
                    }
                }
            }
        }
    }
    
    class func transfer(_ data: String?) -> CertainSongSheet? {
        var certainSongSheet:CertainSongSheet?
        do {
            let dict = try JSONSerialization.jsonObject(with: (data?.data(using: String.Encoding.utf8))!, options: []) as? [String:AnyObject]
//            let result = dict!["result"] as! Dictionary<String, AnyObject>
//            let tracks = result["tracks"] as! Array<Dictionary<String, AnyObject>>
//            certainSongSheet.tracks = tracks
//            certainSongSheet.id = result["id"] as! Int
            if let result = dict!["result"] {
                certainSongSheet = CertainSongSheet.init(fromDictionary: result as! NSDictionary)
            }
        } catch let error as NSError {
            print(error)
        }
        return certainSongSheet
    }

    var adType : Int!
    var artists : AnyObject?
    var cloudTrackCount : Int!
    var commentCount : Int!
    var commentThreadId : String!
    var coverImgId : Int!
    var coverImgUrl : String!
    var createTime : Int!
    var creator : Creator!
    var descriptionField : String!
    var highQuality : Bool!
    var id : Int!
    var name : String!
    var newImported : Bool!
    var playCount : Int!
    var shareCount : Int!
    var specialType : Int!
    var status : Int!
    var subscribed : Bool!
    var subscribedCount : Int!
    var subscribers : [AnyObject]!
    var tags : [String]!
    var totalDuration : Int!
    var trackCount : Int!
    var trackNumberUpdateTime : Int!
    var trackUpdateTime : Int!
    var tracks : [Track]!
    var updateTime : Int!
    var userId : Int!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: NSDictionary){
        adType = dictionary["adType"] as? Int
//        if let data = dictionary["artists"] {
//            artists = data
//        }
        artists = dictionary["artists"] as? AnyObject
        cloudTrackCount = dictionary["cloudTrackCount"] as? Int
        commentCount = dictionary["commentCount"] as? Int
        commentThreadId = dictionary["commentThreadId"] as? String
        coverImgId = dictionary["coverImgId"] as? Int
        coverImgUrl = dictionary["coverImgUrl"] as? String
        createTime = dictionary["createTime"] as? Int
        if let creatorData = dictionary["creator"] as? NSDictionary{
            creator = Creator(fromDictionary: creatorData)
        }
        descriptionField = dictionary["description"] as? String
        highQuality = dictionary["highQuality"] as? Bool
        id = dictionary["id"] as? Int
        name = dictionary["name"] as? String
        newImported = dictionary["newImported"] as? Bool
        playCount = dictionary["playCount"] as? Int
        shareCount = dictionary["shareCount"] as? Int
        specialType = dictionary["specialType"] as? Int
        status = dictionary["status"] as? Int
        subscribed = dictionary["subscribed"] as? Bool
        subscribedCount = dictionary["subscribedCount"] as? Int
        subscribers = dictionary["subscribers"] as? [AnyObject]
        tags = dictionary["tags"] as? [String]
        totalDuration = dictionary["totalDuration"] as? Int
        trackCount = dictionary["trackCount"] as? Int
        trackNumberUpdateTime = dictionary["trackNumberUpdateTime"] as? Int
        trackUpdateTime = dictionary["trackUpdateTime"] as? Int
        tracks = [Track]()
        if let tracksArray = dictionary["tracks"] as? [NSDictionary]{
            for dic in tracksArray{
                let value = Track(fromDictionary: dic)
                tracks.append(value)
            }
        }
        updateTime = dictionary["updateTime"] as? Int
        userId = dictionary["userId"] as? Int
    }
    
    /**
     * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> NSDictionary
    {
        let dictionary = NSMutableDictionary()
        if adType != nil{
            dictionary["adType"] = adType
        }
        if artists != nil{
            dictionary["artists"] = artists
        }
        if cloudTrackCount != nil{
            dictionary["cloudTrackCount"] = cloudTrackCount
        }
        if commentCount != nil{
            dictionary["commentCount"] = commentCount
        }
        if commentThreadId != nil{
            dictionary["commentThreadId"] = commentThreadId
        }
        if coverImgId != nil{
            dictionary["coverImgId"] = coverImgId
        }
        if coverImgUrl != nil{
            dictionary["coverImgUrl"] = coverImgUrl
        }
        if createTime != nil{
            dictionary["createTime"] = createTime
        }
        if creator != nil{
            dictionary["creator"] = creator.toDictionary()
        }
        if descriptionField != nil{
            dictionary["description"] = descriptionField
        }
        if highQuality != nil{
            dictionary["highQuality"] = highQuality
        }
        if id != nil{
            dictionary["id"] = id
        }
        if name != nil{
            dictionary["name"] = name
        }
        if newImported != nil{
            dictionary["newImported"] = newImported
        }
        if playCount != nil{
            dictionary["playCount"] = playCount
        }
        if shareCount != nil{
            dictionary["shareCount"] = shareCount
        }
        if specialType != nil{
            dictionary["specialType"] = specialType
        }
        if status != nil{
            dictionary["status"] = status
        }
        if subscribed != nil{
            dictionary["subscribed"] = subscribed
        }
        if subscribedCount != nil{
            dictionary["subscribedCount"] = subscribedCount
        }
        if subscribers != nil{
            dictionary["subscribers"] = subscribers
        }
        if tags != nil{
            dictionary["tags"] = tags
        }
        if totalDuration != nil{
            dictionary["totalDuration"] = totalDuration
        }
        if trackCount != nil{
            dictionary["trackCount"] = trackCount
        }
        if trackNumberUpdateTime != nil{
            dictionary["trackNumberUpdateTime"] = trackNumberUpdateTime
        }
        if trackUpdateTime != nil{
            dictionary["trackUpdateTime"] = trackUpdateTime
        }
        if tracks != nil{
            var dictionaryElements = [NSDictionary]()
            for tracksElement in tracks {
                dictionaryElements.append(tracksElement.toDictionary())
            }
            dictionary["tracks"] = dictionaryElements
        }
        if updateTime != nil{
            dictionary["updateTime"] = updateTime
        }
        if userId != nil{
            dictionary["userId"] = userId
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        adType = aDecoder.decodeObject(forKey: "adType") as? Int
        artists = aDecoder.decodeObject(forKey: "artists") as AnyObject?
        cloudTrackCount = aDecoder.decodeObject(forKey: "cloudTrackCount") as? Int
        commentCount = aDecoder.decodeObject(forKey: "commentCount") as? Int
        commentThreadId = aDecoder.decodeObject(forKey: "commentThreadId") as? String
        coverImgId = aDecoder.decodeObject(forKey: "coverImgId") as? Int
        coverImgUrl = aDecoder.decodeObject(forKey: "coverImgUrl") as? String
        createTime = aDecoder.decodeObject(forKey: "createTime") as? Int
        creator = aDecoder.decodeObject(forKey: "creator") as? Creator
        descriptionField = aDecoder.decodeObject(forKey: "description") as? String
        highQuality = aDecoder.decodeObject(forKey: "highQuality") as? Bool
        id = aDecoder.decodeObject(forKey: "id") as? Int
        name = aDecoder.decodeObject(forKey: "name") as? String
        newImported = aDecoder.decodeObject(forKey: "newImported") as? Bool
        playCount = aDecoder.decodeObject(forKey: "playCount") as? Int
        shareCount = aDecoder.decodeObject(forKey: "shareCount") as? Int
        specialType = aDecoder.decodeObject(forKey: "specialType") as? Int
        status = aDecoder.decodeObject(forKey: "status") as? Int
        subscribed = aDecoder.decodeObject(forKey: "subscribed") as? Bool
        subscribedCount = aDecoder.decodeObject(forKey: "subscribedCount") as? Int
        subscribers = aDecoder.decodeObject(forKey: "subscribers") as? [AnyObject]
        tags = aDecoder.decodeObject(forKey: "tags") as? [String]
        totalDuration = aDecoder.decodeObject(forKey: "totalDuration") as? Int
        trackCount = aDecoder.decodeObject(forKey: "trackCount") as? Int
        trackNumberUpdateTime = aDecoder.decodeObject(forKey: "trackNumberUpdateTime") as? Int
        trackUpdateTime = aDecoder.decodeObject(forKey: "trackUpdateTime") as? Int
        tracks = aDecoder.decodeObject(forKey: "tracks") as? [Track]
        updateTime = aDecoder.decodeObject(forKey: "updateTime") as? Int
        userId = aDecoder.decodeObject(forKey: "userId") as? Int
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if adType != nil{
            aCoder.encode(adType, forKey: "adType")
        }
        if artists != nil{
            aCoder.encode(artists, forKey: "artists")
        }
        if cloudTrackCount != nil{
            aCoder.encode(cloudTrackCount, forKey: "cloudTrackCount")
        }
        if commentCount != nil{
            aCoder.encode(commentCount, forKey: "commentCount")
        }
        if commentThreadId != nil{
            aCoder.encode(commentThreadId, forKey: "commentThreadId")
        }
        if coverImgId != nil{
            aCoder.encode(coverImgId, forKey: "coverImgId")
        }
        if coverImgUrl != nil{
            aCoder.encode(coverImgUrl, forKey: "coverImgUrl")
        }
        if createTime != nil{
            aCoder.encode(createTime, forKey: "createTime")
        }
        if creator != nil{
            aCoder.encode(creator, forKey: "creator")
        }
        if descriptionField != nil{
            aCoder.encode(descriptionField, forKey: "description")
        }
        if highQuality != nil{
            aCoder.encode(highQuality, forKey: "highQuality")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if newImported != nil{
            aCoder.encode(newImported, forKey: "newImported")
        }
        if playCount != nil{
            aCoder.encode(playCount, forKey: "playCount")
        }
        if shareCount != nil{
            aCoder.encode(shareCount, forKey: "shareCount")
        }
        if specialType != nil{
            aCoder.encode(specialType, forKey: "specialType")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
        if subscribed != nil{
            aCoder.encode(subscribed, forKey: "subscribed")
        }
        if subscribedCount != nil{
            aCoder.encode(subscribedCount, forKey: "subscribedCount")
        }
        if subscribers != nil{
            aCoder.encode(subscribers, forKey: "subscribers")
        }
        if tags != nil{
            aCoder.encode(tags, forKey: "tags")
        }
        if totalDuration != nil{
            aCoder.encode(totalDuration, forKey: "totalDuration")
        }
        if trackCount != nil{
            aCoder.encode(trackCount, forKey: "trackCount")
        }
        if trackNumberUpdateTime != nil{
            aCoder.encode(trackNumberUpdateTime, forKey: "trackNumberUpdateTime")
        }
        if trackUpdateTime != nil{
            aCoder.encode(trackUpdateTime, forKey: "trackUpdateTime")
        }
        if tracks != nil{
            aCoder.encode(tracks, forKey: "tracks")
        }
        if updateTime != nil{
            aCoder.encode(updateTime, forKey: "updateTime")
        }
        if userId != nil{
            aCoder.encode(userId, forKey: "userId")
        }
        
    }
    
}
//
//	Track.swift
//
//	Create by 政达 李 on 11/9/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class Track : NSObject, NSCoding{
    
    var album : Album!
    var alias : [AnyObject]!
    var artists : [Artist]!
    var audition : AnyObject?
    var bMusic : BMusic!
    var commentThreadId : String!
    var copyFrom : String!
    var copyrightId : Int!
    var crbt : AnyObject?
    var dayPlays : Int!
    var disc : String!
    var duration : Int!
    var fee : Int!
    var ftype : Int!
    var hMusic : BMusic!
    var hearTime : Int!
    var id : Int!
    var lMusic : BMusic!
    var mMusic : BMusic!
    var mp3Url : String!
    var mvid : Int!
    var name : String!
    var no : Int!
    var playedNum : Int!
    var popularity : Float!
    var position : Int!
    var ringtone : String!
    var rtUrl : AnyObject?
    var rtUrls : AnyObject?
    var rtype : Int!
    var rurl : AnyObject?
    var score : Int!
    var starred : Bool!
    var starredNum : Int!
    var status : Int!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: NSDictionary){
        if let albumData = dictionary["album"] as? NSDictionary{
            album = Album(fromDictionary: albumData)
        }
        alias = dictionary["alias"] as? [AnyObject]
        artists = [Artist]()
        if let artistsArray = dictionary["artists"] as? [NSDictionary]{
            for dic in artistsArray{
                let value = Artist(fromDictionary: dic)
                artists.append(value)
            }
        }
        audition = dictionary["audition"] as? AnyObject
        if let bMusicData = dictionary["bMusic"] as? NSDictionary{
            bMusic = BMusic(fromDictionary: bMusicData)
        }
        commentThreadId = dictionary["commentThreadId"] as? String
        copyFrom = dictionary["copyFrom"] as? String
        copyrightId = dictionary["copyrightId"] as? Int
        crbt = dictionary["crbt"] as? AnyObject
        dayPlays = dictionary["dayPlays"] as? Int
        disc = dictionary["disc"] as? String
        duration = dictionary["duration"] as? Int
        fee = dictionary["fee"] as? Int
        ftype = dictionary["ftype"] as? Int
        if let hMusicData = dictionary["hMusic"] as? NSDictionary{
            hMusic = BMusic(fromDictionary: hMusicData)
        }
        hearTime = dictionary["hearTime"] as? Int
        id = dictionary["id"] as? Int
        if let lMusicData = dictionary["lMusic"] as? NSDictionary{
            lMusic = BMusic(fromDictionary: lMusicData)
        }
        if let mMusicData = dictionary["mMusic"] as? NSDictionary{
            mMusic = BMusic(fromDictionary: mMusicData)
        }
        mp3Url = dictionary["mp3Url"] as? String
        mvid = dictionary["mvid"] as? Int
        name = dictionary["name"] as? String
        no = dictionary["no"] as? Int
        playedNum = dictionary["playedNum"] as? Int
        popularity = dictionary["popularity"] as? Float
        position = dictionary["position"] as? Int
        ringtone = dictionary["ringtone"] as? String
        rtUrl = dictionary["rtUrl"] as? AnyObject
        rtUrls = dictionary["rtUrls"] as? AnyObject
        rtype = dictionary["rtype"] as? Int
        rurl = dictionary["rurl"] as? AnyObject
        score = dictionary["score"] as? Int
        starred = dictionary["starred"] as? Bool
        starredNum = dictionary["starredNum"] as? Int
        status = dictionary["status"] as? Int
    }
    
    /**
     * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> NSDictionary
    {
        let dictionary = NSMutableDictionary()
        if album != nil{
            dictionary["album"] = album.toDictionary()
        }
        if alias != nil{
            dictionary["alias"] = alias
        }
        if artists != nil{
            var dictionaryElements = [NSDictionary]()
            for artistsElement in artists {
                dictionaryElements.append(artistsElement.toDictionary())
            }
            dictionary["artists"] = dictionaryElements
        }
        if audition != nil{
            dictionary["audition"] = audition
        }
        if bMusic != nil{
            dictionary["bMusic"] = bMusic.toDictionary()
        }
        if commentThreadId != nil{
            dictionary["commentThreadId"] = commentThreadId
        }
        if copyFrom != nil{
            dictionary["copyFrom"] = copyFrom
        }
        if copyrightId != nil{
            dictionary["copyrightId"] = copyrightId
        }
        if crbt != nil{
            dictionary["crbt"] = crbt
        }
        if dayPlays != nil{
            dictionary["dayPlays"] = dayPlays
        }
        if disc != nil{
            dictionary["disc"] = disc
        }
        if duration != nil{
            dictionary["duration"] = duration
        }
        if fee != nil{
            dictionary["fee"] = fee
        }
        if ftype != nil{
            dictionary["ftype"] = ftype
        }
        if hMusic != nil{
            dictionary["hMusic"] = hMusic.toDictionary()
        }
        if hearTime != nil{
            dictionary["hearTime"] = hearTime
        }
        if id != nil{
            dictionary["id"] = id
        }
        if lMusic != nil{
            dictionary["lMusic"] = lMusic.toDictionary()
        }
        if mMusic != nil{
            dictionary["mMusic"] = mMusic.toDictionary()
        }
        if mp3Url != nil{
            dictionary["mp3Url"] = mp3Url
        }
        if mvid != nil{
            dictionary["mvid"] = mvid
        }
        if name != nil{
            dictionary["name"] = name
        }
        if no != nil{
            dictionary["no"] = no
        }
        if playedNum != nil{
            dictionary["playedNum"] = playedNum
        }
        if popularity != nil{
            dictionary["popularity"] = popularity
        }
        if position != nil{
            dictionary["position"] = position
        }
        if ringtone != nil{
            dictionary["ringtone"] = ringtone
        }
        if rtUrl != nil{
            dictionary["rtUrl"] = rtUrl
        }
        if rtUrls != nil{
            dictionary["rtUrls"] = rtUrls
        }
        if rtype != nil{
            dictionary["rtype"] = rtype
        }
        if rurl != nil{
            dictionary["rurl"] = rurl
        }
        if score != nil{
            dictionary["score"] = score
        }
        if starred != nil{
            dictionary["starred"] = starred
        }
        if starredNum != nil{
            dictionary["starredNum"] = starredNum
        }
        if status != nil{
            dictionary["status"] = status
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        album = aDecoder.decodeObject(forKey: "album") as? Album
        alias = aDecoder.decodeObject(forKey: "alias") as? [AnyObject]
        artists = aDecoder.decodeObject(forKey: "artists") as? [Artist]
        audition = aDecoder.decodeObject(forKey: "audition") as AnyObject?
        bMusic = aDecoder.decodeObject(forKey: "bMusic") as? BMusic
        commentThreadId = aDecoder.decodeObject(forKey: "commentThreadId") as? String
        copyFrom = aDecoder.decodeObject(forKey: "copyFrom") as? String
        copyrightId = aDecoder.decodeObject(forKey: "copyrightId") as? Int
        crbt = aDecoder.decodeObject(forKey: "crbt") as AnyObject?
        dayPlays = aDecoder.decodeObject(forKey: "dayPlays") as? Int
        disc = aDecoder.decodeObject(forKey: "disc") as? String
        duration = aDecoder.decodeObject(forKey: "duration") as? Int
        fee = aDecoder.decodeObject(forKey: "fee") as? Int
        ftype = aDecoder.decodeObject(forKey: "ftype") as? Int
        hMusic = aDecoder.decodeObject(forKey: "hMusic") as? BMusic
        hearTime = aDecoder.decodeObject(forKey: "hearTime") as? Int
        id = aDecoder.decodeObject(forKey: "id") as? Int
        lMusic = aDecoder.decodeObject(forKey: "lMusic") as? BMusic
        mMusic = aDecoder.decodeObject(forKey: "mMusic") as? BMusic
        mp3Url = aDecoder.decodeObject(forKey: "mp3Url") as? String
        mvid = aDecoder.decodeObject(forKey: "mvid") as? Int
        name = aDecoder.decodeObject(forKey: "name") as? String
        no = aDecoder.decodeObject(forKey: "no") as? Int
        playedNum = aDecoder.decodeObject(forKey: "playedNum") as? Int
        popularity = aDecoder.decodeObject(forKey: "popularity") as? Float
        position = aDecoder.decodeObject(forKey: "position") as? Int
        ringtone = aDecoder.decodeObject(forKey: "ringtone") as? String
        rtUrl = aDecoder.decodeObject(forKey: "rtUrl") as AnyObject?
        rtUrls = aDecoder.decodeObject(forKey: "rtUrls") as AnyObject?
        rtype = aDecoder.decodeObject(forKey: "rtype") as? Int
        rurl = aDecoder.decodeObject(forKey: "rurl") as AnyObject?
        score = aDecoder.decodeObject(forKey: "score") as? Int
        starred = aDecoder.decodeObject(forKey: "starred") as? Bool
        starredNum = aDecoder.decodeObject(forKey: "starredNum") as? Int
        status = aDecoder.decodeObject(forKey: "status") as? Int
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if album != nil{
            aCoder.encode(album, forKey: "album")
        }
        if alias != nil{
            aCoder.encode(alias, forKey: "alias")
        }
        if artists != nil{
            aCoder.encode(artists, forKey: "artists")
        }
        if audition != nil{
            aCoder.encode(audition, forKey: "audition")
        }
        if bMusic != nil{
            aCoder.encode(bMusic, forKey: "bMusic")
        }
        if commentThreadId != nil{
            aCoder.encode(commentThreadId, forKey: "commentThreadId")
        }
        if copyFrom != nil{
            aCoder.encode(copyFrom, forKey: "copyFrom")
        }
        if copyrightId != nil{
            aCoder.encode(copyrightId, forKey: "copyrightId")
        }
        if crbt != nil{
            aCoder.encode(crbt, forKey: "crbt")
        }
        if dayPlays != nil{
            aCoder.encode(dayPlays, forKey: "dayPlays")
        }
        if disc != nil{
            aCoder.encode(disc, forKey: "disc")
        }
        if duration != nil{
            aCoder.encode(duration, forKey: "duration")
        }
        if fee != nil{
            aCoder.encode(fee, forKey: "fee")
        }
        if ftype != nil{
            aCoder.encode(ftype, forKey: "ftype")
        }
        if hMusic != nil{
            aCoder.encode(hMusic, forKey: "hMusic")
        }
        if hearTime != nil{
            aCoder.encode(hearTime, forKey: "hearTime")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if lMusic != nil{
            aCoder.encode(lMusic, forKey: "lMusic")
        }
        if mMusic != nil{
            aCoder.encode(mMusic, forKey: "mMusic")
        }
        if mp3Url != nil{
            aCoder.encode(mp3Url, forKey: "mp3Url")
        }
        if mvid != nil{
            aCoder.encode(mvid, forKey: "mvid")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if no != nil{
            aCoder.encode(no, forKey: "no")
        }
        if playedNum != nil{
            aCoder.encode(playedNum, forKey: "playedNum")
        }
        if popularity != nil{
            aCoder.encode(popularity, forKey: "popularity")
        }
        if position != nil{
            aCoder.encode(position, forKey: "position")
        }
        if ringtone != nil{
            aCoder.encode(ringtone, forKey: "ringtone")
        }
        if rtUrl != nil{
            aCoder.encode(rtUrl, forKey: "rtUrl")
        }
        if rtUrls != nil{
            aCoder.encode(rtUrls, forKey: "rtUrls")
        }
        if rtype != nil{
            aCoder.encode(rtype, forKey: "rtype")
        }
        if rurl != nil{
            aCoder.encode(rurl, forKey: "rurl")
        }
        if score != nil{
            aCoder.encode(score, forKey: "score")
        }
        if starred != nil{
            aCoder.encode(starred, forKey: "starred")
        }
        if starredNum != nil{
            aCoder.encode(starredNum, forKey: "starredNum")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
        
    }
    
}
//
//	BMusic.swift
//
//	Create by 政达 李 on 11/9/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class BMusic : NSObject, NSCoding{
    
    var bitrate : Int!
    var dfsId : Int!
    var mextension : String!
    var id : Int!
    var name : String!
    var playTime : Int!
    var size : Int!
    var sr : Int!
    var volumeDelta : Float!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: NSDictionary){
        bitrate = dictionary["bitrate"] as? Int
        dfsId = dictionary["dfsId"] as? Int
        mextension = dictionary["extension"] as? String
        id = dictionary["id"] as? Int
        name = dictionary["name"] as? String
        playTime = dictionary["playTime"] as? Int
        size = dictionary["size"] as? Int
        sr = dictionary["sr"] as? Int
        volumeDelta = dictionary["volumeDelta"] as? Float
    }
    
    /**
     * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> NSDictionary
    {
        let dictionary = NSMutableDictionary()
        if bitrate != nil{
            dictionary["bitrate"] = bitrate
        }
        if dfsId != nil{
            dictionary["dfsId"] = dfsId
        }
        if mextension != nil{
            dictionary["mextension"] = mextension
        }
        if id != nil{
            dictionary["id"] = id
        }
        if name != nil{
            dictionary["name"] = name
        }
        if playTime != nil{
            dictionary["playTime"] = playTime
        }
        if size != nil{
            dictionary["size"] = size
        }
        if sr != nil{
            dictionary["sr"] = sr
        }
        if volumeDelta != nil{
            dictionary["volumeDelta"] = volumeDelta
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        bitrate = aDecoder.decodeObject(forKey: "bitrate") as? Int
        dfsId = aDecoder.decodeObject(forKey: "dfsId") as? Int
        mextension = aDecoder.decodeObject(forKey: "mextension") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        name = aDecoder.decodeObject(forKey: "name") as? String
        playTime = aDecoder.decodeObject(forKey: "playTime") as? Int
        size = aDecoder.decodeObject(forKey: "size") as? Int
        sr = aDecoder.decodeObject(forKey: "sr") as? Int
        volumeDelta = aDecoder.decodeObject(forKey: "volumeDelta") as? Float
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if bitrate != nil{
            aCoder.encode(bitrate, forKey: "bitrate")
        }
        if dfsId != nil{
            aCoder.encode(dfsId, forKey: "dfsId")
        }
        if mextension != nil{
            aCoder.encode(mextension, forKey: "mextension")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if playTime != nil{
            aCoder.encode(playTime, forKey: "playTime")
        }
        if size != nil{
            aCoder.encode(size, forKey: "size")
        }
        if sr != nil{
            aCoder.encode(sr, forKey: "sr")
        }
        if volumeDelta != nil{
            aCoder.encode(volumeDelta, forKey: "volumeDelta")
        }
        
    }
    
}
//
//	Album.swift
//
//	Create by 政达 李 on 11/9/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class Album : NSObject, NSCoding{
    
    var alias : [AnyObject]!
    var artist : Artist!
    var artists : [Artist]!
    var blurPicUrl : String!
    var briefDesc : String!
    var commentThreadId : String!
    var company : String!
    var companyId : Int!
    var copyrightId : Int!
    var descriptionField : String!
    var id : Int!
    var name : String!
    var onSale : Bool!
    var paid : Bool!
    var pic : Int!
    var picId : Int!
    var picUrl : String!
    var publishTime : Int!
    var size : Int!
    var songs : [AnyObject]!
    var status : Int!
    var tags : String!
    var type : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: NSDictionary){
        alias = dictionary["alias"] as? [AnyObject]
        if let artistData = dictionary["artist"] as? NSDictionary{
            artist = Artist(fromDictionary: artistData)
        }
        artists = [Artist]()
        if let artistsArray = dictionary["artists"] as? [NSDictionary]{
            for dic in artistsArray{
                let value = Artist(fromDictionary: dic)
                artists.append(value)
            }
        }
        blurPicUrl = dictionary["blurPicUrl"] as? String
        briefDesc = dictionary["briefDesc"] as? String
        commentThreadId = dictionary["commentThreadId"] as? String
        company = dictionary["company"] as? String
        companyId = dictionary["companyId"] as? Int
        copyrightId = dictionary["copyrightId"] as? Int
        descriptionField = dictionary["description"] as? String
        id = dictionary["id"] as? Int
        name = dictionary["name"] as? String
        onSale = dictionary["onSale"] as? Bool
        paid = dictionary["paid"] as? Bool
        pic = dictionary["pic"] as? Int
        picId = dictionary["picId"] as? Int
        picUrl = dictionary["picUrl"] as? String
        publishTime = dictionary["publishTime"] as? Int
        size = dictionary["size"] as? Int
        songs = dictionary["songs"] as? [AnyObject]
        status = dictionary["status"] as? Int
        tags = dictionary["tags"] as? String
        type = dictionary["type"] as? String
    }
    
    /**
     * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> NSDictionary
    {
        let dictionary = NSMutableDictionary()
        if alias != nil{
            dictionary["alias"] = alias
        }
        if artist != nil{
            dictionary["artist"] = artist.toDictionary()
        }
        if artists != nil{
            var dictionaryElements = [NSDictionary]()
            for artistsElement in artists {
                dictionaryElements.append(artistsElement.toDictionary())
            }
            dictionary["artists"] = dictionaryElements
        }
        if blurPicUrl != nil{
            dictionary["blurPicUrl"] = blurPicUrl
        }
        if briefDesc != nil{
            dictionary["briefDesc"] = briefDesc
        }
        if commentThreadId != nil{
            dictionary["commentThreadId"] = commentThreadId
        }
        if company != nil{
            dictionary["company"] = company
        }
        if companyId != nil{
            dictionary["companyId"] = companyId
        }
        if copyrightId != nil{
            dictionary["copyrightId"] = copyrightId
        }
        if descriptionField != nil{
            dictionary["description"] = descriptionField
        }
        if id != nil{
            dictionary["id"] = id
        }
        if name != nil{
            dictionary["name"] = name
        }
        if onSale != nil{
            dictionary["onSale"] = onSale
        }
        if paid != nil{
            dictionary["paid"] = paid
        }
        if pic != nil{
            dictionary["pic"] = pic
        }
        if picId != nil{
            dictionary["picId"] = picId
        }
        if picUrl != nil{
            dictionary["picUrl"] = picUrl
        }
        if publishTime != nil{
            dictionary["publishTime"] = publishTime
        }
        if size != nil{
            dictionary["size"] = size
        }
        if songs != nil{
            dictionary["songs"] = songs
        }
        if status != nil{
            dictionary["status"] = status
        }
        if tags != nil{
            dictionary["tags"] = tags
        }
        if type != nil{
            dictionary["type"] = type
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        alias = aDecoder.decodeObject(forKey: "alias") as? [AnyObject]
        artist = aDecoder.decodeObject(forKey: "artist") as? Artist
        artists = aDecoder.decodeObject(forKey: "artists") as? [Artist]
        blurPicUrl = aDecoder.decodeObject(forKey: "blurPicUrl") as? String
        briefDesc = aDecoder.decodeObject(forKey: "briefDesc") as? String
        commentThreadId = aDecoder.decodeObject(forKey: "commentThreadId") as? String
        company = aDecoder.decodeObject(forKey: "company") as? String
        companyId = aDecoder.decodeObject(forKey: "companyId") as? Int
        copyrightId = aDecoder.decodeObject(forKey: "copyrightId") as? Int
        descriptionField = aDecoder.decodeObject(forKey: "description") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        name = aDecoder.decodeObject(forKey: "name") as? String
        onSale = aDecoder.decodeObject(forKey: "onSale") as? Bool
        paid = aDecoder.decodeObject(forKey: "paid") as? Bool
        pic = aDecoder.decodeObject(forKey: "pic") as? Int
        picId = aDecoder.decodeObject(forKey: "picId") as? Int
        picUrl = aDecoder.decodeObject(forKey: "picUrl") as? String
        publishTime = aDecoder.decodeObject(forKey: "publishTime") as? Int
        size = aDecoder.decodeObject(forKey: "size") as? Int
        songs = aDecoder.decodeObject(forKey: "songs") as? [AnyObject]
        status = aDecoder.decodeObject(forKey: "status") as? Int
        tags = aDecoder.decodeObject(forKey: "tags") as? String
        type = aDecoder.decodeObject(forKey: "type") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if alias != nil{
            aCoder.encode(alias, forKey: "alias")
        }
        if artist != nil{
            aCoder.encode(artist, forKey: "artist")
        }
        if artists != nil{
            aCoder.encode(artists, forKey: "artists")
        }
        if blurPicUrl != nil{
            aCoder.encode(blurPicUrl, forKey: "blurPicUrl")
        }
        if briefDesc != nil{
            aCoder.encode(briefDesc, forKey: "briefDesc")
        }
        if commentThreadId != nil{
            aCoder.encode(commentThreadId, forKey: "commentThreadId")
        }
        if company != nil{
            aCoder.encode(company, forKey: "company")
        }
        if companyId != nil{
            aCoder.encode(companyId, forKey: "companyId")
        }
        if copyrightId != nil{
            aCoder.encode(copyrightId, forKey: "copyrightId")
        }
        if descriptionField != nil{
            aCoder.encode(descriptionField, forKey: "description")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if onSale != nil{
            aCoder.encode(onSale, forKey: "onSale")
        }
        if paid != nil{
            aCoder.encode(paid, forKey: "paid")
        }
        if pic != nil{
            aCoder.encode(pic, forKey: "pic")
        }
        if picId != nil{
            aCoder.encode(picId, forKey: "picId")
        }
        if picUrl != nil{
            aCoder.encode(picUrl, forKey: "picUrl")
        }
        if publishTime != nil{
            aCoder.encode(publishTime, forKey: "publishTime")
        }
        if size != nil{
            aCoder.encode(size, forKey: "size")
        }
        if songs != nil{
            aCoder.encode(songs, forKey: "songs")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
        if tags != nil{
            aCoder.encode(tags, forKey: "tags")
        }
        if type != nil{
            aCoder.encode(type, forKey: "type")
        }
        
    }
    
}
//
//	Artist.swift
//
//	Create by 政达 李 on 11/9/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class Artist : NSObject, NSCoding{
    
    var albumSize : Int!
    var alias : [AnyObject]!
    var briefDesc : String!
    var id : Int!
    var img1v1Id : Int!
    var img1v1Url : String!
    var musicSize : Int!
    var name : String!
    var picId : Int!
    var picUrl : String!
    var trans : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: NSDictionary){
        albumSize = dictionary["albumSize"] as? Int
        alias = dictionary["alias"] as? [AnyObject]
        briefDesc = dictionary["briefDesc"] as? String
        id = dictionary["id"] as? Int
        img1v1Id = dictionary["img1v1Id"] as? Int
        img1v1Url = dictionary["img1v1Url"] as? String
        musicSize = dictionary["musicSize"] as? Int
        name = dictionary["name"] as? String
        picId = dictionary["picId"] as? Int
        picUrl = dictionary["picUrl"] as? String
        trans = dictionary["trans"] as? String
    }
    
    /**
     * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> NSDictionary
    {
        let dictionary = NSMutableDictionary()
        if albumSize != nil{
            dictionary["albumSize"] = albumSize
        }
        if alias != nil{
            dictionary["alias"] = alias
        }
        if briefDesc != nil{
            dictionary["briefDesc"] = briefDesc
        }
        if id != nil{
            dictionary["id"] = id
        }
        if img1v1Id != nil{
            dictionary["img1v1Id"] = img1v1Id
        }
        if img1v1Url != nil{
            dictionary["img1v1Url"] = img1v1Url
        }
        if musicSize != nil{
            dictionary["musicSize"] = musicSize
        }
        if name != nil{
            dictionary["name"] = name
        }
        if picId != nil{
            dictionary["picId"] = picId
        }
        if picUrl != nil{
            dictionary["picUrl"] = picUrl
        }
        if trans != nil{
            dictionary["trans"] = trans
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        albumSize = aDecoder.decodeObject(forKey: "albumSize") as? Int
        alias = aDecoder.decodeObject(forKey: "alias") as? [AnyObject]
        briefDesc = aDecoder.decodeObject(forKey: "briefDesc") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        img1v1Id = aDecoder.decodeObject(forKey: "img1v1Id") as? Int
        img1v1Url = aDecoder.decodeObject(forKey: "img1v1Url") as? String
        musicSize = aDecoder.decodeObject(forKey: "musicSize") as? Int
        name = aDecoder.decodeObject(forKey: "name") as? String
        picId = aDecoder.decodeObject(forKey: "picId") as? Int
        picUrl = aDecoder.decodeObject(forKey: "picUrl") as? String
        trans = aDecoder.decodeObject(forKey: "trans") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if albumSize != nil{
            aCoder.encode(albumSize, forKey: "albumSize")
        }
        if alias != nil{
            aCoder.encode(alias, forKey: "alias")
        }
        if briefDesc != nil{
            aCoder.encode(briefDesc, forKey: "briefDesc")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if img1v1Id != nil{
            aCoder.encode(img1v1Id, forKey: "img1v1Id")
        }
        if img1v1Url != nil{
            aCoder.encode(img1v1Url, forKey: "img1v1Url")
        }
        if musicSize != nil{
            aCoder.encode(musicSize, forKey: "musicSize")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if picId != nil{
            aCoder.encode(picId, forKey: "picId")
        }
        if picUrl != nil{
            aCoder.encode(picUrl, forKey: "picUrl")
        }
        if trans != nil{
            aCoder.encode(trans, forKey: "trans")
        }
        
    }
    
}

//
//	Creator.swift
//
//	Create by 政达 李 on 11/9/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class Creator : NSObject, NSCoding{
    
    var accountStatus : Int!
    var authStatus : Int!
    var authority : Int!
    var avatarImgId : Int!
    var avatarUrl : String!
    var backgroundImgId : Int!
    var backgroundUrl : String!
    var birthday : Int!
    var city : Int!
    var defaultAvatar : Bool!
    var descriptionField : String!
    var detailDescription : String!
    var djStatus : Int!
    var expertTags : [String]!
    var followed : Bool!
    var gender : Int!
    var mutual : Bool!
    var nickname : String!
    var province : Int!
    var remarkName : AnyObject?
    var signature : String!
    var userId : Int!
    var userType : Int!
    var vipType : Int!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: NSDictionary){
        accountStatus = dictionary["accountStatus"] as? Int
        authStatus = dictionary["authStatus"] as? Int
        authority = dictionary["authority"] as? Int
        avatarImgId = dictionary["avatarImgId"] as? Int
        avatarUrl = dictionary["avatarUrl"] as? String
        backgroundImgId = dictionary["backgroundImgId"] as? Int
        backgroundUrl = dictionary["backgroundUrl"] as? String
        birthday = dictionary["birthday"] as? Int
        city = dictionary["city"] as? Int
        defaultAvatar = dictionary["defaultAvatar"] as? Bool
        descriptionField = dictionary["description"] as? String
        detailDescription = dictionary["detailDescription"] as? String
        djStatus = dictionary["djStatus"] as? Int
        expertTags = dictionary["expertTags"] as? [String]
        followed = dictionary["followed"] as? Bool
        gender = dictionary["gender"] as? Int
        mutual = dictionary["mutual"] as? Bool
        nickname = dictionary["nickname"] as? String
        province = dictionary["province"] as? Int
        remarkName = dictionary["remarkName"] as? AnyObject
        signature = dictionary["signature"] as? String
        userId = dictionary["userId"] as? Int
        userType = dictionary["userType"] as? Int
        vipType = dictionary["vipType"] as? Int
    }
    
    /**
     * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> NSDictionary
    {
        let dictionary = NSMutableDictionary()
        if accountStatus != nil{
            dictionary["accountStatus"] = accountStatus
        }
        if authStatus != nil{
            dictionary["authStatus"] = authStatus
        }
        if authority != nil{
            dictionary["authority"] = authority
        }
        if avatarImgId != nil{
            dictionary["avatarImgId"] = avatarImgId
        }
        if avatarUrl != nil{
            dictionary["avatarUrl"] = avatarUrl
        }
        if backgroundImgId != nil{
            dictionary["backgroundImgId"] = backgroundImgId
        }
        if backgroundUrl != nil{
            dictionary["backgroundUrl"] = backgroundUrl
        }
        if birthday != nil{
            dictionary["birthday"] = birthday
        }
        if city != nil{
            dictionary["city"] = city
        }
        if defaultAvatar != nil{
            dictionary["defaultAvatar"] = defaultAvatar
        }
        if descriptionField != nil{
            dictionary["description"] = descriptionField
        }
        if detailDescription != nil{
            dictionary["detailDescription"] = detailDescription
        }
        if djStatus != nil{
            dictionary["djStatus"] = djStatus
        }
        if expertTags != nil{
            dictionary["expertTags"] = expertTags
        }
        if followed != nil{
            dictionary["followed"] = followed
        }
        if gender != nil{
            dictionary["gender"] = gender
        }
        if mutual != nil{
            dictionary["mutual"] = mutual
        }
        if nickname != nil{
            dictionary["nickname"] = nickname
        }
        if province != nil{
            dictionary["province"] = province
        }
        if remarkName != nil{
            dictionary["remarkName"] = remarkName
        }
        if signature != nil{
            dictionary["signature"] = signature
        }
        if userId != nil{
            dictionary["userId"] = userId
        }
        if userType != nil{
            dictionary["userType"] = userType
        }
        if vipType != nil{
            dictionary["vipType"] = vipType
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        accountStatus = aDecoder.decodeObject(forKey: "accountStatus") as? Int
        authStatus = aDecoder.decodeObject(forKey: "authStatus") as? Int
        authority = aDecoder.decodeObject(forKey: "authority") as? Int
        avatarImgId = aDecoder.decodeObject(forKey: "avatarImgId") as? Int
        avatarUrl = aDecoder.decodeObject(forKey: "avatarUrl") as? String
        backgroundImgId = aDecoder.decodeObject(forKey: "backgroundImgId") as? Int
        backgroundUrl = aDecoder.decodeObject(forKey: "backgroundUrl") as? String
        birthday = aDecoder.decodeObject(forKey: "birthday") as? Int
        city = aDecoder.decodeObject(forKey: "city") as? Int
        defaultAvatar = aDecoder.decodeObject(forKey: "defaultAvatar") as? Bool
        descriptionField = aDecoder.decodeObject(forKey: "description") as? String
        detailDescription = aDecoder.decodeObject(forKey: "detailDescription") as? String
        djStatus = aDecoder.decodeObject(forKey: "djStatus") as? Int
        expertTags = aDecoder.decodeObject(forKey: "expertTags") as? [String]
        followed = aDecoder.decodeObject(forKey: "followed") as? Bool
        gender = aDecoder.decodeObject(forKey: "gender") as? Int
        mutual = aDecoder.decodeObject(forKey: "mutual") as? Bool
        nickname = aDecoder.decodeObject(forKey: "nickname") as? String
        province = aDecoder.decodeObject(forKey: "province") as? Int
        remarkName = aDecoder.decodeObject(forKey: "remarkName") as AnyObject?
        signature = aDecoder.decodeObject(forKey: "signature") as? String
        userId = aDecoder.decodeObject(forKey: "userId") as? Int
        userType = aDecoder.decodeObject(forKey: "userType") as? Int
        vipType = aDecoder.decodeObject(forKey: "vipType") as? Int
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if accountStatus != nil{
            aCoder.encode(accountStatus, forKey: "accountStatus")
        }
        if authStatus != nil{
            aCoder.encode(authStatus, forKey: "authStatus")
        }
        if authority != nil{
            aCoder.encode(authority, forKey: "authority")
        }
        if avatarImgId != nil{
            aCoder.encode(avatarImgId, forKey: "avatarImgId")
        }
        if avatarUrl != nil{
            aCoder.encode(avatarUrl, forKey: "avatarUrl")
        }
        if backgroundImgId != nil{
            aCoder.encode(backgroundImgId, forKey: "backgroundImgId")
        }
        if backgroundUrl != nil{
            aCoder.encode(backgroundUrl, forKey: "backgroundUrl")
        }
        if birthday != nil{
            aCoder.encode(birthday, forKey: "birthday")
        }
        if city != nil{
            aCoder.encode(city, forKey: "city")
        }
        if defaultAvatar != nil{
            aCoder.encode(defaultAvatar, forKey: "defaultAvatar")
        }
        if descriptionField != nil{
            aCoder.encode(descriptionField, forKey: "description")
        }
        if detailDescription != nil{
            aCoder.encode(detailDescription, forKey: "detailDescription")
        }
        if djStatus != nil{
            aCoder.encode(djStatus, forKey: "djStatus")
        }
        if expertTags != nil{
            aCoder.encode(expertTags, forKey: "expertTags")
        }
        if followed != nil{
            aCoder.encode(followed, forKey: "followed")
        }
        if gender != nil{
            aCoder.encode(gender, forKey: "gender")
        }
        if mutual != nil{
            aCoder.encode(mutual, forKey: "mutual")
        }
        if nickname != nil{
            aCoder.encode(nickname, forKey: "nickname")
        }
        if province != nil{
            aCoder.encode(province, forKey: "province")
        }
        if remarkName != nil{
            aCoder.encode(remarkName, forKey: "remarkName")
        }
        if signature != nil{
            aCoder.encode(signature, forKey: "signature")
        }
        if userId != nil{
            aCoder.encode(userId, forKey: "userId")
        }
        if userType != nil{
            aCoder.encode(userType, forKey: "userType")
        }
        if vipType != nil{
            aCoder.encode(vipType, forKey: "vipType")
        }
        
    }
    
}
