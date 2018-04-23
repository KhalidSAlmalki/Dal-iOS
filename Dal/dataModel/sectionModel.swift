//
//  sectionModel.swift
//  Dal
//
//  Created by khalid almalki on 4/4/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import Foundation
import CoreLocation

class sectionsModel:NSObject {
    var sectionList:[sectionModel] = []
    override var description: String{
        return "sectionList : \(sectionList.count)"
    }
    override init() {
        super.init()

    }
    func add(section:sectionModel) {
        
        if !sectionList.contains(where: {$0.id == section.id}){
            print(section)
            sectionList.append(section)
            print(self)
        }
    }
    
    func add(skills:[skillModel], at:sectionModel) {
        
        for s in skills {
            add(skill: s, at: at)
        }
    }
    func add(skill:skillModel, at:sectionModel) {
        if let index = sectionList.index(where: {$0.id == at.id}){
            sectionList[index].addSkill(aSkill: skill)
        }
    }
    
}
class sectionModel:NSObject  {

    
    override var description: String{
        return " id : \(id) ,name : \(name)  avatar : \(avatar) sort : \(sort)  skills : \(skills) "

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
        if !skills.contains(where: {$0.id == aSkill.id}){
            skills.append(aSkill)
        }
        
    }
    func getSkillModel(by id:String) -> skillModel? {
        
       if let index = skills.index(where: {$0.id == id}){
        
        return skills[index]
        
        }
        return nil
    }
    func getSkillsIDAsString() -> String {
        
        var skills = ""
        for askill in self.skills {
           skills += askill.id
            
            skills += ";"

        }
        skills.removeLast()
        return skills
    }
    
    func getSkillsNameAsString() -> String {
        
        var skills = ""
        for askill in self.skills {
            skills += askill.name
            
            skills += " , "
            
        }
        skills.removeLast()
        return skills
    }
    
   
}
