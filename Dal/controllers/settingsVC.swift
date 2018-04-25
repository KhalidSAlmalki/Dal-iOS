//
//  settingsVC.swift
//  Dal
//
//  Created by khalid almalki on 4/18/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import UIKit


class settingsVC: UITableViewController {
    let LONGOUTTAG = 100
    let SUSPENDTAG = 101
    let BECOMEWORKERTAG = 102
    let updateDataTAG = 103
//    let USERNAMETAG = 2
//    let CONTACTTAG = 3
//    let USERROLETAGE = 4
    
    @IBOutlet weak var suspendMyAccount: UITableViewCell!
    @IBOutlet weak var becomeWorker: UITableViewCell!
    @IBOutlet weak var logoutCell: UITableViewCell!
    
    @IBOutlet weak var updateData: UITableViewCell!
    @IBOutlet weak var userName: UITableViewCell!
    @IBOutlet weak var contactNumberCell: UITableViewCell!
    @IBOutlet weak var RoleCell: UITableViewCell!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        suspendMyAccount.tag = SUSPENDTAG
        logoutCell.tag = LONGOUTTAG
        becomeWorker.tag = BECOMEWORKERTAG
        updateData.tag = updateDataTAG
        
        self.title = "Setting"
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
       self.navigationController!.navigationBar.barTintColor =  .dalHeaderColor()
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        UIApplication.shared.statusBarStyle = .lightContent
        navigationController!.navigationBar.backgroundColor = .dalHeaderColor()
        navigationController?.navigationBar.isTranslucent = false
        
        
        userSessionManagement.getLoginedUserData { (w) in
            self.userName.detailTextLabel?.text = w?.name
            self.contactNumberCell.detailTextLabel?.text = w?.contactMethod
            
            if w?.getRole() == .worker{
                self.becomeWorker.isHidden = true
                  self.RoleCell.detailTextLabel?.text = "worker"
                self.updateData.isHidden = false
            }else{
                self.RoleCell.detailTextLabel?.text = "user"

                self.becomeWorker.isHidden = false
                self.updateData.isHidden = true


            }
            
        }
        

    }
    
    @IBAction func doneBT(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        switch cell?.tag {
        case BECOMEWORKERTAG:
            
            let becomeWorker = dalBaseView(storyBoard: "addworkerVC")
            let vc = becomeWorker.getViewController() as! addworkerVC
                vc.vcRequestedBased = .becomeWorker
                vc.setUp()
                becomeWorker.showOnWindos()
            
             break
        case SUSPENDTAG:
            break
        case LONGOUTTAG:
            if userSessionManagement.logout(){
                self.dismiss(animated: true, completion: nil)
                self.present((applicationDelegate.window?.rootViewController)!, animated: true, completion: nil)
                
            }
             
            
            break
        default:
            break
            
        }
        
        
        
    }
    

}
