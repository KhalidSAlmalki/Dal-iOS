//
//  sectionModel.swift
//  Dal
//
//  Created by khalid almalki on 4/4/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import Foundation
import CoreLocation
import Parchment
class sectionModel:NSObject  {

    
    override var description: String{
        return " name : \(name) "

//        return "id : \(id) \n name : \(name) \n avatar : \(avatar) \n  sort: \(sort)\n"
    }
    
    var id:String
    var name:String
    var avatar:String
    var sort:Int
    var workers:[workerModel]
    var SectionItem:sectionItem

    init(id:String,name:String,avatar:String,sort:Int) {
        self.id = id
        self.name = name
        self.avatar = avatar
        self.sort = sort
        self.workers = []
        self.SectionItem = sectionItem(title: self.name , logoURL:  self.avatar , id:   self.id, sort: self.sort)
      }
    
    func add(worker:workerModel!)  {
        
        guard worker != nil else {
            return
        }
        workers.append(worker)
    }
    
   
}
