//
//  PlayList.swift
//  NetEaseCloudMusic
//
//  Created by Dan.Lee on 2016/12/11.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import Foundation
import RealmSwift

class PlayListData: Object {
    dynamic var userId: Int = 0
    dynamic var more: Bool = false
    let  playlist = List<PlayList>()
    
    override static func primaryKey() -> String? {
        return "userId"
    }
}

class PlayList: Object {
    
    let belongTo = LinkingObjects(fromType: PlayListData.self, property: "playlist")
    
//    dynamic var subscribers [],
    dynamic var subscribed: Bool = false
//    dynamic var artists:  null,
//    dynamic var tracks:  null,
//    dynamic var tags:  [],
    dynamic var privacy: Int = 0
    dynamic var specialType: Int = 5
    dynamic var newImported: Bool = false
    dynamic var highQuality: Bool = false
    dynamic var trackUpdateTime: TimeInterval = 0
    dynamic var trackCount: Int = 198
    dynamic var updateTime: TimeInterval = 0
    dynamic var commentThreadId:  String?
    dynamic var userId:  Int = 0
    dynamic var playCount:  Int = 0
    dynamic var createTime:  TimeInterval = 0
    dynamic var coverImgId:  Int64 = 0
//    dynamic var totalDuration:  0
    dynamic var coverImgUrl: String?
//    dynamic var description: String?
    dynamic var status: Int = 0
    dynamic var cloudTrackCount: Int = 0
    dynamic var subscribedCount: Int = 0
    dynamic var adType:  Int = 0
    dynamic var trackNumberUpdateTime:  TimeInterval = 0
    dynamic var name: String?
    dynamic var id: Int = 0
    dynamic var creator: PlayListCreator?
    
    override static func primaryKey() -> String? {
        return "id"
    }

}

class PlayListCreator: Object {
        dynamic var signature: String?
        dynamic var authority: Int = 0
        dynamic var defaultAvatar: Bool = false
        dynamic var avatarImgId: Int64 = 0
        dynamic var province: Int = 0
        dynamic var authStatus: Int = 0
        dynamic var followed: Bool = false
        dynamic var avatarUrl: String?
        dynamic var accountStatus: Int = 0
        dynamic var gender: Int = 0
        dynamic var city: Int = 0
        dynamic var birthday: TimeInterval = 0
        dynamic var userId: Int = 0
        dynamic var userType: Int = 0
        dynamic var nickname: String?
//        dynamic var description: String?
        dynamic var detailDescription: String?
        dynamic var backgroundImgId: Int64 = 0
        dynamic var backgroundUrl: String?
        dynamic var mutual: Bool = false
//        dynamic var expertTags: null
        dynamic var djStatus: Int = 0
        dynamic var vipType: Int = 0
//        dynamic var remarkName: null
    
    override static func primaryKey() -> String? {
        return "userId"
    }
}

//{
//"more": false,
//"playlist": [{
//"subscribers": [],
//"subscribed": false,
//"artists": null,
//"tracks": null,
//"tags": [],
//"privacy": 0,
//"specialType": 5,
//"newImported": false,
//"highQuality": false,
//"trackUpdateTime": 1481422104155,
//"trackCount": 198,
//"updateTime": 1481371182221,
//"commentThreadId": "A_PL_0_40432105",
//"userId": 45785021,
//"playCount": 2056,
//"createTime": 1418048974709,
//"coverImgId": 3415083117101572,
//"totalDuration": 0,
//"coverImgUrl": "http://p3.music.126.net/X_J2vhoCEtZjBkhfGccc_A==/3415083117101572.jpg",
//"description": null,
//"status": 0,
//"cloudTrackCount": 0,
//"subscribedCount": 0,
//"adType": 0,
//"trackNumberUpdateTime": 1481371182221,
//"name": "Ampire_dan喜欢的音乐",
//"id": 40432105,
//    
//    "creator": {
//    "signature": "",
//    "authority": 0,
//    "defaultAvatar": false,
//    "avatarImgId": 3265549549177155,
//    "province": 320000,
//    "authStatus": 0,
//    "followed": false,
//    "avatarUrl": "http://p4.music.126.net/vId3dTFxMc6bdMxAJZzdVg==/3265549549177155.jpg",
//    "accountStatus": 0,
//    "gender": 1,
//    "city": 320100,
//    "birthday": 631123200000,
//    "userId": 45785021,
//    "userType": 0,
//    "nickname": "Ampire_dan",
//    "description": "",
//    "detailDescription": "",
//    "backgroundImgId": 2002210674180200,
//    "backgroundUrl": "http://p1.music.126.net/45Nu4EqvFqK_kQj6BkPwcw==/2002210674180200.jpg",
//    "mutual": false,
//    "expertTags": null,
//    "djStatus": 0,
//    "vipType": 0,
//    "remarkName": null
//    },
//}],
//"code": 200
//}
