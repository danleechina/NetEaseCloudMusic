//
//  Follow.swift
//  NetEaseCloudMusic
//
//  Created by Dan.Lee on 2016/12/8.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import Foundation
import RealmSwift

class FollowsData: Object {
    
    dynamic var code: Int = 0
    let follow = List<Follow>()
    dynamic var more: Bool = false
    dynamic var touchCount: Int = 0
    dynamic var userID : Int = 0
    
    override static func primaryKey() -> String? {
        return "userID"
    }
    
}

// The one I follow
class Follow: Object {
    let belongTo = LinkingObjects(fromType: FollowsData.self, property: "follow")
    
    dynamic var accountStatus: Int = 0
    dynamic var authStatus: Int = 0
    dynamic var avatarUrl: String?
    dynamic var blacklist: Bool = false
    dynamic var eventCount: Int = 0
//    dynamic var expertTags: AnyObject?
    dynamic var followed: Bool = true
    dynamic var followeds: Int = 0
    dynamic var follows: Int = 0
    dynamic var gender: Int = 0
    dynamic var mutual: Bool = false
    dynamic var nickname: String?
    dynamic var playlistCount: Int = 0
    dynamic var py: String?
//    dynamic var remarkName: AnyObject?
    dynamic var signature: String?
    dynamic var time: TimeInterval = 0
    dynamic var userId: Int = 0
    dynamic var userType: Int = 0
    dynamic var vipType: Int = 0
    
}

class FollowedData: Object {
    
    dynamic var code: Int = 0
    let followeds = List<Followed>()
    dynamic var more: Bool = false
    dynamic var newCount: Int = 0
    dynamic var userID : Int = 0
    
    override static func primaryKey() -> String? {
        return "userID"
    }
    
}

// who follow me
class Followed: Object {
    let belongTo = LinkingObjects(fromType: FollowedData.self, property: "followeds")
    
    dynamic var accountStatus: Int = 0
    dynamic var authStatus: Int = 0
    dynamic var avatarUrl: String?
    dynamic var eventCount: Int = 0
//    dynamic var expertTags: AnyObject?
    dynamic var followed: Bool = true
    dynamic var followeds: Int = 0
    dynamic var follows: Int = 0
    dynamic var gender: Int = 0
    dynamic var mutual: Bool = false
    dynamic var nickname: String?
    dynamic var playlistCount: Int = 0
    dynamic var py: String?
//    dynamic var remarkName: AnyObject?
    dynamic var signature: String?
    dynamic var time: TimeInterval = 0
    dynamic var userId: Int = 0
    dynamic var userType: Int = 0
    dynamic var vipType: Int = 0
}
