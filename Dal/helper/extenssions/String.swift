//
//  String.swift
//  Dal
//
//  Created by khalid almalki on 4/4/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import Foundation

extension Float {
    var clean: String {
        
        let d = "\(Double(self))"
      
        return String(d.prefix(4))
}
}
    func convertWorkerStatus(_ any:AnyObject?)->status{
        let s = convertString(any)
        
        if s == "active"{
            return .active
        }else if s == "busy"{
            return .busy
        }else{
            return .unknown

        }
    
    }
    func convertString(_ any:AnyObject?) -> String {
        
        let text = any as? String
        
        if text != nil {
            // Continue
            return text!
        } else {
            // Handling the error.
            
            return ""
        }
    }
    func convertBool(_ any:AnyObject?) -> Bool {
        
        let text = any as? Bool
        
        if text != nil {
            // Continue
            return text!
        } else {
            // Handling the error.
            
            return false
        }
    }
    func convertInt(_ any:AnyObject?) -> Int {
        
        if let num = any?.doubleValue {
            
            
            return Int(num)
        } else {
        }
        
        return 0
    }
    func convertFloat(_ any:AnyObject?) -> Float {
        
        if let num = any?.doubleValue {
            
            
            return Float(num)
        } else {
        }
        
        return 0
    }
    func convertDouble(_ any:AnyObject?) -> Double {
    
        if let num = any?.doubleValue {
        
        return num
            }
    
    return 0
}

