//
//  image.swift
//  Dal
//
//  Created by khalid almalki on 4/6/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import UIKit
import Kingfisher
extension UIImageView{
    
    func dalSetImageWithRenderingMode(url:String) {
        let url = URL(string:url)
        
        self.kf.setImage(with: url, placeholder: UIImage(named: "icNeutralActive"), options: nil, progressBlock: nil) { (dalimage, err, cash, url) in
            
            self.image = dalimage
            
           self.image = self.image?.withRenderingMode(.alwaysTemplate)

          
        }
    }
    
    func dalSetImage(url:String) {
        let url = URL(string:url)
        
        self.kf.setImage(with: url, placeholder: UIImage(named: "icNeutralActive"), options: nil, progressBlock: nil) { (dalimage, err, cash, url) in
            
            self.image = dalimage
            
            
        }
    }
    
    
}
