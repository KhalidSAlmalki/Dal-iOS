//
//  settingsVC.swift
//  Dal
//
//  Created by khalid almalki on 4/18/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import UIKit

class settingsVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

   
    @IBAction func dismissVC(_ sender: Any) {
        applicationDelegate.dalDismiss(animated: true, completion: nil)
    }
    

}
