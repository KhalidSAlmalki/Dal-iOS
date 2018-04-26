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

  
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window2 = UIWindow(frame: UIScreen.main.bounds)
        if let window = window2 {
            window.backgroundColor = UIColor.clear
            
            window.rootViewController = UIViewController()
            window.isHidden = true
        }
        
        FirebaseApp.configure()

        GMSServices.provideAPIKey("AIzaSyCF8gJ-IIVt8ls__CVXK1rpEGdkQeo63ck")
       
        
        restAPI.shared.getSections()
        
        
        return true
    }


    

    func dalPresent(vc:UIViewController, animated: Bool, completion:(()->Void)?){
      window2?.isHidden = false
        window2?.rootViewController?.present(vc, animated: animated, completion: completion)
    }
  
    
 
    func dalDismiss(animated: Bool, completion:(()->Void)?){
    
    self.window2?.rootViewController?.dismiss(animated: true, completion: completion)

        window2?.isHidden = true

    }
   
   
 

   


}

