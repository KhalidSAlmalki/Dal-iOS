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
    let listType = ["Phone Number","Whats Up","Email"]
    
    var sectionWithSkills = [sectionModel]()
    
    var selectedSkills = [sectionModel]()

    var selectedSkillsID = ""
    
    var userLocation = locationModel()
    
    let imagePicker = UIImagePickerController()

    var userID = ""
    @IBOutlet var pickerViewContacts: UIPickerView!
    
    var vcRequestedBased:addworkerRequestType = .addWorker
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SkillsTextfield.delegate = self
        LocationTextfield.delegate = self
        contactTextfield.delegate = self
        
        sectionWithSkills = applicationDelegate.sectionsWithSkills
       
        setUpPicker()
        
        setUpImagePicker()
        
        if vcRequestedBased == .becomeWorker {
            let userDefaults = UserDefaults.standard

            if let decoded  = userDefaults.object(forKey: "currentUser") as? Data{
                let currentUser = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! workerModel
                let rol =  currentUser.getRole()
                if rol == .user{
                   userID = currentUser.id
                    self.contactTextfield.text = currentUser.contactNumber

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

            
          
            let userID_ = applicationDelegate.getRandomIDUsingFirBase()
            
            if vcRequestedBased == .becomeWorker{
                par["id"] = self.userID

            }else{
                par["id"] = userID_

            }
            
          
            uploadImage(userID, data) {(url) in
                
                print("callBack")
                if !url.isEmpty{
                    par["avatar"] = url
                    applicationDelegate.ref.child("workers/worker").child(par["id"] as! String).setValue(par)
                    sender.loadingIndicator(false)

                }
               
                
            }
        
            

         }
    }
    
    @objc func presentImageViewPicker()  {
        print("presentImageViewPicker")
        
        let actionSheet = UIAlertController(title: "Choose Option", message: "", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "OK", style: .default, handler: { (ac) in
            
            print("sdsd")
        }))

        guard dalbbaseView != nil else {
            return
        }

        applicationDelegate.window2?.isHidden = false
        applicationDelegate.window2?.rootViewController?.present(imagePicker, animated: true, completion: nil)
   

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
        
        applicationDelegate.window2?.rootViewController?.dismiss(animated: true, completion: nil)
        applicationDelegate.window2?.isHidden = true

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
                "coverageRange":userLocation.Range,
                "contactMethod":typeTextfield.text!,
                "desc":userLocation.Range,
                "id":"",
                "location":"\(userLocation.location.latitude);\(userLocation.location.longitude)",
                "phoneNumber":contactTextfield.text!,
                "skills":self.selectedSkillsID,
                "status":"active"
                                ]
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
        return selectedSkills
    }
    
    func dalSelectionDidSelected(skills: [sectionModel], selectedSkills: String) {
        
        self.selectedSkills = skills
        
        // geting skills name
        var name = ""
        for s in skills {
            name+=s.getSkillsNameAsString()
        }
        name.removeLast()
        SkillsTextfield.text = name
        
        // geeting skils id
        self.selectedSkillsID = selectedSkills
        
        
    }
    
    func googleMapDataDidSelected(locationModel: locationModel) {
        
        userLocation = locationModel
     userLocation.getCountryAndCity(completion: { (country, city) in
        self.LocationTextfield.text = "\(country), \(city); range \(self.userLocation.Range) km"
        })
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
