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

    var sections:[sectionModel] = []
    var delgate:sectionProtocol?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        sections = []
        FirebaseApp.configure()
        
        ref = Database.database().reference()

        createSectionsOnFireBase()
        
        return true
    }

    private func createSectionsOnFireBase(){
        
        
        let url = "https://www.google.com/url?sa=i&rct=j&q=&esrc=s&source=images&cd=&cad=rja&uact=8&ved=2ahUKEwi-5ve3nKHaAhUFVd8KHTDQCiIQjRx6BAgAEAU&url=https%3A%2F%2Fwww.iconfinder.com%2Ficons%2F1876893%2Ffreelance_programmer_freelance_web_designer_software_developer_web_designer_web_developer_web_programmer_website_developer_icon&psig=AOvVaw1W5hyU4Sl2lQpH2dDSvZ5g&ust=1522951990587682"
       
        let profileAvatar = "https://www.google.com/imgres?imgurl=https%3A%2F%2Fwww.shareicon.net%2Fdownload%2F2016%2F07%2F26%2F802026_man.svg&imgrefurl=https%3A%2F%2Fwww.shareicon.net%2Fman-profile-avatar-user-social-802026&docid=W8RRRMobR06G1M&tbnid=Szy8MYwKSjgwPM%3A&vet=1&w=800&h=800&client=safari&bih=661&biw=1096&ved=0ahUKEwjRvfLMm6HaAhXyYt8KHR6vCW4QMwiPAigDMAM&iact=c&ictx=1"
        
//        let section = sectionModel(id: "", name: "", avatar: "", sort: 0)
//        let section1 = sectionModel(id: "", name: "", avatar: "", sort: 0)
//        let section2 = sectionModel(id: "", name: "", avatar: "", sort: 0)
//        let section3 = sectionModel(id: "", name: "", avatar: "", sort: 0)

       // sections.append()

        //create(section:sectionModel(id: "-L9Gs9JEclMumK2oCExt-1", name: "claose", avatar: profileAvatar, sort: 14))
       getSections()
        
     
    
    }
    func getSections()  {
        ref.child("sections").observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            for section in snapshot.children {
                let snap = section as! DataSnapshot
                let key = snap.key
                let value = snap.value  as! [String:AnyObject]
               
                self.sections.append(sectionModel(id: key, name: convertString(value["name"] ) , avatar:convertString(value["avatar"]), sort:convertInt(value["sort"])))
            }
            self.delgate?.sectionDataDidUpdate(data: self.sections)
           
           
        })
        
        
        
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

