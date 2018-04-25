//
//  sectionsModel.swift
//  Dal
//
//  Created by khalid almalki on 4/24/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import UIKit
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
