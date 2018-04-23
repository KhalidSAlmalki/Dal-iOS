//
//  settingsVC.swift
//  Dal
//
//  Created by khalid almalki on 4/18/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import UIKit

class settingsVC: UITableViewController {

    @IBAction func doneBT(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Setting"
        
        self.navigationController!.navigationBar.barTintColor =  .dalHeaderColor()
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        UIApplication.shared.statusBarStyle = .lightContent
        navigationController!.navigationBar.backgroundColor = .dalHeaderColor()
        navigationController?.navigationBar.isTranslucent = false

    }

   
    @IBAction func dismissVC(_ sender: Any) {
    
    }
    

}
