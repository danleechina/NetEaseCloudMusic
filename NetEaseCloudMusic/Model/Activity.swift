//
//  Activity.swift
//  NetEaseCloudMusic
//
//  Created by Dan.Lee on 2016/12/7.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import Foundation
import RealmSwift

class Activity : Object {
    let events = List<Event>()
    dynamic var lasttime : TimeInterval = 0
    dynamic var more : Bool = false
    dynamic var size : Int = 0
    dynamic var userID : Int = 0
    
    override static func primaryKey() -> String? {
        return "userID"
    }
}

class Event : Object {
    let belongTo = LinkingObjects(fromType: Activity.self, property: "events")
    
    dynamic var actId : Int = 0
    dynamic var actName : String?
    dynamic var eventTime : TimeInterval = 0
    dynamic var expireTime : TimeInterval = 0
    dynamic var forwardCount : Int = 0
    dynamic var id : Int = 0
    dynamic var info : Info?
    dynamic var json : String = ""
//    var pics : [AnyObject] = []
//    var rcmdInfo : Any?
    dynamic var showTime : TimeInterval = 0
    dynamic var tmplId : Int = 0
    dynamic var type : Int = 0
    dynamic var user : User?
//    var uuid : Any?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class User : Object {
    
    dynamic var accountStatus : Int = 0
    dynamic var authStatus : Int = 0
    dynamic var authority : Int = 0
    dynamic var avatarImgId : Int = 0
    dynamic var avatarImgIdStr : String = ""
    dynamic var avatarUrl : String = ""
    dynamic var backgroundImgId : Int = 0
    dynamic var backgroundImgIdStr : String = ""
    dynamic var backgroundUrl : String = ""
    dynamic var birthday : Int = 0
    dynamic var city : Int = 0
    dynamic var defaultAvatar : Bool = false
    dynamic var descriptionField : String = ""
    dynamic var detailDescription : String = ""
    dynamic var djStatus : Int = 0
//    var expertTags : Any?
    dynamic var followed : Bool = false
    dynamic var gender : Int = 0
    dynamic var mutual : Bool = false
    dynamic var nickname : String = ""
    dynamic var province : Int = 0
//    var remarkName : Any?
    dynamic var signature : String = ""
    dynamic var urlAnalyze : Bool = false
    dynamic var userId : Int = 0
    dynamic var userType : Int = 0
    dynamic var vipType : Int = 0
    
    override static func primaryKey() -> String? {
        return "userId"
    }
}

class Info : Object {
    
    dynamic var commentCount : Int = 0
//    var comments : Any?
//    var latestLikedUsers : Any?
    dynamic var liked : Bool = false
    dynamic var likedCount : Int = 0
    dynamic var resourceId : Int = 0
    dynamic var resourceType : Int = 0
    dynamic var shareCount : Int = 0
    dynamic var threadId : String = ""

}
