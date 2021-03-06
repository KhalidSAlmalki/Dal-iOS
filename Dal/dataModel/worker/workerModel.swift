//
//  workerModel.swift
//  Dal
//
//  Created by khalid almalki on 4/4/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import UIKit
import CoreLocation
enum Role {
    case worker
    case user
}
enum status {
    case active
    case busy
    case unknown
}
class workerModel:NSObject{

    var id:String
    var skillIDs:[String]
    var name:String
    var contactNumber:String
    var desc:String
    var avatar:String
    var status:status = .unknown
    var location = locationModel()
    var contactMethod:String = ""
    var distance:Float = -1
    
    override var description: String{
        return "\(id)  \(skillIDs)   \(name)  \(contactNumber) \(location)"
    }
    override convenience init() {
        self.init(id: "", contactNumber: "")
    }
    init(id:String,contactNumber:String) {
        self.id = id
        self.contactNumber = contactNumber
        self.name = ""
        self.desc = ""
        self.avatar = ""
        self.location = locationModel()
        self.skillIDs = []
    }
    
    convenience init(id:String,sectionID:[String],contactMethod:String,contactNumber:String,name:String,description:String,avatar:String,location:locationModel,status:status) {
        self.init(id: id, contactNumber: contactNumber)
        
        self.name = name
        self.desc = description
        self.avatar = avatar
        self.location = location
        self.skillIDs = sectionID
        self.status = status
        self.contactMethod = contactMethod
    }
 
    convenience init(data:[String:AnyObject]) {
        
        let skillsIDstring = convertString(data["skills"])
        let skillsID =  restAPI.shared.convertToAarry(skillsIDstring)
     
        var location_ = locationModel()
        if let location = data["location"] as? [String:AnyObject]{
            location_ = locationModel(location: CLLocationCoordinate2D(latitude: location["latitude"] as! CLLocationDegrees,
                                                                       longitude: location["longitude"] as! CLLocationDegrees),
                                      Range: convertFloat(location["range"]),
                                      zoom:  convertFloat(location["zoom"]))
        }
                        
        
        
        self.init(id: convertString(data["id"]),
                  sectionID: skillsID ,
                  contactMethod: convertString(data["contactMethod"]) ,
                  contactNumber: convertString(data["contactNumber"]),
                  name: convertString(data["name"]) ,
                  description: convertString(data["desc"]) ,
                  avatar:convertString(data["avatar"]),
                  location: location_,
                  status: convertWorkerStatus(data["status"]))
        
    }

    func getRates(completion:@escaping (Double)->Void){
        
        restAPI.shared.getRates(with: id) { (rateNumber) in
            completion(rateNumber)
        }
    }
    func getLocation() -> CLLocation {
        
        return CLLocation(latitude: location.location.latitude, longitude: location.location.longitude)
    }
    
    func getRole() -> Role {
        if skillIDs == [] {
            return .user
        }
        return .worker
    }
    
}

