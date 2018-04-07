//
//  ViewController.swift
//  Dal
//
//  Created by khalid almalki on 4/3/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import UIKit

class HomeVC: SectionVC {


    @IBOutlet weak var PagingView: UIView!
    

    var sectionItems:[sectionModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        applicationDelegate.delgate = self
        
        setUPPagingVC()
       // setUPPagingVC()
     }



private func setUPPagingVC() {
    // Do any additional setup after loading the view, typically from a nib.
    

    
    
    
}
}
extension HomeVC:dataFeederProtocol{
    func sectionDataDidUpdate(data: [sectionModel]) {
        print("sectionDataDidUpdate")
        sectionItems = data
        self.sectionItems = self.sectionItems.sorted(by: { $0.sort < $1.sort })


    }
    
  
    
    
}


