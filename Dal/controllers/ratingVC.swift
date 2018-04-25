//
//  ratingVC.swift
//  Dal
//
//  Created by khalid almalki on 4/24/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import UIKit
import Cosmos

class ratingVC: baseViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rateControl: CosmosView!
    
    @IBOutlet weak var close: UIButton!
    @IBOutlet weak var imageView: UIImageView!

    var worker = workerModel()

    
    func  setUP(worker:workerModel){
     close.tintColor = UIColor.dalHeaderColor()
     close.backgroundColor = .clear
        imageView.dalSetImage(url: worker.avatar)
        self.worker = worker
    }

    

    @IBAction func rateBt(_ sender: Any) {
     
        applicationDelegate.ref.child("rates").child(worker.id).child(userSessionManagement.IsLogined).setValue(["score":rateControl.rating]) { (err, d) in
            
            self.dalbbaseView?.dismiss()
        }
        
        
        
    }
    

}
