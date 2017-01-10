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
    
    //    let belongTo = LinkingObjects(fromType: PlayListData.self, property: "playlist")
    class func loadSongSheetData(_ playListID: String, completion:@escaping (_ data: PlayList?, _ error: NSError?) -> Void) {
        guard let listID = Int(playListID) else {
            completion(nil, nil)
            return
        }
        if let result = DatabaseManager.shareInstance.getPlayListData(playListID: listID) {
            completion(result, nil)
            return
        }
        
        let netease = NetworkMusicApi.shareInstance
//        // 排行榜数据
//        if listID < 0 {
//            netease.rankSongList(index: -listID - 1, complete: { (dataString, error) in
//                if let jsonDict = dataString?.jsonDict {
//                    var formatData = [String:Any]()
//                    formatData["id"] = listID
//                    formatData["tracks"] = jsonDict["songs"]
//                    DatabaseManager.shareInstance.storePlayList(data: formatData)
//                    PlayList.loadSongSheetData(playListID, completion: completion)
//                } else {
//                    completion(nil, error)
//                }
//            })
//        } else {
            netease.playlist_detail(playListID) { (data, error) in
                if let err = error {
                    completion(nil, err)
                } else {
                    if let jsonDict = data?.jsonDict {
                        if jsonDict["code"] as! Int == 200 {
                            DatabaseManager.shareInstance.storePlayList(data: jsonDict["result"] as! DatabaseManager.ResponseData)
                            completion(DatabaseManager.shareInstance.getPlayListData(playListID: listID), nil)
                        }
                    } else {
                        completion(nil, nil)
                    }
                }
            }
//        }
    }
    
    dynamic var adType : Int = 0
    //    dynamic var artists : AnyObject?
    dynamic var cloudTrackCount : Int = 0
    dynamic var commentCount : Int = 0
    dynamic var commentThreadId : String?
    dynamic var coverImgId : Int = 0
    dynamic var coverImgUrl : String?
    dynamic var createTime : Int = 0
    dynamic var creator : Creator?
    dynamic var descriptionField : String?
    dynamic var highQuality : Bool = false
    dynamic var id : Int = 0
    dynamic var name : String?
    dynamic var newImported : Bool = false
    dynamic var playCount : Int = 0
    dynamic var shareCount : Int = 0
    dynamic var specialType : Int = 0
    dynamic var status : Int = 0
    dynamic var subscribed : Bool = false
    dynamic var subscribedCount : Int = 0
    //    dynamic var subscribers : [AnyObject]!
//    dynamic var tags = [String]()
    dynamic var totalDuration : Int = 0
    dynamic var trackCount : Int = 0
    dynamic var trackNumberUpdateTime : Int = 0
    dynamic var trackUpdateTime : Int = 0
    var tracks = List<Track>()
    dynamic var updateTime : Int = 0
    dynamic var userId : Int = 0
    
    override static func primaryKey() -> String? {
        return "id"
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
