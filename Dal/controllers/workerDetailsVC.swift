//
//  workerDetailsVC.swift
//  Dal
//
//  Created by khalid almalki on 4/7/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import UIKit
import Cosmos
class workerDetailsVC: baseViewController {

    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var skill: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var callBt: UIButton!
    
    let PROFILETAG = 0
    let WORKERDETALS = 1


 
    
    func setUP()  {
        
        userSessionManagement.getLoginedUserData { (worker) in
            
            if worker?.getRole() == .worker{
                
                self.setUp(worker: worker!, modeType: .profile)

            }
            
            
            
        }
        
    }
    
    func setUp(worker:workerModel,modeType:modeType){
        
        let sectioins = sectionsModel()
        
        sectioins.add(section: (worker.skillIDs))
        
        name.text = worker.name
        
        desc.text = worker.desc
        
         
        

        self.skill.text = sectioins.getAllSkillDesc()
        
        worker.getRate { (avarage) in
            
            self.ratingView.rating = avarage
            
        }
        
        switch worker.status {
            
        case .active:
            if modeType == .workerDrtails{
                callBt.isEnabled = true
                callBt.setTitle("Contact", for: .normal)
            }
            statusImageView.image = UIImage(named: "icAvailable")
           
            
        case .busy:
            if modeType == .workerDrtails{
                callBt.isEnabled = false
                callBt.setTitle("unavailable", for: .disabled)
            }
            statusImageView.image = UIImage(named: "icBusy")
           
        default:
            statusImageView.isHidden = true
            
        }
        
        
        if modeType == .profile{
        
            callBt.tag = PROFILETAG
            callBt.setTitle("Change Status", for: .normal)
        }else{
            callBt.tag = WORKERDETALS
            callBt.setTitle(worker.contactMethod, for: .normal)

        }
        
    
        
    
        let img = worker.avatar
            
            imageView.dalSetImage(url: img)
        
    }

    @IBAction func closeBt(_ sender: Any) {
        guard dalbbaseView != nil else {
            return
        }
        dalbbaseView?.dismiss() 
    }
    

    
 

}
