//
//  PageMenuDataModel.swift
//  Dal
//
//  Created by khalid almalki on 4/7/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import UIKit
struct MenuItemViewDataModel {
    let name:String
    let logo:String
}
public struct PageMenuDataModel {
    let controller:UIViewController
    let MenuItemView:MenuItemViewDataModel
}
