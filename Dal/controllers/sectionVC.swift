//
//  item.swift
//  Dal
//
//  Created by khalid almalki on 4/3/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import Foundation
import UIKit

class sectionVC: UIViewController {
    

    
    init(sectionID: String) {
        super.init(nibName: nil, bundle: nil)
        setUpworkerCollectionView(sectionID)

      
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func setUpworkerCollectionView(_ sectionID: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let storyboardVC = storyboard.instantiateViewController(withIdentifier: "WorkerCollectionVC") as! WorkerCollectionVC
        
        storyboardVC.sectionID = sectionID
        self.configureChildViewController(childController: storyboardVC, onView: self.view)
    }
    
}


