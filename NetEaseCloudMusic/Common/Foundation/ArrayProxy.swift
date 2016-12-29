//
//  ArrayProxy.swift
//  NetEaseCloudMusic
//
//  Created by Dan.Lee on 2016/12/29.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import Foundation

struct ArrayProxyNotification<T> {
    var type: Notification.Name?
    var element: T?
}

// when you add observor, be sure to set the object that post the notification （which is the ArrayProxy instance you want to observe)
struct ArrayProxy<T> {
    fileprivate var array: [T] = []
    
    
    mutating func append(newElement: T) {
        NotificationCenter.default.post(name: .ArrayProxyWillAddSomeThing, object: newElement)
        
        self.array.append(newElement)
        
        NotificationCenter.default.post(name: .ArrayProxyDidAddSomeThing, object: nil)
    }
    
    mutating func remove(at index: Int) {
        NotificationCenter.default.post(name: .ArrayProxyWillRemoveSomeThing, object: index)
        let element = self.array.remove(at: index)
        NotificationCenter.default.post(name: .ArrayProxyDidRemoveSomeThing, object: element)
    }
    
    subscript(index: Int) -> T {
        set {
            self.array[index] = newValue
        }
        get {
            return self.array[index]
        }
    }
    
}

extension ArrayProxy {
    var count: Int {
        get {
            return array.count
        }
    }
}

extension Notification.Name {
    static let ArrayProxyDidAddSomeThing = Notification.Name("ArrayProxyDidAddSomeThing")
    static let ArrayProxyWillAddSomeThing = Notification.Name("ArrayProxyWillAddSomeThing")
    
    static let ArrayProxyDidRemoveSomeThing = Notification.Name("ArrayProxyDidRemoveSomeThing")
    static let ArrayProxyWillRemoveSomeThing = Notification.Name("ArrayProxyWillRemoveSomeThing")
}
