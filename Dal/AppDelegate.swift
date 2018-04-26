//
//  AppDelegate.swift
//  Dal
//
//  Created by khalid almalki on 4/3/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
let applicationDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var window2: UIWindow?

    var ref: DatabaseReference!
    var reloadWorkerhasBeenRegisterd:Bool = false
    var sections:[sectionModel] = []
    var delgate:dataFeederProtocol?
    var sectionsWithSkills:[sectionModel] = []
   lazy var storageRef = Storage.storage().reference()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window2 = UIWindow(frame: UIScreen.main.bounds)
        if let window = window2 {
            window.backgroundColor = UIColor.clear
            
            window.rootViewController = UIViewController()
            window.isHidden = true
        }
        
        sections = []
        FirebaseApp.configure()
        
        ref = Database.database().reference()
        GMSServices.provideAPIKey("AIzaSyCF8gJ-IIVt8ls__CVXK1rpEGdkQeo63ck")
       
        getSections()
        
        
        
        return true
    }


    

    func dalPresent(vc:UIViewController, animated: Bool, completion:(()->Void)?){
      window2?.isHidden = false
        window2?.rootViewController?.present(vc, animated: animated, completion: completion)
    }
    func getRandomIDUsingFirBase() -> String{
        
        let id:String = ref.childByAutoId().description()
        let split = id.split(separator: "/")
    return String(describing:split.last!)
    }
    
 
    func dalDismiss(animated: Bool, completion:(()->Void)?){
    
    self.window2?.rootViewController?.dismiss(animated: true, completion: completion)

    
        
        window2?.isHidden = true

    }
   
    func getSectionIndex(_ section:sectionModel) -> Int? {
        
        return sections.index(where: {$0.id == section.id})
        
    }
    func convertToAarry(_ string:String) -> [String] {
        var strings:[String] = []
        let splitString = string.split(separator: ";")
        for aSubstring in splitString {
            
            strings.append(convertString(aSubstring as AnyObject))
        }
        return strings
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
                                
                                self.sections = sEctions.getSections()
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

                self.sectionsWithSkills.append(asection)
            }
           
           
        })
        
        
        
    }
 
    func create(worker:workerModel)  {
        
            let worker_ = [
                        "name":worker.name,
                        "avatar":worker.avatar,
                        "coverageRange":worker.location.Range,
                        "contactMethod":worker.contactMethod,
                        "desc":worker.desc,
                        "id":worker.id,
                        "location":"\(worker.location.location.latitude);\(worker.location.location.latitude)",
                        "contactNumber":worker.contactNumber,
                        "skills":worker.skillIDs,
                        "status":worker.status
                ] as [String : Any]

        self.ref.child("workers").child(worker.id).setValue(worker_)
        
    }


    
    func update(id:String, child:String , value:[AnyHashable : Any])  {
        ref.child(child).child(id).updateChildValues(value )
    }
   


}

