//
//  addworkerVC.swift
//  Dal
//
//  Created by khalid almalki on 4/11/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import UIKit

class addworkerVC: baseViewController,UITextFieldDelegate, dalSelectionDataSource,dalSelectionDelgate,googleMapDataSource,googleMapDelegate{
 
 


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
    
    var selectedSkills = [sectionModel]()

    var userLocation = locationModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SkillsTextfield.delegate = self
        LocationTextfield.delegate = self
        
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
    
        
       
    }
 
    @IBAction func closeBt(_ sender: Any) {
       dismissDalBaseView()
     
    }
    
    func dalSelectionSelectedSkills() -> [sectionModel] {
        return selectedSkills
    }
    
    func dalSelectionDidSelected(skills: [sectionModel], selectedSkills: [String]) {
        
        self.selectedSkills = skills
        
        var name = ""
        for s in skills {
            name+=s.getSkillsNameAsString()
        }
        name.removeLast()
        SkillsTextfield.text = name
        
    }
    
    func googleMapDataDidSelected(locationModel: locationModel) {
        
        userLocation = locationModel
    }
    
    func googleMapDataSourceUserLocation() -> locationModel {

        
        if userLocation.location.latitude == 0.0 {
            return locationModel(location: (Locator.shared.location?.coordinate)!, Range: 10000, zoom: 18)

        }else{
            return userLocation

        }
    }
    
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if SkillsTextfield == textField {
            let frame = CGRect(x: 0, y:dalBaseView.screenHeight-200, width: dalBaseView.screenWidth, height: 200)
            let dalSelection = dalBaseView(frame: frame,storyBoard: "dalSelection")
            let vc = dalSelection.getViewController() as! dalSelection
            vc.sectionWithSkills = sectionWithSkills
            vc.delgate = self
            vc.dataSource = self
            vc.setUP()
            dalSelection.showOnWindos()
            return false
        }else if LocationTextfield == textField{
            let googleMap = dalBaseView(frame:UIScreen.main.bounds,storyBoard: "googleMapVC")
            let vc = googleMap.getViewController() as! googleMapVC
            vc.dataSource = self
            vc.delegate = self
            vc.setUP(loction: [], range: "")
            googleMap.showOnWindos()
            return false
        }
        return true
    }
  
    

}
