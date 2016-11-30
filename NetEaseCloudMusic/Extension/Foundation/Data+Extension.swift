//
//  Data+Extension.swift
//  NetEaseCloudMusic
//
//  Created by Dan.Lee on 2016/11/30.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import Foundation

extension Data {
    static func generateRandomBytes(length :Int) -> Data? {
        
        var keyData = Data(count: length)
        let result = keyData.withUnsafeMutableBytes {
            SecRandomCopyBytes(kSecRandomDefault, keyData.count, $0)
        }
        if result == errSecSuccess {
            return keyData
        } else {
            return nil
        }
    }
    
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}
