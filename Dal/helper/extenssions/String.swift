//
//  String.swift
//  Dal
//
//  Created by khalid almalki on 4/4/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import Foundation
    func convertString(_ any:AnyObject?) -> String {
        
        let text = any as? String
        
        if text != nil {
            // Continue
            // print("convertString any",text! as Any)
            return text!
        } else {
            // Handling the error.
            //print("text")
            
            return ""
        }
    }
    func convertBool(_ any:AnyObject?) -> Bool {
        
        let text = any as? Bool
        
        if text != nil {
            // Continue
            // print(text!)
            return text!
        } else {
            // Handling the error.
            // print("text")
            
            return false
        }
    }
    func convertInt(_ any:AnyObject?) -> Int {
        
        if let num = any?.doubleValue {
            
            //print("Parsing",num)
            
            return Int(num)
        } else {
            //print("Parsing Issue")
        }
        
        return 0
    }
    func convertFloat(_ any:AnyObject?) -> Float {
        
        if let num = any?.doubleValue {
            
            //print("Parsing",num)
            
            return Float(num)
        } else {
            //print("Parsing Issue")
        }
        
        return 0
    }

