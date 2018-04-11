//
//  AppDelegate.swift
//  Dal
//
//  Created by khalid almalki on 4/3/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import UIKit
import Firebase
let applicationDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var ref: DatabaseReference!
    var reloadWorkerhasBeenRegisterd:Bool = false
    var sections:[sectionModel] = []
    var delgate:dataFeederProtocol?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        sections = []
        FirebaseApp.configure()
        
        ref = Database.database().reference()

       // createSectionsOnFireBase()
    
        return true
    }

    private func createSectionsOnFireBase(){
        
    

       getSections()
        
     
    
    }
    func get(sectionDetail withID:String , complettion:(String)->Void){
        
    }
    func getworkers(completion:@escaping ([workerModel])->Void)  {
        ref.child("workers").observeSingleEvent(of: .value, with: { (snapshot) in
            
            var workers = [workerModel]()
            
            for worker in snapshot.children {
                let snap = worker as! DataSnapshot
             //   let key = snap.key
                let value = snap.value  as! [String:AnyObject]
                let aWorker = workerModel(id: convertString(value["id"]) ,
                                          sectionID: (value["sectionID"] as? [String])!,
                                          contactNumber: convertString(value["contactNumber"] ) ,
                                          name: convertString(value["name"] ),
                                          description: convertString(value["desc"] ),
                                          avatar: convertString(value["avatar"] ),
                                          location: value["loc"] as! [Double])
                
                print(aWorker)
                workers.append(aWorker)
            }
            completion(workers)
           // self.delgate?.workerDataDidUpdate!(data: workers)
            
            
        })
        
        
        
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
                                                
                                                let skill = skillModel(id: iid, name:(askill["id"] as? String)!, sort: 0)
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
               
                self.sections.append(sectionModel(id: key, name: convertString(value["name"] ) , avatar:convertString(value["avatar"]), sort:convertInt(value["sort"])))
            }
            self.delgate?.sectionDataDidUpdate!(data: self.sections)
           
           
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
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

