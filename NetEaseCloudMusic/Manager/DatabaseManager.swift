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
        if dict["code"] as? String == "200" {
            guard let accountData = dict["account"] as? Dictionary<String, Any> else { return nil }
            guard let profileData = dict["profile"] as? Dictionary<String, Any> else { return nil }
            guard let accountID = accountData["id"] as? Int else { return nil }
            
            let realm = try! Realm()
            try! realm.write {
                realm.create(Account.self, value: accountData, update: true)
                realm.create(Profile.self, value: profileData, update: true)
            }
            
            let allAccounts = realm.objects(Account.self)
            try! realm.write {
                for account in allAccounts {
                    account.isCurrentUser = account.id == accountID
                }
                currentUsedID = accountID
            }
        }
        return currentUsedID
    }
    
    func storeLoginData(data: LoginData) {
        let realm = try! Realm()
        try! realm.write {
            realm.create(LoginData.self, value: data, update: true)
        }
    }
    
    func getCurrentUserLoginData() -> LoginData? {
        let realm = try! Realm()
        let loginDatas = realm.objects(LoginData.self)
        for data in loginDatas {
            if data.userID == currentUsedID {
                return data
            }
        }
        return nil
    }
}
