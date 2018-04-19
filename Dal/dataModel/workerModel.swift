//
//  workerModel.swift
//  Dal
//
//  Created by khalid almalki on 4/4/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import UIKit
enum Role {
    case worker
    case user
}
class workerModel:NSObject, NSCoding{

    var id:String
    var skillIDs:[String]
    var name:String
    var contactNumber:String
    var desc:String
    var avatar:String
    var location:[Double]
    var status:String = ""
    
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
        self.skillIDs = []
    }
    
    convenience init(id:String,sectionID:[String],contactNumber:String,name:String,description:String,avatar:String,location:[Double],status:String) {
        self.init(id: id, contactNumber: contactNumber)
        
        self.name = name
        self.desc = description
        self.avatar = avatar
        self.location = location
        self.skillIDs = sectionID
        self.status = status
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(contactNumber, forKey: "contactNumber")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(desc, forKey: "desc")
        aCoder.encode(avatar, forKey: "avatar")
        aCoder.encode(location, forKey: "location")
        aCoder.encode(skillIDs, forKey: "skillIDs")
        aCoder.encode(status, forKey: "status")

    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "id") as! String
        let contactNumber = aDecoder.decodeObject(forKey: "contactNumber") as! String
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let desc = aDecoder.decodeObject(forKey: "desc") as! String
        let avatar = aDecoder.decodeObject(forKey: "avatar") as! String
        let location = aDecoder.decodeObject(forKey: "location") as! [Double]
        let skillIDs = aDecoder.decodeObject(forKey: "skillIDs") as! [String]
        let status = aDecoder.decodeObject(forKey: "status") as! String

        
        self.init(id: id, sectionID: skillIDs, contactNumber: contactNumber, name: name, description: desc, avatar: avatar, location: location,status:status)
    }
    
    
    
    
    func getRole() -> Role {
        if skillIDs == [] {
            return .user
        }
        return .worker
    }
    
}

