//
//  locator.swift
//  Dal
//
//  Created by khalid almalki on 4/17/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import Foundation
import CoreLocation

class Locator: NSObject, CLLocationManagerDelegate {
    enum ResultL {
        case Success
        case Failure
    }
    
    static let shared: Locator = Locator()
    
    typealias Callback = (ResultL)-> Void
    
    var CallbackauthorizationStatus:((ResultL)-> Void)!
    
    var requests: Array <Callback> = Array <Callback>()
    
    var location: CLLocation? { return sharedLocationManager.location  }
    
    lazy var sharedLocationManager: CLLocationManager = {
        let newLocationmanager = CLLocationManager()
        newLocationmanager.delegate = self
        // ...
        return newLocationmanager
    }()
    
    // MARK: - Authorization
    
    func authorize(_ respond: @escaping (ResultL) -> Void) {
        CallbackauthorizationStatus = respond
        if CLLocationManager.locationServicesEnabled() {
            sharedLocationManager.requestWhenInUseAuthorization()
            
        }
    }
    
    // MARK: - Helpers
    
    func locate(callback: @escaping Callback) {
        self.requests.append(callback)
        sharedLocationManager.startUpdatingLocation()
    }
    

    func reset() {
        self.requests = Array <Callback>()
        sharedLocationManager.stopUpdatingLocation()
    }
    
    // MARK: - Delegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch(CLLocationManager.authorizationStatus()) {
        case .notDetermined:
            break
        case .restricted, .denied:
            if CallbackauthorizationStatus != nil{
                CallbackauthorizationStatus(.Failure)
                
            }
            
        case .authorizedAlways, .authorizedWhenInUse:
            if CallbackauthorizationStatus != nil{
                CallbackauthorizationStatus(.Success)
                
            }
            
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        for request in self.requests { request(.Failure) }
        self.reset()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: Array <CLLocation>) {
        for request in self.requests { request(.Success) }
        self.reset()
    }
    
}
