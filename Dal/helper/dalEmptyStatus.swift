//
//  dalEmptyStatus.swift
//  Dal
//
//  Created by khalid almalki on 4/27/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//
import UIKit
struct emptyStatusData {
    let name:String
    let image:String
}
class SSEmptyStatus: UIView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    var Image:UIImageView = {
        let t = UIImageView()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.backgroundColor =  .clear
        t.contentMode = .scaleAspectFit
        
        return t
    }()
    
    var SSTitle: UILabel = {
        let t = UILabel()
        t.text = ""
        t.translatesAutoresizingMaskIntoConstraints = false
        t.backgroundColor = .clear
        t.numberOfLines = 0
        t.font = UIFont.boldSystemFont(ofSize: 17)
        t.textColor = .black
        t.textAlignment = .center
        
        return t
    }()
    
    
    
    func configure(appendIn:UIView, data:emptyStatusData) {
        self.layoutIfNeeded()
        
        self.frame = appendIn.bounds
        self.backgroundColor = .clear
        appendIn.addSubview(self)
        
        self.addSubview(SSTitle)
        //need x, y, width, height constraints
        SSTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant:15).isActive = true
        SSTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant:0).isActive = true
        SSTitle.widthAnchor.constraint(equalTo: self.widthAnchor, constant:0).isActive = true
        SSTitle.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        self.addSubview(Image)
        Image.image = UIImage(named: data.image)
        Image.bottomAnchor.constraint(equalTo: SSTitle.topAnchor, constant:-30).isActive = true
        Image.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant:0).isActive = true
        Image.heightAnchor.constraint(equalToConstant: 92).isActive = true
        Image.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        
        SSTitle.text = data.name
        
    }
    func SSremove()  {
        self.removeFromSuperview()
    }
    
}
