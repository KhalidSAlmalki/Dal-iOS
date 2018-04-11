//
//  sectionModel.swift
//  Dal
//
//  Created by khalid almalki on 4/4/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import Foundation
import CoreLocation
class sectionModel:NSObject  {

    
    override var description: String{
        return " name : \(name) "

//        return "id : \(id) \n name : \(name) \n avatar : \(avatar) \n  sort: \(sort)\n"
    }
    
    var id:String
    var name:String
    var avatar:String
    var sort:Int
    var skills:[skillModel]

    override convenience init() {
        self.init(id: "", name: "", avatar: "", sort: 0)
    }
    init(id:String,name:String,avatar:String,sort:Int) {
        self.id = id
        self.name = name
        self.avatar = avatar
        self.sort = sort
        self.skills = []
      }
    
    func addSkill(aSkill:skillModel)  {
        if skills.index(where: {$0.id == aSkill.id}) == nil{
            skills.append(aSkill)

        }
        
    }
    
   
}
