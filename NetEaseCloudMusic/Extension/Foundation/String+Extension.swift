//
//  String+Extension.swift
//  NetEaseCloudMusic
//
//  Created by Dan.Lee on 2016/11/30.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import Foundation


extension String {
    var jsonDict: Dictionary<String, Any>? {
        do {
            let dict = try JSONSerialization.jsonObject(with: (self.data(using: String.Encoding.utf8))!, options: []) as? [String:AnyObject]
            return dict
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
    
    func md5() -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        if let data = self.data(using: String.Encoding.utf8) {
            CC_MD5((data as NSData).bytes, CC_LONG(data.count), &digest)
        }
        
        var digestHex = ""
        for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }
        
        return digestHex
    }
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    static func generateRandomBytes(length :Int) -> String? {
        return Data.generateRandomBytes(length: length)?.base64EncodedString()
    }
    
    func zfill(minimunLength: Int) -> String {
        var ret = self
        if self.characters.count < minimunLength {
            for _ in 0 ..< minimunLength - self.characters.count {
                ret = "0" + ret
            }
        }
        return ret
    }
    
    func plusSymbolToPercent() -> String {
        return self.replacingOccurrences(of: "+", with: "%2B")
    }
    
    func isEmail() -> Bool {
        return true
    }
    
    func isPhone() -> Bool {
        return true
    }
    
    func trimSpace() -> String {
        return self
    }
}
