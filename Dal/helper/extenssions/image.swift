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
    
    func dalSetImage(url:String) {
        let url = URL(string:url)
        
        self.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil) { (image, err, cash, url) in
            
            if let images = self.image{
                self.image = images.withRenderingMode(.alwaysTemplate)
            }
        }
    }
    
}
