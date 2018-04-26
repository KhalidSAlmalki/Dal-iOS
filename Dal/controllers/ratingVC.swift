//
//  ratingVC.swift
//  Dal
//
//  Created by khalid almalki on 4/24/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import UIKit
import Cosmos

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

            worker.getRate { (rate) in
                self.rateControl.rating = rate

        }
    
        
        
    }

    @IBAction func closeBt(_ sender: Any) {
        
        self.dalbbaseView?.dismiss()

    }

    @IBAction func rateBt(_ sender: Any) {
     
        applicationDelegate.ref.child("rates").child(worker.id).child(userSessionManagement.IsLogined).setValue(["score":rateControl.rating]) { (err, d) in
            
            self.dalbbaseView?.dismiss()
        }
        
        
        
    }
    

}
