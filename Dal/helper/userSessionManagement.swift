//
//  userSessionManagement.swift
//  Dal
//
//  Created by khalid almalki on 4/23/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import UIKit

class userSessionManagement {
    
    class var IsLogined:String{
        get{
            guard isLoginedIn() != nil else {
                return ""
            }
            return isLoginedIn()!
        }
    }
    
    
   class internal func isLoginedIn() -> String? {
        let userDefaults = UserDefaults.standard
        if let currentUser  = userDefaults.value(forKey: "currentUser") as? String{
            return currentUser
        }
        return nil
    }
    class func logout()-> Bool{
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "currentUser")
        userDefaults.synchronize()
        
        if IsLogined.isEmpty  {
            return true
        }
        
        return false
        
    }
    class func getLoginedUserData(completion:@escaping((workerModel?)->Void)){
        
        if isLoginedIn() != nil{
            restAPI.shared.getWorkerDetail(usingUserID: isLoginedIn()!) { (worker) in
                
                completion(worker)
            }

        }else{
            completion(nil)

        }
        
    }


class func saveUserData(worker:workerModel){
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(worker.id, forKey: "currentUser")
        userDefaults.synchronize()
        
        
    }
}
