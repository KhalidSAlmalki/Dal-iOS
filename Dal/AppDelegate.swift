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
    var ref: DatabaseReference!
    var reloadWorkerhasBeenRegisterd:Bool = false
    var sections:[sectionModel] = []
    var delgate:dataFeederProtocol?
    var sectionsWithSkills:[sectionModel] = []
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        sections = []
        FirebaseApp.configure()
        
        ref = Database.database().reference()

        GMSServices.provideAPIKey("AIzaSyCF8gJ-IIVt8ls__CVXK1rpEGdkQeo63ck")
       
        getSections()
        return true
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
    func get(sectionWithLocation:String,completion:@escaping ([sectionModel])->Void ) {
        ref.child("workers/worker").observeSingleEvent(of: .value, with: { (snapshot) in
            
            for aworker in snapshot.children {
                let snap = aworker as! DataSnapshot
                let value = snap.value  as! [String:AnyObject]
                let skillsID = self.convertToAarry(convertString(value["skills"]))
                
                // get wectin where skillsID belong and add them into array   athat belogn to
                
                for  lookingSkill in skillsID{
                    self.ref.child("sections").observeSingleEvent(of: .value
                        , with: { (SnapSections) in
                            
                            let reslut = SnapSections.value as! [AnyObject]
                            
                            for r in reslut{
                                let asection = r as! [String:AnyObject]
                                if let skills = asection["skills"] as? [AnyObject]{
                                    
                                    for askill in skills{
                                        if let iid = askill["id"] as? String{
                                            if iid == lookingSkill{
                                     
                                let section = sectionModel(id: convertString(asection["id"]),
                                                           name: convertString(asection["name"]),
                                                           avatar: convertString(asection["avatar"]),
                                                           sort: convertInt(asection["sort"]))
                                                
                                                if self.getSectionIndex(section) == nil{
                                                    self.sections.append(section)
                                                }
                                                    
                                               if let index = self.getSectionIndex(section){
                                                
                                                let skill = skillModel(id: iid, name:(askill["name"] as? String)!, sort: 0)
                                                self.sections[index].addSkill(aSkill: skill)
                                                completion(self.sections)

                                                }
                                                
                                            }
                                            
                                        }
                                        
                                    }
                                    
                                }
                                
                                
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
               
                
                
//                for skill in value["skills"]?.children.v as! [String:AnyObject]{
//                    print(value["name"],skill)
//
//                }
            let  asection = sectionModel(id: key,
                                            name:                 convertString(value["name"] ) ,
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
    func create(workers:workerModel)  {
        
        isUnique(id:workers.id, child: "workers") { (re) in
            if !re {
                let worker = ["name": workers.name,
                              "avatar": workers.avatar,
                              "loc": workers.location,
                              "desc": workers.desc,
                              "sectionID": workers.sectionID,
                              "contactNumber": workers.contactNumber] as [String : Any]
                self.ref.child("workers").child(workers.id).setValue(worker)
                print("child is not  exsit")
                
            }else{
                print("child is exsit")
                let newworkers = workers
                let n = Int(arc4random_uniform(42))
                newworkers.id = workers.id+"\(n)"
                self.create(workers: newworkers)
            }
        }
        
    }
    func create(section:sectionModel) {
        
        isUnique(id:section.id, child: "sections") { (re) in
            if !re {
               
                self.ref.child("sections").child(section.id).setValue(["name":section.name,"avatar":section.avatar,"sort":section.sort])
                print("child is not  exsit")

            }else{
                print("child is exsit")
                let newSection = section
                let n = Int(arc4random_uniform(42))
                newSection.id = section.id+"\(n)"
              self.create(section: newSection)
            }
        }
    }
    
    func isUnique(id:String,child:String, completion: @escaping (Bool)->Void) {
       
        ref.child(child).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild(id){
                completion(true)
                
            }else{
                completion(false)

            }
        })
      
    }
    
 
    
    func update(id:String, child:String , value:[AnyHashable : Any])  {
        ref.child(child).child(id).updateChildValues(value )
    }
   


}

