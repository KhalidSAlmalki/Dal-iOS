//
//  workerModel.swift
//  Dal
//
//  Created by khalid almalki on 4/4/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import UIKit
class workerModel {
    
    var id:String
    var name:String
    var contactNumber:String
    var description:String
    var avatar:String
    var location:[Double]
    
    init(id:String,contactNumber:String) {
        self.id = id
        self.contactNumber = contactNumber
        self.name = ""
        self.description = ""
        self.avatar = ""
        self.location = []
    }
    
    convenience init(id:String,contactNumber:String,name:String,description:String,avatar:String,location:[Double]) {
        self.init(id: id, contactNumber: contactNumber)
    }
    
}

