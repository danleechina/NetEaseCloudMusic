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
    
    class func getFilePath(id: Int) -> NSURL? {
        if let dir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .AllDomainsMask, true).first {
            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent("CertainSongSheet+\(id)")
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
                let data = try! NSString(contentsOfURL: getFilePath(Int(playListID)!)!, encoding: NSUTF8StringEncoding)
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
                    if let tranData = transfer(nndata) {
                        completion(data: tranData, error: nil)
                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "CertainSongSheetCache+\(tranData.id)" )
                        NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: "CertainSongSheetTime+\(tranData.id)")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        do {
                            try nndata.writeToURL(getFilePath(tranData.id)!, atomically: false, encoding: NSUTF8StringEncoding)
                        } catch let error as NSError {
                            print(error)
                        }
                    }
                }
            }
        }
    }
    
    class func transfer(data: String?) -> CertainSongSheet? {
        var certainSongSheet:CertainSongSheet?
        do {
            let dict = try NSJSONSerialization.JSONObjectWithData((data?.dataUsingEncoding(NSUTF8StringEncoding))!, options: []) as? [String:AnyObject]
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
        artists = dictionary["artists"]
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
        var dictionary = NSMutableDictionary()
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
        adType = aDecoder.decodeObjectForKey("adType") as? Int
        artists = aDecoder.decodeObjectForKey("artists")
        cloudTrackCount = aDecoder.decodeObjectForKey("cloudTrackCount") as? Int
        commentCount = aDecoder.decodeObjectForKey("commentCount") as? Int
        commentThreadId = aDecoder.decodeObjectForKey("commentThreadId") as? String
        coverImgId = aDecoder.decodeObjectForKey("coverImgId") as? Int
        coverImgUrl = aDecoder.decodeObjectForKey("coverImgUrl") as? String
        createTime = aDecoder.decodeObjectForKey("createTime") as? Int
        creator = aDecoder.decodeObjectForKey("creator") as? Creator
        descriptionField = aDecoder.decodeObjectForKey("description") as? String
        highQuality = aDecoder.decodeObjectForKey("highQuality") as? Bool
        id = aDecoder.decodeObjectForKey("id") as? Int
        name = aDecoder.decodeObjectForKey("name") as? String
        newImported = aDecoder.decodeObjectForKey("newImported") as? Bool
        playCount = aDecoder.decodeObjectForKey("playCount") as? Int
        shareCount = aDecoder.decodeObjectForKey("shareCount") as? Int
        specialType = aDecoder.decodeObjectForKey("specialType") as? Int
        status = aDecoder.decodeObjectForKey("status") as? Int
        subscribed = aDecoder.decodeObjectForKey("subscribed") as? Bool
        subscribedCount = aDecoder.decodeObjectForKey("subscribedCount") as? Int
        subscribers = aDecoder.decodeObjectForKey("subscribers") as? [AnyObject]
        tags = aDecoder.decodeObjectForKey("tags") as? [String]
        totalDuration = aDecoder.decodeObjectForKey("totalDuration") as? Int
        trackCount = aDecoder.decodeObjectForKey("trackCount") as? Int
        trackNumberUpdateTime = aDecoder.decodeObjectForKey("trackNumberUpdateTime") as? Int
        trackUpdateTime = aDecoder.decodeObjectForKey("trackUpdateTime") as? Int
        tracks = aDecoder.decodeObjectForKey("tracks") as? [Track]
        updateTime = aDecoder.decodeObjectForKey("updateTime") as? Int
        userId = aDecoder.decodeObjectForKey("userId") as? Int
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encodeWithCoder(aCoder: NSCoder)
    {
        if adType != nil{
            aCoder.encodeObject(adType, forKey: "adType")
        }
        if artists != nil{
            aCoder.encodeObject(artists, forKey: "artists")
        }
        if cloudTrackCount != nil{
            aCoder.encodeObject(cloudTrackCount, forKey: "cloudTrackCount")
        }
        if commentCount != nil{
            aCoder.encodeObject(commentCount, forKey: "commentCount")
        }
        if commentThreadId != nil{
            aCoder.encodeObject(commentThreadId, forKey: "commentThreadId")
        }
        if coverImgId != nil{
            aCoder.encodeObject(coverImgId, forKey: "coverImgId")
        }
        if coverImgUrl != nil{
            aCoder.encodeObject(coverImgUrl, forKey: "coverImgUrl")
        }
        if createTime != nil{
            aCoder.encodeObject(createTime, forKey: "createTime")
        }
        if creator != nil{
            aCoder.encodeObject(creator, forKey: "creator")
        }
        if descriptionField != nil{
            aCoder.encodeObject(descriptionField, forKey: "description")
        }
        if highQuality != nil{
            aCoder.encodeObject(highQuality, forKey: "highQuality")
        }
        if id != nil{
            aCoder.encodeObject(id, forKey: "id")
        }
        if name != nil{
            aCoder.encodeObject(name, forKey: "name")
        }
        if newImported != nil{
            aCoder.encodeObject(newImported, forKey: "newImported")
        }
        if playCount != nil{
            aCoder.encodeObject(playCount, forKey: "playCount")
        }
        if shareCount != nil{
            aCoder.encodeObject(shareCount, forKey: "shareCount")
        }
        if specialType != nil{
            aCoder.encodeObject(specialType, forKey: "specialType")
        }
        if status != nil{
            aCoder.encodeObject(status, forKey: "status")
        }
        if subscribed != nil{
            aCoder.encodeObject(subscribed, forKey: "subscribed")
        }
        if subscribedCount != nil{
            aCoder.encodeObject(subscribedCount, forKey: "subscribedCount")
        }
        if subscribers != nil{
            aCoder.encodeObject(subscribers, forKey: "subscribers")
        }
        if tags != nil{
            aCoder.encodeObject(tags, forKey: "tags")
        }
        if totalDuration != nil{
            aCoder.encodeObject(totalDuration, forKey: "totalDuration")
        }
        if trackCount != nil{
            aCoder.encodeObject(trackCount, forKey: "trackCount")
        }
        if trackNumberUpdateTime != nil{
            aCoder.encodeObject(trackNumberUpdateTime, forKey: "trackNumberUpdateTime")
        }
        if trackUpdateTime != nil{
            aCoder.encodeObject(trackUpdateTime, forKey: "trackUpdateTime")
        }
        if tracks != nil{
            aCoder.encodeObject(tracks, forKey: "tracks")
        }
        if updateTime != nil{
            aCoder.encodeObject(updateTime, forKey: "updateTime")
        }
        if userId != nil{
            aCoder.encodeObject(userId, forKey: "userId")
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
        audition = dictionary["audition"]
        if let bMusicData = dictionary["bMusic"] as? NSDictionary{
            bMusic = BMusic(fromDictionary: bMusicData)
        }
        commentThreadId = dictionary["commentThreadId"] as? String
        copyFrom = dictionary["copyFrom"] as? String
        copyrightId = dictionary["copyrightId"] as? Int
        crbt = dictionary["crbt"]
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
        rtUrl = dictionary["rtUrl"]
        rtUrls = dictionary["rtUrls"]
        rtype = dictionary["rtype"] as? Int
        rurl = dictionary["rurl"]
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
        var dictionary = NSMutableDictionary()
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
        album = aDecoder.decodeObjectForKey("album") as? Album
        alias = aDecoder.decodeObjectForKey("alias") as? [AnyObject]
        artists = aDecoder.decodeObjectForKey("artists") as? [Artist]
        audition = aDecoder.decodeObjectForKey("audition")
        bMusic = aDecoder.decodeObjectForKey("bMusic") as? BMusic
        commentThreadId = aDecoder.decodeObjectForKey("commentThreadId") as? String
        copyFrom = aDecoder.decodeObjectForKey("copyFrom") as? String
        copyrightId = aDecoder.decodeObjectForKey("copyrightId") as? Int
        crbt = aDecoder.decodeObjectForKey("crbt")
        dayPlays = aDecoder.decodeObjectForKey("dayPlays") as? Int
        disc = aDecoder.decodeObjectForKey("disc") as? String
        duration = aDecoder.decodeObjectForKey("duration") as? Int
        fee = aDecoder.decodeObjectForKey("fee") as? Int
        ftype = aDecoder.decodeObjectForKey("ftype") as? Int
        hMusic = aDecoder.decodeObjectForKey("hMusic") as? BMusic
        hearTime = aDecoder.decodeObjectForKey("hearTime") as? Int
        id = aDecoder.decodeObjectForKey("id") as? Int
        lMusic = aDecoder.decodeObjectForKey("lMusic") as? BMusic
        mMusic = aDecoder.decodeObjectForKey("mMusic") as? BMusic
        mp3Url = aDecoder.decodeObjectForKey("mp3Url") as? String
        mvid = aDecoder.decodeObjectForKey("mvid") as? Int
        name = aDecoder.decodeObjectForKey("name") as? String
        no = aDecoder.decodeObjectForKey("no") as? Int
        playedNum = aDecoder.decodeObjectForKey("playedNum") as? Int
        popularity = aDecoder.decodeObjectForKey("popularity") as? Float
        position = aDecoder.decodeObjectForKey("position") as? Int
        ringtone = aDecoder.decodeObjectForKey("ringtone") as? String
        rtUrl = aDecoder.decodeObjectForKey("rtUrl")
        rtUrls = aDecoder.decodeObjectForKey("rtUrls")
        rtype = aDecoder.decodeObjectForKey("rtype") as? Int
        rurl = aDecoder.decodeObjectForKey("rurl")
        score = aDecoder.decodeObjectForKey("score") as? Int
        starred = aDecoder.decodeObjectForKey("starred") as? Bool
        starredNum = aDecoder.decodeObjectForKey("starredNum") as? Int
        status = aDecoder.decodeObjectForKey("status") as? Int
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encodeWithCoder(aCoder: NSCoder)
    {
        if album != nil{
            aCoder.encodeObject(album, forKey: "album")
        }
        if alias != nil{
            aCoder.encodeObject(alias, forKey: "alias")
        }
        if artists != nil{
            aCoder.encodeObject(artists, forKey: "artists")
        }
        if audition != nil{
            aCoder.encodeObject(audition, forKey: "audition")
        }
        if bMusic != nil{
            aCoder.encodeObject(bMusic, forKey: "bMusic")
        }
        if commentThreadId != nil{
            aCoder.encodeObject(commentThreadId, forKey: "commentThreadId")
        }
        if copyFrom != nil{
            aCoder.encodeObject(copyFrom, forKey: "copyFrom")
        }
        if copyrightId != nil{
            aCoder.encodeObject(copyrightId, forKey: "copyrightId")
        }
        if crbt != nil{
            aCoder.encodeObject(crbt, forKey: "crbt")
        }
        if dayPlays != nil{
            aCoder.encodeObject(dayPlays, forKey: "dayPlays")
        }
        if disc != nil{
            aCoder.encodeObject(disc, forKey: "disc")
        }
        if duration != nil{
            aCoder.encodeObject(duration, forKey: "duration")
        }
        if fee != nil{
            aCoder.encodeObject(fee, forKey: "fee")
        }
        if ftype != nil{
            aCoder.encodeObject(ftype, forKey: "ftype")
        }
        if hMusic != nil{
            aCoder.encodeObject(hMusic, forKey: "hMusic")
        }
        if hearTime != nil{
            aCoder.encodeObject(hearTime, forKey: "hearTime")
        }
        if id != nil{
            aCoder.encodeObject(id, forKey: "id")
        }
        if lMusic != nil{
            aCoder.encodeObject(lMusic, forKey: "lMusic")
        }
        if mMusic != nil{
            aCoder.encodeObject(mMusic, forKey: "mMusic")
        }
        if mp3Url != nil{
            aCoder.encodeObject(mp3Url, forKey: "mp3Url")
        }
        if mvid != nil{
            aCoder.encodeObject(mvid, forKey: "mvid")
        }
        if name != nil{
            aCoder.encodeObject(name, forKey: "name")
        }
        if no != nil{
            aCoder.encodeObject(no, forKey: "no")
        }
        if playedNum != nil{
            aCoder.encodeObject(playedNum, forKey: "playedNum")
        }
        if popularity != nil{
            aCoder.encodeObject(popularity, forKey: "popularity")
        }
        if position != nil{
            aCoder.encodeObject(position, forKey: "position")
        }
        if ringtone != nil{
            aCoder.encodeObject(ringtone, forKey: "ringtone")
        }
        if rtUrl != nil{
            aCoder.encodeObject(rtUrl, forKey: "rtUrl")
        }
        if rtUrls != nil{
            aCoder.encodeObject(rtUrls, forKey: "rtUrls")
        }
        if rtype != nil{
            aCoder.encodeObject(rtype, forKey: "rtype")
        }
        if rurl != nil{
            aCoder.encodeObject(rurl, forKey: "rurl")
        }
        if score != nil{
            aCoder.encodeObject(score, forKey: "score")
        }
        if starred != nil{
            aCoder.encodeObject(starred, forKey: "starred")
        }
        if starredNum != nil{
            aCoder.encodeObject(starredNum, forKey: "starredNum")
        }
        if status != nil{
            aCoder.encodeObject(status, forKey: "status")
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
        var dictionary = NSMutableDictionary()
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
        bitrate = aDecoder.decodeObjectForKey("bitrate") as? Int
        dfsId = aDecoder.decodeObjectForKey("dfsId") as? Int
        mextension = aDecoder.decodeObjectForKey("mextension") as? String
        id = aDecoder.decodeObjectForKey("id") as? Int
        name = aDecoder.decodeObjectForKey("name") as? String
        playTime = aDecoder.decodeObjectForKey("playTime") as? Int
        size = aDecoder.decodeObjectForKey("size") as? Int
        sr = aDecoder.decodeObjectForKey("sr") as? Int
        volumeDelta = aDecoder.decodeObjectForKey("volumeDelta") as? Float
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encodeWithCoder(aCoder: NSCoder)
    {
        if bitrate != nil{
            aCoder.encodeObject(bitrate, forKey: "bitrate")
        }
        if dfsId != nil{
            aCoder.encodeObject(dfsId, forKey: "dfsId")
        }
        if mextension != nil{
            aCoder.encodeObject(mextension, forKey: "mextension")
        }
        if id != nil{
            aCoder.encodeObject(id, forKey: "id")
        }
        if name != nil{
            aCoder.encodeObject(name, forKey: "name")
        }
        if playTime != nil{
            aCoder.encodeObject(playTime, forKey: "playTime")
        }
        if size != nil{
            aCoder.encodeObject(size, forKey: "size")
        }
        if sr != nil{
            aCoder.encodeObject(sr, forKey: "sr")
        }
        if volumeDelta != nil{
            aCoder.encodeObject(volumeDelta, forKey: "volumeDelta")
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
        var dictionary = NSMutableDictionary()
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
        alias = aDecoder.decodeObjectForKey("alias") as? [AnyObject]
        artist = aDecoder.decodeObjectForKey("artist") as? Artist
        artists = aDecoder.decodeObjectForKey("artists") as? [Artist]
        blurPicUrl = aDecoder.decodeObjectForKey("blurPicUrl") as? String
        briefDesc = aDecoder.decodeObjectForKey("briefDesc") as? String
        commentThreadId = aDecoder.decodeObjectForKey("commentThreadId") as? String
        company = aDecoder.decodeObjectForKey("company") as? String
        companyId = aDecoder.decodeObjectForKey("companyId") as? Int
        copyrightId = aDecoder.decodeObjectForKey("copyrightId") as? Int
        descriptionField = aDecoder.decodeObjectForKey("description") as? String
        id = aDecoder.decodeObjectForKey("id") as? Int
        name = aDecoder.decodeObjectForKey("name") as? String
        onSale = aDecoder.decodeObjectForKey("onSale") as? Bool
        paid = aDecoder.decodeObjectForKey("paid") as? Bool
        pic = aDecoder.decodeObjectForKey("pic") as? Int
        picId = aDecoder.decodeObjectForKey("picId") as? Int
        picUrl = aDecoder.decodeObjectForKey("picUrl") as? String
        publishTime = aDecoder.decodeObjectForKey("publishTime") as? Int
        size = aDecoder.decodeObjectForKey("size") as? Int
        songs = aDecoder.decodeObjectForKey("songs") as? [AnyObject]
        status = aDecoder.decodeObjectForKey("status") as? Int
        tags = aDecoder.decodeObjectForKey("tags") as? String
        type = aDecoder.decodeObjectForKey("type") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encodeWithCoder(aCoder: NSCoder)
    {
        if alias != nil{
            aCoder.encodeObject(alias, forKey: "alias")
        }
        if artist != nil{
            aCoder.encodeObject(artist, forKey: "artist")
        }
        if artists != nil{
            aCoder.encodeObject(artists, forKey: "artists")
        }
        if blurPicUrl != nil{
            aCoder.encodeObject(blurPicUrl, forKey: "blurPicUrl")
        }
        if briefDesc != nil{
            aCoder.encodeObject(briefDesc, forKey: "briefDesc")
        }
        if commentThreadId != nil{
            aCoder.encodeObject(commentThreadId, forKey: "commentThreadId")
        }
        if company != nil{
            aCoder.encodeObject(company, forKey: "company")
        }
        if companyId != nil{
            aCoder.encodeObject(companyId, forKey: "companyId")
        }
        if copyrightId != nil{
            aCoder.encodeObject(copyrightId, forKey: "copyrightId")
        }
        if descriptionField != nil{
            aCoder.encodeObject(descriptionField, forKey: "description")
        }
        if id != nil{
            aCoder.encodeObject(id, forKey: "id")
        }
        if name != nil{
            aCoder.encodeObject(name, forKey: "name")
        }
        if onSale != nil{
            aCoder.encodeObject(onSale, forKey: "onSale")
        }
        if paid != nil{
            aCoder.encodeObject(paid, forKey: "paid")
        }
        if pic != nil{
            aCoder.encodeObject(pic, forKey: "pic")
        }
        if picId != nil{
            aCoder.encodeObject(picId, forKey: "picId")
        }
        if picUrl != nil{
            aCoder.encodeObject(picUrl, forKey: "picUrl")
        }
        if publishTime != nil{
            aCoder.encodeObject(publishTime, forKey: "publishTime")
        }
        if size != nil{
            aCoder.encodeObject(size, forKey: "size")
        }
        if songs != nil{
            aCoder.encodeObject(songs, forKey: "songs")
        }
        if status != nil{
            aCoder.encodeObject(status, forKey: "status")
        }
        if tags != nil{
            aCoder.encodeObject(tags, forKey: "tags")
        }
        if type != nil{
            aCoder.encodeObject(type, forKey: "type")
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
        var dictionary = NSMutableDictionary()
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
        albumSize = aDecoder.decodeObjectForKey("albumSize") as? Int
        alias = aDecoder.decodeObjectForKey("alias") as? [AnyObject]
        briefDesc = aDecoder.decodeObjectForKey("briefDesc") as? String
        id = aDecoder.decodeObjectForKey("id") as? Int
        img1v1Id = aDecoder.decodeObjectForKey("img1v1Id") as? Int
        img1v1Url = aDecoder.decodeObjectForKey("img1v1Url") as? String
        musicSize = aDecoder.decodeObjectForKey("musicSize") as? Int
        name = aDecoder.decodeObjectForKey("name") as? String
        picId = aDecoder.decodeObjectForKey("picId") as? Int
        picUrl = aDecoder.decodeObjectForKey("picUrl") as? String
        trans = aDecoder.decodeObjectForKey("trans") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encodeWithCoder(aCoder: NSCoder)
    {
        if albumSize != nil{
            aCoder.encodeObject(albumSize, forKey: "albumSize")
        }
        if alias != nil{
            aCoder.encodeObject(alias, forKey: "alias")
        }
        if briefDesc != nil{
            aCoder.encodeObject(briefDesc, forKey: "briefDesc")
        }
        if id != nil{
            aCoder.encodeObject(id, forKey: "id")
        }
        if img1v1Id != nil{
            aCoder.encodeObject(img1v1Id, forKey: "img1v1Id")
        }
        if img1v1Url != nil{
            aCoder.encodeObject(img1v1Url, forKey: "img1v1Url")
        }
        if musicSize != nil{
            aCoder.encodeObject(musicSize, forKey: "musicSize")
        }
        if name != nil{
            aCoder.encodeObject(name, forKey: "name")
        }
        if picId != nil{
            aCoder.encodeObject(picId, forKey: "picId")
        }
        if picUrl != nil{
            aCoder.encodeObject(picUrl, forKey: "picUrl")
        }
        if trans != nil{
            aCoder.encodeObject(trans, forKey: "trans")
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
        remarkName = dictionary["remarkName"]
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
        var dictionary = NSMutableDictionary()
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
        accountStatus = aDecoder.decodeObjectForKey("accountStatus") as? Int
        authStatus = aDecoder.decodeObjectForKey("authStatus") as? Int
        authority = aDecoder.decodeObjectForKey("authority") as? Int
        avatarImgId = aDecoder.decodeObjectForKey("avatarImgId") as? Int
        avatarUrl = aDecoder.decodeObjectForKey("avatarUrl") as? String
        backgroundImgId = aDecoder.decodeObjectForKey("backgroundImgId") as? Int
        backgroundUrl = aDecoder.decodeObjectForKey("backgroundUrl") as? String
        birthday = aDecoder.decodeObjectForKey("birthday") as? Int
        city = aDecoder.decodeObjectForKey("city") as? Int
        defaultAvatar = aDecoder.decodeObjectForKey("defaultAvatar") as? Bool
        descriptionField = aDecoder.decodeObjectForKey("description") as? String
        detailDescription = aDecoder.decodeObjectForKey("detailDescription") as? String
        djStatus = aDecoder.decodeObjectForKey("djStatus") as? Int
        expertTags = aDecoder.decodeObjectForKey("expertTags") as? [String]
        followed = aDecoder.decodeObjectForKey("followed") as? Bool
        gender = aDecoder.decodeObjectForKey("gender") as? Int
        mutual = aDecoder.decodeObjectForKey("mutual") as? Bool
        nickname = aDecoder.decodeObjectForKey("nickname") as? String
        province = aDecoder.decodeObjectForKey("province") as? Int
        remarkName = aDecoder.decodeObjectForKey("remarkName")
        signature = aDecoder.decodeObjectForKey("signature") as? String
        userId = aDecoder.decodeObjectForKey("userId") as? Int
        userType = aDecoder.decodeObjectForKey("userType") as? Int
        vipType = aDecoder.decodeObjectForKey("vipType") as? Int
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encodeWithCoder(aCoder: NSCoder)
    {
        if accountStatus != nil{
            aCoder.encodeObject(accountStatus, forKey: "accountStatus")
        }
        if authStatus != nil{
            aCoder.encodeObject(authStatus, forKey: "authStatus")
        }
        if authority != nil{
            aCoder.encodeObject(authority, forKey: "authority")
        }
        if avatarImgId != nil{
            aCoder.encodeObject(avatarImgId, forKey: "avatarImgId")
        }
        if avatarUrl != nil{
            aCoder.encodeObject(avatarUrl, forKey: "avatarUrl")
        }
        if backgroundImgId != nil{
            aCoder.encodeObject(backgroundImgId, forKey: "backgroundImgId")
        }
        if backgroundUrl != nil{
            aCoder.encodeObject(backgroundUrl, forKey: "backgroundUrl")
        }
        if birthday != nil{
            aCoder.encodeObject(birthday, forKey: "birthday")
        }
        if city != nil{
            aCoder.encodeObject(city, forKey: "city")
        }
        if defaultAvatar != nil{
            aCoder.encodeObject(defaultAvatar, forKey: "defaultAvatar")
        }
        if descriptionField != nil{
            aCoder.encodeObject(descriptionField, forKey: "description")
        }
        if detailDescription != nil{
            aCoder.encodeObject(detailDescription, forKey: "detailDescription")
        }
        if djStatus != nil{
            aCoder.encodeObject(djStatus, forKey: "djStatus")
        }
        if expertTags != nil{
            aCoder.encodeObject(expertTags, forKey: "expertTags")
        }
        if followed != nil{
            aCoder.encodeObject(followed, forKey: "followed")
        }
        if gender != nil{
            aCoder.encodeObject(gender, forKey: "gender")
        }
        if mutual != nil{
            aCoder.encodeObject(mutual, forKey: "mutual")
        }
        if nickname != nil{
            aCoder.encodeObject(nickname, forKey: "nickname")
        }
        if province != nil{
            aCoder.encodeObject(province, forKey: "province")
        }
        if remarkName != nil{
            aCoder.encodeObject(remarkName, forKey: "remarkName")
        }
        if signature != nil{
            aCoder.encodeObject(signature, forKey: "signature")
        }
        if userId != nil{
            aCoder.encodeObject(userId, forKey: "userId")
        }
        if userType != nil{
            aCoder.encodeObject(userType, forKey: "userType")
        }
        if vipType != nil{
            aCoder.encodeObject(vipType, forKey: "vipType")
        }
        
    }
    
}
