//
//  workerModel.swift
//  Dal
//
//  Created by khalid almalki on 4/4/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import UIKit
class workerModel:NSObject {
    
    var id:String
    var sectionID:[String]
    var name:String
    var contactNumber:String
    var desc:String
    var avatar:String
    var location:[Double]
    
    override convenience init() {
        self.init(id: "", contactNumber: "")
    }
    init(id:String,contactNumber:String) {
        self.id = id
        self.contactNumber = contactNumber
        self.name = ""
        self.desc = ""
        self.avatar = ""
        self.location = []
        self.sectionID = []
    }
    
    convenience init(id:String,sectionID:[String],contactNumber:String,name:String,description:String,avatar:String,location:[Double]) {
        self.init(id: id, contactNumber: contactNumber)
        
        self.name = name
        self.desc = description
        self.avatar = avatar
        self.location = location
        self.sectionID = sectionID
    }
    
}

