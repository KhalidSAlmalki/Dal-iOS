//
//  dalSelectionDataSource.swift
//  Dal
//
//  Created by khalid almalki on 4/11/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import Foundation

protocol dalSelectionDelgate:class{
    func dalSelectionDidSelected(skills:[sectionModel])
}

protocol dalSelectionDataSource:class{
    func dalSelectionSelectedSkills() -> [sectionModel]
}
