//
//  dalBaseView.swift
//  Dal
//
//  Created by khalid almalki on 4/7/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import UIKit

class dalBaseView: UIView {

    // MARK: - View sizing
    
   
    class public  var fullNavbarHeight: CGFloat {
        return dalBaseView.navbarHeight + dalBaseView.statusBarHeight
    }
    class public var navbarHeight: CGFloat {
        return  70
    }
 
    class public   var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    class public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    class public  var statusBarHeight: CGFloat {
        var statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        if #available(iOS 11.0, *) {
            // Account for the notch when the status bar is hidden
            statusBarHeight = max(UIApplication.shared.statusBarFrame.size.height, UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0)
        }
        return statusBarHeight
    }
    
    
   private var targetViewController:UIViewController = UIViewController()
   private var showOnViewController:UIViewController? = nil
    
    private var contentView:UIView = UIView()
 

   convenience init(storyBoard id:String) {
    self.init(frame: CGRect(x: 15, y: 70, width: dalBaseView.screenWidth-30, height: dalBaseView.screenHeight-100), storyBoard: id)

    }
    // the main init
    init(frame: CGRect, storyBoard id:String) {
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.70)
        
        self.addSubview(contentView)
        contentView.frame = frame
        
        targetViewController = getUIviewController(storyBoard: id)
        setUpInterfaces()
        self.viewWithTag(100100)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func showOn(_ controller:UIViewController)  {
        
        showOnViewController = controller
        controller.view.addSubview(self)
        addViewControllerAsChild()
        
    }
    func showOnWindos()  {
        let window = UIApplication.shared.keyWindow!
        window.addSubview(self)
        showOnViewController = window.rootViewController
        addViewControllerAsChild()
    }
    func getViewController() -> UIViewController {
        return targetViewController
    }
    func dismiss() {
        self.window?.viewWithTag(100100)?.removeFromSuperview()
        self.removeFromSuperview()
        self.targetViewController.removeFromParentViewController()
        self.showOnViewController?.removeFromParentViewController()
        self.showOnViewController?.didMove(toParentViewController: nil)
    }
    
    private func setUpInterfaces(){
        targetViewController.view.frame = self.contentView.bounds
    }
    private func addViewControllerAsChild(){
        guard showOnViewController != nil else {
            fatalError("  showOn  has not been implemented")
        }
        showOnViewController?.addChildViewController(targetViewController)
        contentView.addSubview(targetViewController.view!)
        targetViewController.didMove(toParentViewController:showOnViewController)
        
    }
    private func getUIviewController( storyBoard id:String)-> UIViewController{
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: id)
        if vc is baseViewController {
            (vc as! baseViewController).dalbbaseView = self
        }
        return vc
    }

}
