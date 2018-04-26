//
//  workerCell.swift
//  Dal
//
//  Created by khalid almalki on 4/5/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import UIKit

class workerCell: UICollectionViewCell {

    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var skill: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.BorderColor = .dalHeaderColor()
        self.name.textColor = .dalHeaderColor()
        self.skill.textColor = UIColor.dalWarmGreyColor()
        self.distance.textColor = UIColor.dalWarmGreyColor()
        self.address.textColor = UIColor.dalWarmGreyColor()

    }
    
    func setUP(_ worker:workerModel , at section:sectionModel){
        
        self.name.text = worker.name
        self.address.text = ""
        self.distance.text = "\(worker.distance.clean)"
        self.imageView.dalSetImage(url: worker.avatar)
        
        
        
        statusImageView.isHidden = false

        switch worker.status {

        case .active:
            statusImageView.image = UIImage(named: "icAvailable")

        case .busy:
            statusImageView.image = UIImage(named: "icBusy")

        default:
            statusImageView.isHidden = true

        }
        
        
        worker.location.getCountryAndCity { (co, ci) in
            
            self.address.text = "\(co),\(ci) "
            self.reloadInputViews()
        }
   
        var skilldesc = ""
        for _skill in worker.skillIDs
            {
        if let skill = section.getSkillModel(by: _skill){skilldesc += skill.name;skilldesc += ","
            }
        }
        skilldesc.removeLast()
        self.skill.text = skilldesc
        
    }


}
