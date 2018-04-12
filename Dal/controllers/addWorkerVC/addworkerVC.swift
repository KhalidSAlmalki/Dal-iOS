//
//  addworkerVC.swift
//  Dal
//
//  Created by khalid almalki on 4/11/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import UIKit

class addworkerVC: baseViewController {

    @IBOutlet weak var descTextfield: UITextField!
    @IBOutlet weak var SkillsTextfield: UITextField!
    @IBOutlet weak var LocationTextfield: UITextField!
    @IBOutlet weak var contactTextfield: UITextField!
    @IBOutlet weak var typeTextfield: UITextField!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    // list of  contact type
    let listType = ["phone number","whats up","email"]
    
    var sectionWithSkills = [sectionModel]()
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sectionWithSkills = applicationDelegate.sectionsWithSkills
        
        // CGRect(x: 0, y: dalBaseView.screenHeight-200, width: dalBaseView.screenWidth, height: 200)
        
       
      
    }

    func validateUserInput() -> Bool  {
        return false
    }
    
    func getUserInputs()  {
        //
    }
    func setUpPicker() {
        
    }
    
    func registerWorker()  {
        
    }
    func dismissCurrentView()  {
        
    }

    //MARK -dsd
    
    
    @IBAction func googleMapView(_ sender: UITextField) {
//        let googleMap = dalBaseView(storyBoard: "googleMapVC")
//        googleMap.showOnWindos()
        
        let googleMap = dalBaseView(storyBoard: "dalSelection")
        googleMap.showOnWindos()
    }
 
    @IBAction func closeBt(_ sender: Any) {
     //   dismissDalBaseView()
        let frame = CGRect(x: 0, y:dalBaseView.screenHeight-200, width: dalBaseView.screenWidth, height: 200)
        let dalSelection = dalBaseView(frame: frame,storyBoard: "dalSelection")
        let vc = dalSelection.getViewController() as! dalSelection
        vc.sectionWithSkills = sectionWithSkills
        vc.setUP()
        dalSelection.showOnWindos()
    }
    

}
