//
//  restAPI.swift
//  Dal
//
//  Created by khalid almalki on 4/26/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation


class restAPI: NSObject {
    static let shared = restAPI()
    
    let WORKERCHILDNAME = "workers/worker"
    let SECTIONCHILDNAME = "sections"
    let RATESCHILDNAME = ""
    
    // obtain
    var sectionsBasedOnUserLocations = sectionsModel()
    
    // obtain all sections that exsit on firebase database
    var sections = sectionsModel()

    // setUP reference of database and storage
    lazy var storageRef = Storage.storage().reference()
    lazy var  ref = Database.database().reference()

    override init() {
        sectionsBasedOnUserLocations = sectionsModel()
        sections = sectionsModel()
    }
    // GET section  based on worker who coverage the rnage
    
    // get get workers based on sections
    
   //
    
    
    func convertToAarry(_ string:String) -> [String] {
        var strings:[String] = []
        let splitString = string.split(separator: ";")
        for aSubstring in splitString {
            
            strings.append(convertString(aSubstring as AnyObject))
        }
        return strings
    }
    
    
    func rate( with userID:String, whoRate:String, rating:Double,completion:@escaping (Any)->Void)  {
        
        restAPI.shared.ref.child("rates").child(userID).child(whoRate).setValue(["score":rating]) { (err, d) in
            completion(d)

         }
        
    
    }
    func updateStatus(userID:String, status:String, completion:@escaping (Any)->Void)  {
        ref.child("workers/worker").child(userID).updateChildValues(["status":status]) { (e, d) in
            
            completion(d)
        }
    }
    
    func getRates(with userID:String ,completion:@escaping (Double)->Void ) {
        
        var _rates:[Int] = []
        
        ref.child("rates").child(userID).queryOrdered(byChild: "score").observeSingleEvent(of: .value) { (rates) in
            
            if let val = rates.value as? [String:Any] {
                
                
                for r in val{
                    let _rate = r.value as! [String:AnyObject]
                    
                    _rates.append(convertInt(_rate["score"]))
                }
                
                let totalSum = _rates.map({$0}).reduce(0, +)
                guard totalSum != 0 , _rates.count != 0 else {
                    completion(-1)
                    return
                }
                completion(Double(totalSum/_rates.count))
                
            }
            
            
            
            
            
            
        }
    }
    func getWorkerDetail(usingPhoneNUmber:String,completion:@escaping (workerModel)->Void )  {
        getWorkerDetail(byChild: "contactNumber", value: usingPhoneNUmber) { (w) in
            completion(w)
        }
    }
    func getWorkerDetail(usingUserID:String,completion:@escaping (workerModel)->Void )  {
        getWorkerDetail(byChild: "id", value: usingUserID) { (w) in
            completion(w)
        }
    }
    func parseWorkerFirbaseValue(_ val: Any)->workerModel {
        if let _result = val as? [String:AnyObject]{
            let skillsIDstring = convertString(_result["skills"])
            let skillsID = self.convertToAarry(skillsIDstring)
            let worker = workerModel(id: convertString(_result["id"]),
                                     sectionID: skillsID ,
                                     contactMethod: convertString(_result["contactMethod"]) ,
                                     contactNumber: convertString(_result["contactNumber"]),
                                     name: convertString(_result["name"]) ,
                                     description: convertString(_result["desc"]) ,
                                     avatar:convertString(_result["avatar"]),
                                     location: locationModel(),
                                     status: convertWorkerStatus(_result["status"]))
            if let location = _result["location"] as? [String:Any]{
                
                let location_ = locationModel(location: CLLocationCoordinate2D(latitude: location["latitude"] as! CLLocationDegrees, longitude: location["longitude"] as! CLLocationDegrees),
                                              Range: location["range"] as! Float,
                                              zoom: location["zoom"] as! Float)
                worker.location = location_
                
                return worker
            }
            return worker
            
            
        }
        return workerModel()
    }
    
    func getWorkerDetail(byChild:String,value:String,completion:@escaping (workerModel)->Void )  {
        
        self.ref.child("workers").child("worker").queryOrdered(byChild: byChild).queryEqual(toValue: value).observeSingleEvent(of: .value) { (snap) in
            
            if let result = snap.value as? [String:Any]{
                result.forEach({ (key,val) in
                    let worker = self.parseWorkerFirbaseValue(val)
                    completion(worker)
                    
                    
                    
                })
            }else{
                completion(workerModel())
                
            }
        }
    }
    func extarctSkills(basedOnSectionID:String,completion:(([skillModel]?)->Void)?){
        self.ref.child("sections").child("\(basedOnSectionID)").observeSingleEvent(of: DataEventType.value, with: { (skill) in
            if let section = skill.value as? [String:AnyObject]{
                
                var skillsModels = [skillModel]()
                
                if let skills = section["skills"] as? [[String:AnyObject]]{
                    
                    for _skill in skills{
                        skillsModels.append(skillModel(snapshot: _skill))
                    }
                    
                    completion!(skillsModels)
                    
                }else{
                    completion!(nil)
                    
                }
                
                
            }else{
                completion!(nil)
                
            }
        })
        
        
    }
    func extractSection(bySkillID:String,completion:((sectionModel?)->Void)?){
        self.ref.child("sections").queryOrdered(byChild: "skills").observeSingleEvent(of: .value, with: { (lookingForSection) in
            
            if let value = lookingForSection.value as? [[String : AnyObject]]{
                
                for found in value{
                    
                    if let skills = found["skills"] as? [[String : AnyObject]]{
                        
                        if skills.contains(where: { (askill) -> Bool in
                            
                            if convertString(askill["id"]) == bySkillID{
                                return true
                            }
                            return false
                        }){
                            
                            completion!(sectionModel(id: convertString(found["id"]), name: convertString(found["name"]), avatar: convertString(found["avatar"]), sort: convertInt(found["sort"])))
                            
                        }else{
                            completion!(nil)
                        }
                        
                        
                    }
                }
                
            }else{
                
            }
            
        })
        
    }
    
    
    func getDistanceBetween(location1:CLLocation,location2:CLLocation) -> Float{
        
        return Float(location1.distance(from: location2) * 0.00062137)
    }
    func get(sectionWithLocation:CLLocation,completion:@escaping ([sectionModel])->Void ) {
        ref.child("workers/worker").observeSingleEvent(of: .value, with: { (snapshot) in
            let sEctions = sectionsModel()
            
            for aworker in snapshot.children {
                let snap = aworker as! DataSnapshot
                let value = snap.value  as! [String:AnyObject]
                let skillsID = self.convertToAarry(convertString(value["skills"]))
                
                let aWorker =  self.parseWorkerFirbaseValue(value)
                
                // get wectin where skillsID belong and add them into array   athat belogn to
                for  lookingSkill in skillsID{
                    
                    self.extractSection(bySkillID: lookingSkill, completion: { (foundSectionDetails) in
                        if let asection =  foundSectionDetails {
                            
                            //add the section that is
                            // if class with the workers range
                            
                            let distance = self.getDistanceBetween(location1: sectionWithLocation, location2: aWorker.getLocation())
                            
                            if distance <= aWorker.location.Range{
                                
                                guard distance > 0 else{
                                    return
                                }
                                guard aWorker.id != userSessionManagement.isLoginedIn() else {
                                    return
                                }
                                
                                sEctions.add(section: asection)
                                self.extarctSkills(basedOnSectionID: asection.id, completion: { (skills_) in
                                    
                                    guard skills_ != nil else{
                                        return
                                    }
                                    sEctions.add(skills: skills_!, at: asection)
                                    
                                    self.sectionsBasedOnUserLocations = sEctions
                                    completion(sEctions.getSections())
                                    
                                })
                                
                            }
                            
                            
                            
                        }else{
                            
                        }
                    })
                    
                    
                }
                
                
                
                
                
            }
            
            
            
        })
        
    }
    
    func getSections()  {
        ref.child("sections").observeSingleEvent(of: .value, with: { (snapshot) in
            
            for section in snapshot.children {
                let snap = section as! DataSnapshot
                let key = snap.key
                let value = snap.value  as! [String:AnyObject]
                
                
                let  asection = sectionModel(id: key,
                                             name:convertString(value["name"] ) ,
                                             avatar:convertString(value["avatar"]), sort:convertInt(value["sort"]))
                let skills = value["skills"] as! [AnyObject]
                
                for skill in skills{
                    
                    let askill = skillModel(id: (skill["id"] as? String)!, name:(skill["name"] as? String)!, sort: 0)
                    asection.addSkill(aSkill: askill)
                }
                
                self.sections.add(section: asection)
            }
            
            
        })
        
        
        
    }
    func getRandomIDUsingFirBase() -> String{
        
        let id:String = ref.childByAutoId().description()
        let split = id.split(separator: "/")
        return String(describing:split.last!)
    }
}
