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
    var events = List<Event>()
    var lasttime : Int = 0
    var more : Bool = false
    var size : Int = 0
    var userID : Int = 0
    
    override static func primaryKey() -> String? {
        return "userID"
    }
}

class Event : Object {
    
    var actId : Int = 0
    var actName : String?
    var eventTime : Int = 0
    var expireTime : Int = 0
    var forwardCount : Int = 0
    var id : Int = 0
    var info : Info?
    var json : String = ""
    var pics : [AnyObject] = []
    var rcmdInfo : Any?
    var showTime : Int = 0
    var tmplId : Int = 0
    var type : Int = 0
    var user : User?
    var uuid : Any?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class User : Object {
    
    var accountStatus : Int = 0
    var authStatus : Int = 0
    var authority : Int = 0
    var avatarImgId : Int = 0
    var avatarImgIdStr : String = ""
    var avatarUrl : String = ""
    var backgroundImgId : Int = 0
    var backgroundImgIdStr : String = ""
    var backgroundUrl : String = ""
    var birthday : Int = 0
    var city : Int = 0
    var defaultAvatar : Bool = false
    var descriptionField : String = ""
    var detailDescription : String = ""
    var djStatus : Int = 0
    var expertTags : Any?
    var followed : Bool = false
    var gender : Int = 0
    var mutual : Bool = false
    var nickname : String = ""
    var province : Int = 0
    var remarkName : Any?
    var signature : String = ""
    var urlAnalyze : Bool = false
    var userId : Int = 0
    var userType : Int = 0
    var vipType : Int = 0
}

class Info : Object {
    
    var commentCount : Int = 0
    var comments : Any?
    var latestLikedUsers : Any?
    var liked : Bool = false
    var likedCount : Int = 0
    var resourceId : Int = 0
    var resourceType : Int = 0
    var shareCount : Int = 0
    var threadId : String = ""

}
