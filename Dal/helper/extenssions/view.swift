//
//  view.swift
//  Dal
//
//  Created by khalid almalki on 4/6/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import UIKit
extension UIView{
    
    @IBInspectable var CornerRaduis:CGFloat{
        get{
            return self.layer.cornerRadius
        }
        set{
            self.layer.cornerRadius=newValue
        }
    }
    open override func awakeFromNib() {
        self.layoutIfNeeded()
    }
    @IBInspectable var circleView:Bool{
        
        get{
            return false
        }
        set{
            if newValue == true{
                
                self.layoutIfNeeded()
                self.layer.cornerRadius = self.frame.width / 2.0
                self.clipsToBounds = true
                self.layer.masksToBounds = true
                self.layoutIfNeeded()
                
                
                
            }else{
                self.layer.cornerRadius = 0
                self.clipsToBounds = true
            }
        }
    }
    
    @IBInspectable var borderWidth:CGFloat{
        get{
            return self.layer.borderWidth
        }
        set{
            self.layer.borderWidth=newValue
        }
    }
    @IBInspectable var BorderColor:UIColor{
        get{
            return UIColor.blue
        }
        set{
            self.layer.borderColor=newValue.cgColor
        }
    }
    
    
}
extension UIView {
    
    func constrainCentered(_ subview: UIView) {
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        let verticalContraint = NSLayoutConstraint(
            item: subview,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerY,
            multiplier: 1.0,
            constant: 0)
        
        let horizontalContraint = NSLayoutConstraint(
            item: subview,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerX,
            multiplier: 1.0,
            constant: 0)
        
        let heightContraint = NSLayoutConstraint(
            item: subview,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: subview.frame.height)
        
        let widthContraint = NSLayoutConstraint(
            item: subview,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: subview.frame.width)
        
        addConstraints([
            horizontalContraint,
            verticalContraint,
            heightContraint,
            widthContraint])
        
    }
    
    func constrainToEdges(_ subview: UIView) {
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        let topContraint = NSLayoutConstraint(
            item: subview,
            attribute: .top,
            relatedBy: .equal,
            toItem: self,
            attribute: .top,
            multiplier: 1.0,
            constant: 0)
        
        let bottomConstraint = NSLayoutConstraint(
            item: subview,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: self,
            attribute: .bottom,
            multiplier: 1.0,
            constant: 0)
        
        let leadingContraint = NSLayoutConstraint(
            item: subview,
            attribute: .leading,
            relatedBy: .equal,
            toItem: self,
            attribute: .leading,
            multiplier: 1.0,
            constant: 0)
        
        let trailingContraint = NSLayoutConstraint(
            item: subview,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: self,
            attribute: .trailing,
            multiplier: 1.0,
            constant: 0)
        
        addConstraints([
            topContraint,
            bottomConstraint,
            leadingContraint,
            trailingContraint])
    }
    
}
