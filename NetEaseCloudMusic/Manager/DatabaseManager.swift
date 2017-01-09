//
//  DatabaseManager.swift
//  NetEaseCloudMusic
//
//  Created by Dan.Lee on 2016/12/7.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import Foundation
import RealmSwift

class DatabaseManager : NSObject {
    typealias ResponseData = Dictionary<String, Any>
    static let shareInstance = DatabaseManager.init()
    fileprivate override init() {
    }
    
    var currentUsedID: Int? {
        get {
            let realm = try! Realm()
            let result = realm.objects(AccountData.self).filter("isCurrentUser == true")
            if result.count == 1 {
                return result[0].userID
            }
            return nil
        }
    }
    
    func newUserLogin(data : String?) -> Int? {
        guard let rdata = data else { return nil }
        guard let dict = rdata.jsonDict else  { return nil }
        if dict["code"] as? Int == 200 {
            guard let accountData = dict["account"] as? ResponseData else { return nil }
            guard let _ = dict["profile"] as? ResponseData else { return nil }
            guard let accountID = accountData["id"] as? Int else { return nil }
            
            var mutableData = dict
            mutableData["userID"] = accountID
            let realm = try! Realm()
            do {
                try realm.write {
                    realm.create(AccountData.self, value: mutableData, update: true)
                }
            } catch let err as NSError {
                print(err)
            }
            
            let allAccounts = realm.objects(AccountData.self)
            do {
                try realm.write {
                    for account in allAccounts {
                        account.isCurrentUser = account.userID == accountID
                    }
                }
            } catch let err as NSError {
                print(err)
            }
        }
        return currentUsedID
    }
    
    func logout() -> Bool {
        guard let cuID = currentUsedID else { return true }
        let realm = try! Realm()
        if let accoutData = realm.object(ofType: AccountData.self, forPrimaryKey: cuID) {
            try! realm.write {
                accoutData.isCurrentUser = false
            }
        }
        return true
    }
    
    func storeLoginData(data: ResponseData) {
        let realm = try! Realm()
        try! realm.write {
            realm.create(LoginData.self, value: data, update: true)
        }
    }
    
    func getCurrentUserLoginData() -> LoginData? {
        guard let cuID = currentUsedID else { return nil }
        let realm = try! Realm()
        let loginDatas = realm.objects(LoginData.self)
        for data in loginDatas {
            if data.userID == cuID {
                return data
            }
        }
        return nil
    }
    
    // 存储 ’动态‘ 数据
    func storeActivityData(data: ResponseData) {
        guard let usedID = currentUsedID else { return }
        let realm = try! Realm()
        var mutableData = data
        mutableData["userID"] = usedID
        try! realm.write {
            realm.create(Activity.self, value: mutableData, update: true)
        }
    }
    
    // 存储 ’关注‘ 数据
    func storeFollowsData(data: ResponseData) {
        guard let usedID = currentUsedID else { return }
        let realm = try! Realm()
        var mutableData = data
        mutableData["userID"] = usedID
        try! realm.write {
            realm.create(FollowsData.self, value: mutableData, update: true)
        }
    }
    
    // 存储 ’粉丝‘ 数据
    func storeFollowedData(data: ResponseData) {
        guard let usedID = currentUsedID else { return }
        let realm = try! Realm()
        var mutableData = data
        mutableData["userID"] = usedID
        try! realm.write {
            realm.create(FollowedData.self, value: mutableData, update: true)
        }
    }
    
    // 储存 level 数据
    func storeLevelData(data: ResponseData) {
        guard let usedID = currentUsedID else { return }
        let realm = try! Realm()
        var mutableData = data
        mutableData["userId"] = usedID
        try! realm.write {
            realm.create(Level.self, value: mutableData, update: true)
        }
    }
    
    // 存储 用户歌单 数据 
    func storeUserPlayList(data: ResponseData) {
        guard let usedID = currentUsedID else { return }
        let realm = try! Realm()
        var mutableData = data
        mutableData["userId"] = usedID
        try! realm.write {
            realm.create(PlayListData.self, value: mutableData, update: true)
        }
    }
    
    // 获取歌单数据
    func getPlayListData(playListID: Int) -> PlayList? {
        let realm = try! Realm()
        let data = realm.objects(PlayList.self)
        for item in data {
            if item.id == playListID {
                return item
            }
        }
        return nil
    }
    
    // 存储歌单数据
    func storePlayList(data: ResponseData) {
        let realm = try! Realm()
        try! realm.write {
            realm.create(PlayList.self, value: data, update: true)
        }
    }
}
