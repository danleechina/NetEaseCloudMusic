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
    static let shareInstance = DatabaseManager()
    fileprivate override init() {}
    
    var currentUsedID: Int?
    
    func newUserLogin(data : String?) -> Int? {
        guard let rdata = data else { return nil }
        guard let dict = rdata.jsonDict else  { return nil }
        if dict["code"] as? Int == 200 {
            guard let accountData = dict["account"] as? Dictionary<String, Any> else { return nil }
            guard let profileData = dict["profile"] as? Dictionary<String, Any> else { return nil }
            guard let accountID = accountData["id"] as? Int else { return nil }
            
            var mutableData = dict
            mutableData["userID"] = accountID
            let realm = try! Realm()
            try! realm.write {
                realm.create(AccountData.self, value: mutableData, update: true)
            }
            
            let allAccounts = realm.objects(AccountData.self)
            try! realm.write {
                for account in allAccounts {
                    account.isCurrentUser = account.userID == accountID
                }
                currentUsedID = accountID
            }
        }
        return currentUsedID
    }
    
    func storeLoginData(data: Dictionary<String, Any>) {
        let realm = try! Realm()
        try! realm.write {
            realm.create(LoginData.self, value: data, update: true)
        }
    }
    
    func getCurrentUserLoginData() -> LoginData? {
        guard let cuID = currentUsedID else {
            return nil
        }
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
    func storeActivityData(data: Dictionary<String, Any>) {
        var mutableData = data
        mutableData["userID"] = currentUsedID
        let realm = try! Realm()
        try! realm.write {
            realm.create(Activity.self, value: mutableData, update: true)
        }
    }
    
    // 存储 ’关注‘ 数据
    func storeFollowsData(data: Dictionary<String, Any>) {
        var mutableData = data
        mutableData["userID"] = currentUsedID
        let realm = try! Realm()
        try! realm.write {
            realm.create(FollowsData.self, value: mutableData, update: true)
        }
    }
    
    // 存储 ’粉丝‘ 数据
    func storeFollowedData(data: Dictionary<String, Any>) {
        var mutableData = data
        mutableData["userID"] = currentUsedID
        let realm = try! Realm()
        try! realm.write {
            realm.create(FollowedData.self, value: mutableData, update: true)
        }
    }
}
