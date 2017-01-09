//
//  Array+Extension.swift
//  NetEaseCloudMusic
//
//  Created by Dan.Lee on 2017/1/9.
//  Copyright © 2017年 Ampire_Dan. All rights reserved.
//

import Foundation

extension Array where Element: Equatable, Element: Hashable {
    var unique: [Element] {
        return Array(Set<Element>(self))
    }
}
