//
//  workersModel.swift
//  Dal
//
//  Created by khalid almalki on 4/24/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import UIKit
import CoreLocation
class workersModel:NSObject {
    private var list:[workerModel] = []
    
  
    override init() {
        super.init()
        list = []
        
    }
    
    func add(worker:workerModel, currentlocation:CLLocation) {
        
        let distance =  restAPI.shared.getDistanceBetween(location1: currentlocation, location2:worker.getLocation() )
        
        guard distance > 0 else {
            return
        }
        
        guard worker.id != userSessionManagement.isLoginedIn() else {
            return
        }
        if  distance <= worker.location.Range {
            
            if !list.contains(where: {$0.id == worker.id}){
                worker.distance = distance
                list.append(worker)
            }
        }
        
      
    }
    
    func remove(workerID:String)  {
        if let index = list.index(where: {$0.id == workerID}){
            
            list.remove(at: index)
        }
        
    }
    func getWorkerList() -> [workerModel] {
      
        let temp =   list.sorted(by: {$0.distance < $1.distance })

        return  temp

    }
    
 
  
    

    

    
    
    
}
