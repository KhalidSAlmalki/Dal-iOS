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

        // Initialization code
    }

}
