//
//  sectionProtocol.swift
//  Dal
//
//  Created by khalid almalki on 4/4/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import UIKit

@objc protocol dataFeederProtocol : class{
    @objc optional func workerDataDidUpdate(data:[workerModel])

    @objc optional func sectionDataDidUpdate(data:[sectionModel])

}
