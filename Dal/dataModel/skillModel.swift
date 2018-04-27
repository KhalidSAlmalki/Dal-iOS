//
//  skillModel.swift
//  Dal
//
//  Created by khalid almalki on 4/9/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import UIKit
class skillModel:NSObject  {
    
    
    override var description: String{
        return " name : \(name) "
        
        //        return "id : \(id) \n name : \(name) \n avatar : \(avatar) \n  sort: \(sort)\n"
    }
    
    var id:String
    var name:String
    var sort:Int
    
    override convenience init() {
        self.init(id: "", name: "", sort: 0)
    }
    convenience init(snapshot: [String:AnyObject]) {

        let snapshotValue = snapshot
        self.init(id: convertString(snapshotValue["id"]), name: convertString(snapshotValue["name"]), sort: convertInt(snapshotValue["sort"]))

        

    }
    init(id:String,name:String,sort:Int) {
        self.id = id
        self.name = name
        self.sort = sort
    }
    
    
    
    
}


