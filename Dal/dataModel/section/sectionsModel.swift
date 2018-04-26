//
//  sectionsModel.swift
//  Dal
//
//  Created by khalid almalki on 4/24/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import UIKit
class sectionsModel:NSObject {
    private var sectionList:[sectionModel] = []
    override var description: String{
        return "sectionList : \(sectionList.count)"
    }
    override init() {
        super.init()
        
        sectionList = []
    }
    //MARK: - Add methods
    func add(section:sectionModel) {
        
        if !sectionList.contains(where: {$0.id == section.id}){
            sectionList.append(section)
        }
    }
    
    func add(listOf sections:[sectionModel] ){
        
        for s in sections {
            self.add(section: s)
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
    
    func add(section bySkillIDs:[String]){
        
        // get section detalis if skill has this id
        
        for Skill in bySkillIDs {
            let secs = restAPI.shared.sectionsBasedOnUserLocations.getSections()
            
            // get section id
       
            if let index = secs.index(where: { (sec) -> Bool in
                if sec.skills.contains(where:{$0.id == Skill }){return true};return false}){
                
                let foundSkill = sectionModel(id: secs[index].id, name: secs[index].name, avatar: secs[index].avatar, sort: secs[index].sort)

                if let  sectionListIndex =  sectionList.index(where: {$0.id == foundSkill.id}){
                    
                    if let _skill = secs[index].getSkillModel(by: Skill){
                        
                        sectionList[sectionListIndex].addSkill(aSkill: _skill)
                                                
                    }
                }else{
                    
                    add(section: foundSkill)
                    
                    let s:[String] = [Skill]
                    add(section: s)
                }

                
           
                
                
                
               }
        }
        print("all added method",getSections())
        
    }
    //MARK: - get methods


    func clear()  {
        sectionList = []
    }
    func getSections() -> [sectionModel] {
        return sectionList
    }
    func count() -> Int {
        return sectionList.count
    }
    
    func getAllSkillID() -> String{
        var temp = ""
        for _skill in sectionList {
            temp += _skill.getSkillsIDAsString()
            temp += ";"

        }
        guard !temp.isEmpty else {
            return temp
        }
        temp.removeLast()
        return temp

    }
    func getSectionIndex(_ id:String) -> Int? {
        
        return sectionList.index(where: {$0.id == id})
        
    }
    func getAllSkillDesc()-> String{
        
        var temp = ""
        for _skill in sectionList {
            temp += _skill.getSkillsNameAsString()

        }
        guard !temp.isEmpty else {
            return temp
        }
        temp.removeLast()
        return temp
    }
    
}
