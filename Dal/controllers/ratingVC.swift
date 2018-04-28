//
//  ratingVC.swift
//  Dal
//
//  Created by khalid almalki on 4/24/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import UIKit

enum modeType {
    case profile
    case workerDrtails
}
class ratingVC: baseViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rateControl: CosmosView!
    @IBOutlet weak var statusImageView: UIImageView!
    
   
    @IBOutlet weak var close: UIButton!
    @IBOutlet weak var imageView: UIImageView!

    var worker = workerModel()

    
    func  setUP(worker:workerModel){
        
     self.worker = worker

    
     close.tintColor = UIColor.dalHeaderColor()
     close.backgroundColor = .clear
     imageView.dalSetImage(url: worker.avatar)
     nameLabel.text = worker.name

        worker.getRates(completion: { (rate) in
               self.rateControl.rating = rate
        }) 
    
        
        
    }

    @IBAction func closeBt(_ sender: Any) {
        
        self.dalbbaseView?.dismiss()

    }

    @IBAction func rateBt(_ sender: Any) {
     
       
        restAPI.shared.rate(with: worker.id, whoRate: userSessionManagement.IsLogined, rating: rateControl.rating) { (re) in
            
            self.dalbbaseView?.dismiss()

        }
        
        
        
        
    }
    

}
