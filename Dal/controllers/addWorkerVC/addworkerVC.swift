//
//  addworkerVC.swift
//  Dal
//
//  Created by khalid almalki on 4/11/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import UIKit
enum addworkerRequestType {
    case becomeWorker
    case addWorker
    case UpdateWorkerData
}
class addworkerVC: baseViewController,UITextFieldDelegate, dalSelectionDataSource,dalSelectionDelgate,googleMapDataSource,googleMapDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet weak var descTextfield: UITextField!
    @IBOutlet weak var SkillsTextfield: UITextField!
    @IBOutlet weak var LocationTextfield: UITextField!
    @IBOutlet weak var contactTextfield: UITextField!
    @IBOutlet weak var typeTextfield: UITextField!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    // list of  contact type
    let listType = ["Whatsapp","Telegram","Calling","Texting"]
    
    var sectionWithSkills = [sectionModel]()
    
    var selectedSkills = sectionsModel()

    var selectedSkillsID = ""
    
    var userLocation = locationModel()
    
    let imagePicker = UIImagePickerController()

    var userID = ""
    @IBOutlet var pickerViewContacts: UIPickerView!
    
    var vcRequestedBased:addworkerRequestType = .addWorker

    @objc func dismissKeyboard(){
        
        self.view.endEditing(true)
        
        self.view.endEditing(false)

    }
    func setUp()  {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    
        self.view.addGestureRecognizer(tap)

        SkillsTextfield.delegate = self
        LocationTextfield.delegate = self
        contactTextfield.delegate = self
        nameTextfield.delegate = self
        descTextfield.delegate = self
        
        sectionWithSkills = applicationDelegate.sectionsWithSkills
        
        setUpPicker()
        
        setUpImagePicker()
        
        if vcRequestedBased == .becomeWorker {
            
            userSessionManagement.getLoginedUserData { (currentUser) in
                
                self.contactTextfield.text = currentUser?.contactNumber
                self.userID = (currentUser?.id)!
                
            }
        }else if vcRequestedBased == .UpdateWorkerData{
            
            // populate data here
            
            selectedSkills = sectionsModel()
            
            // get worker input
            var _worker  = workerModel()
            userSessionManagement.getLoginedUserData { (worker) in
                
                if worker != nil{
                    
                    _worker = worker!
                    
                    self.selectedSkills.add(section: _worker.skillIDs)
                    self.imageView.dalSetImage(url: _worker.avatar)
                    self.nameTextfield.text = _worker.name
                    self.contactTextfield.text = _worker.contactNumber
                    self.userID = _worker.id
                    self.typeTextfield.text = _worker.contactMethod
                    self.userLocation = _worker.location
                    self.descTextfield.text = _worker.desc
                    self.SkillsTextfield.text = self.selectedSkills.getAllSkillDesc()
                    _worker.location.getDesc(completion: { (dec) in
                       self.LocationTextfield.text = dec
                    })
                    
                    
                    
                    
                }
            }
            
            
        }
        
    }
    private func uploadImage(_ imageID: String, _ data: Data?, urlWith:@escaping (String) -> Void) {
        // Create a reference to the file you want to upload
        
        let imageRef = applicationDelegate.storageRef.child("Avatars/\(imageID).jpg")
        
        imageRef.putData(data!, metadata: nil) { (metadata, error) in
            
            guard metadata != nil else {
                return
            }
            
            imageRef.downloadURL { (url, err) in
                
                if let urll = url?.absoluteString{
                    urlWith(urll)
                }else{
                    
                    urlWith("")
                }
                
            }
            
        }
    }
    
    @IBAction func submitBt(_ sender: UIButton) {
        
        if validateUserInput() {
            sender.loadingIndicator(true)
            var par = getUserInputs()
            // Data in memory
            
            let data = UIImagePNGRepresentation(imageView.image!)

            
          
            if vcRequestedBased == .becomeWorker ||  vcRequestedBased == .UpdateWorkerData{
                par["id"] = self.userID

            }else{
                par["id"] = applicationDelegate.getRandomIDUsingFirBase()
                

            }
            
          
            uploadImage(userID, data) {(url) in
                
                if !url.isEmpty{
                    par["avatar"] = url
                    applicationDelegate.ref.child("workers/worker").child(par["id"] as! String).setValue(par)
                    sender.loadingIndicator(false)

                }
               
                
            }
        
            

         }
    }
    
    @objc func presentImageViewPicker()  {
        
        let actionSheet = UIAlertController(title: "Choose Option", message: "", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "OK", style: .default, handler: { (ac) in
            
        }))

        guard dalbbaseView != nil else {
            return
        }

        applicationDelegate.dalPresent(vc: imagePicker, animated: true, completion: nil)

    }
    func setUpImagePicker(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentImageViewPicker))
        
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        imagePicker.delegate = self
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary

    }
    
    func dismissImagePicker() {
        
       applicationDelegate.dalDismiss(animated: true, completion: nil)

    }
    
    
    
    // MARK: - UIImagePickerControllerDelegate Methods

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismissImagePicker()
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
        }
        
        dismissImagePicker()

    }
  
    func validateUserInput() -> Bool  {
        
        if (LocationTextfield.text?.isEmpty)! || (contactTextfield.text?.isEmpty)!
        || (nameTextfield.text?.isEmpty)! || (SkillsTextfield.text?.isEmpty)!
        || (descTextfield.text?.isEmpty)! {
            let alert = UIAlertController(title: "Error", message: "plaese check your inputs and fill the missing value", preferredStyle: .alert)
            
            
            alert.addAction(UIAlertAction(title: "done", style: .cancel, handler: { (r) in
                applicationDelegate.dalDismiss(animated: true, completion: nil)

            }))
        
            applicationDelegate.dalPresent(vc: alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func getUserInputs() -> [String:Any] {
        
        return ["name":nameTextfield.text!,
                "avatar":"",
                "contactMethod":typeTextfield.text!,
                "desc":descTextfield.text!,
                "id":"",
                "location":["latitude":userLocation.location.latitude,
                            "longitude":userLocation.location.longitude,
                            "range":userLocation.Range,"zoom":userLocation.zoom],
                "contactNumber":contactTextfield.text!,
                "skills":self.selectedSkillsID,
                "status":"active"]
    }
    func setUpPicker() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.dalHeaderColor()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(pickerViewContactsDoneBt))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(pickerViewContactsCancelBt))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        typeTextfield.inputView = pickerViewContacts
        typeTextfield.inputAccessoryView = toolBar
    }
    
    @objc func pickerViewContactsDoneBt() {
        
        self.typeTextfield.text = listType[pickerViewContacts.selectedRow(inComponent: 0)]
        typeTextfield.resignFirstResponder()
    }
    @objc func pickerViewContactsCancelBt() {
        typeTextfield.resignFirstResponder()

    }
   

    //MARK -dsd
    
    

    @IBAction func closeBt(_ sender: Any) {
       dismissDalBaseView()
     
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listType.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return listType[row]
    }
    
    func dalSelectionSelectedSkills() -> [sectionModel] {
        return selectedSkills.getSections()
    }
    
    func dalSelectionDidSelected(skills: [sectionModel], selectedSkills: String) {
        
        self.selectedSkills.add(listOf: skills)
        
        // geting skills name
    
        SkillsTextfield.text = self.selectedSkills.getAllSkillDesc()
        
        // geeting skils id
        self.selectedSkillsID = selectedSkills
        
        
    }
    
    func googleMapDataDidSelected(locationModel: locationModel) {
        
        userLocation = locationModel
     userLocation.getCountryAndCity(completion: { (country, city) in
        self.LocationTextfield.text = "\(country), \(city); range \(self.userLocation.Range.clean) miles"
        })
    }
    
    func googleMapDataSourceUserLocation() -> locationModel {

        
        if userLocation.location.latitude == 0.0 {
            return locationModel(location: (Locator.shared.location?.coordinate)!, Range: 8.04672, zoom: 18)

        }else{
            return userLocation

        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if SkillsTextfield == textField {
            self.dismissKeyboard()
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
            self.dismissKeyboard()

            let googleMap = dalBaseView(frame:UIScreen.main.bounds,storyBoard: "googleMapVC")
            let vc = googleMap.getViewController() as! googleMapVC
            vc.dataSource = self
            vc.delegate = self
            vc.setUP()
            googleMap.showOnWindos()
            return false
        }
        return true
    }
  
    

}
