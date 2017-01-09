//
//  Song.swift
//  NetEaseCloudMusic
//
//  Created by Dan.Lee on 2017/1/9.
//  Copyright © 2017年 Ampire_Dan. All rights reserved.
//

import Foundation
import RealmSwift


class Track : Object {
    
    dynamic var album: Album?
    //    dynamic var alias: List?
    var artists = List<Artist>()
    //    dynamic var audition: AnyObject?
    dynamic var bMusic: BHMLMusic?
    dynamic var commentThreadId: String?
    dynamic var copyFrom: String?
    dynamic var copyright: Int = 0
    dynamic var copyrightId: Int = 0
    //    dynamic var crbt: AnyObject?
    dynamic var dayPlays: Int = 0
    dynamic var disc: String?
    dynamic var duration: Int = 0
    dynamic var fee: Int = 0
    dynamic var ftype: Int = 0
    dynamic var hMusic: BHMLMusic?
    dynamic var hearTime: Int = 0
    dynamic var id: Int = 0
    dynamic var lMusic: BHMLMusic?
    dynamic var mMusic: BHMLMusic?
    dynamic var mp3Url: String?
    dynamic var mvid: Int = 0
    dynamic var name: String?
    dynamic var no: Int = 0
    dynamic var playedNum: Int = 0
    dynamic var popularity: Float = 0.0
    dynamic var position: Int = 0
    //    dynamic var ringtone: AnyObject?
    //    dynamic var rtUrl: AnyObject?
    //    dynamic var rtUrls: [String]()
    dynamic var rtype: Int = 0
    //    dynamic var rurl: AnyObject?
    dynamic var score: Int = 0
    dynamic var starred: Bool = false
    dynamic var starredNum: Int = 0
    dynamic var status: Int = 0
    //    dynamic var transNames: List?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}


class Creator : Object {
    
    dynamic var accountStatus : Int = 0
    dynamic var authStatus : Int = 0
    dynamic var authority : Int = 0
    dynamic var avatarImgId : Int = 0
    dynamic var avatarUrl : String?
    dynamic var backgroundImgId : Int = 0
    dynamic var backgroundUrl : String?
    dynamic var birthday : Int = 0
    dynamic var city : Int = 0
    dynamic var defaultAvatar : Bool = false
    dynamic var descriptionField : String?
    dynamic var detailDescription : String?
    dynamic var djStatus : Int = 0
    //    dynamic var expertTags = [String]()
    dynamic var followed : Bool = false
    dynamic var gender : Int = 0
    dynamic var mutual : Bool = false
    dynamic var nickname : String?
    dynamic var province : Int = 0
    //    dynamic var remarkName : AnyObject?
    dynamic var signature : String?
    dynamic var userId : Int = 0
    dynamic var userType : Int = 0
    dynamic var vipType : Int = 0
    
    override static func primaryKey() -> String? {
        return "userId"
    }
}
class BHMLMusic: Object {
        dynamic var bitrate: Int = 0
    dynamic var dfsId: Int = 0
    dynamic var dfsIdStr: String?
//    dynamic var extension: String?
    dynamic var id: Int = 0
//    dynamic var name: AnyObject?
    dynamic var playTime: Int = 0
    dynamic var size: Int = 0
    dynamic var sr: Int = 0
    dynamic var volumeDelta: Float = 0.0
    override static func primaryKey() -> String? {
        return "id"
    }
}

class Album: Object {
    
//    dynamic var alias: List?
//    dynamic var artist: Artist?
//    dynamic var artists: List?
    dynamic var blurPicUrl: String?
    dynamic var briefDesc: String?
    dynamic var commentThreadId: String?
    dynamic var company: String?
    dynamic var companyId: Int = 0
    dynamic var copyrightId: Int = 0
    dynamic var descriptionField: String?
    dynamic var id: Int = 0
    dynamic var name: String?
    dynamic var pic: Int = 0
    dynamic var picId: Int = 0
    dynamic var picIdStr: String?
    dynamic var picUrl: String?
    dynamic var publishTime: Int = 0
    dynamic var size: Int = 0
//    dynamic var songs: List?
    dynamic var status: Int = 0
    dynamic var tags: String?
//    dynamic var transNames: List?
    dynamic var type: String?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class Artist: Object {
    
//    dynamic var album: Album?
    dynamic var albumSize: Int = 0
//    dynamic var alias: List?
    dynamic var briefDesc: String?
    dynamic var id: Int = 0
    dynamic var img1v1Id: Int = 0
    dynamic var img1v1Url: String?
    dynamic var musicSize: Int = 0
    dynamic var name: String?
    dynamic var picId: Int = 0
    dynamic var picUrl: String?
    dynamic var trans: String?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
