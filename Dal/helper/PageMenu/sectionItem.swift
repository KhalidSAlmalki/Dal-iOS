//
//  sectionItem.swift
//  Dal
//
//  Created by khalid almalki on 4/3/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import UIKit
import Parchment

struct sectionItem: PagingItem, Hashable, Comparable {
    var title: String
    var logoURL: String
    var id :String
    var sort :Int
    init(title: String,logoURL:String,id:String,sort:Int) {
        self.title = title
        self.logoURL = logoURL
        self.id = id
        self.sort = sort
        
    }
    
    var hashValue: Int {
        return id.hashValue&+title.hashValue&+logoURL.hashValue
    }
    
    static func ==(lhs: sectionItem, rhs: sectionItem) -> Bool {
        return lhs.id == rhs.id && lhs.title == rhs.title && lhs.logoURL == rhs.logoURL
    }
    
    static func <(lhs: sectionItem, rhs: sectionItem) -> Bool {
        return lhs.sort < rhs.sort
    }
}


