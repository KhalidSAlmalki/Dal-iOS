//
//  workerDetailsVC.swift
//  Dal
//
//  Created by khalid almalki on 4/7/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import UIKit
class workerDetailsVC: baseViewController,UIPickerViewDelegate,UIPickerViewDataSource {


    @IBOutlet var PickerChangeStatus: UIPickerView!
    let pickerContainer = UIView()
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var skill: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var callBt: UIButton!
    
    
    let StatusdataSource = ["active","busy"]
    let PROFILETAG = 0
    let WORKERDETALS = 1

    var worker = workerModel()

 
    func setUP()  {
   
        self.setUpPicker()
        userSessionManagement.getLoginedUserData { (worker) in
            
            if worker?.getRole() == .worker{
                
                self.setUp(worker: worker!, modeType: .profile)

            }
        }
    }
    
    fileprivate func checkWorkerStatus( _ modeType: modeType) {
        switch self.worker.status {
            
        case .active:
            if modeType == .workerDrtails{
                callBt.isEnabled = true
                callBt.setTitle("Contact", for: .normal)
            }
            PickerChangeStatus.selectRow(0, inComponent: 0, animated: true)
            statusImageView.image = UIImage(named: "icAvailable")
            
        case .busy:
            if modeType == .workerDrtails{
                callBt.isEnabled = false
                callBt.setTitle("unavailable", for: .disabled)
            }
            PickerChangeStatus.selectRow(1, inComponent: 0, animated: true)

            statusImageView.image = UIImage(named: "icBusy")
            
        default:
            statusImageView.isHidden = true
            
        }
    }
    
    func setUp(worker:workerModel,modeType:modeType){
        
        let sectioins = sectionsModel()
        self.worker = worker
        sectioins.add(section: (worker.skillIDs))
        
        name.text = worker.name
        
        desc.text = worker.desc
        
         
    

        self.skill.text = sectioins.getAllSkillDesc()
        
        worker.getRates { (avarage) in
            
            self.ratingView.rating = avarage
            
        }
        
        checkWorkerStatus(modeType)
        
        
        if modeType == .profile{
        
            callBt.tag = PROFILETAG
            callBt.setTitle("Change Status", for: .normal)
        }else{
            callBt.tag = WORKERDETALS
            callBt.setTitle(worker.contactMethod, for: .normal)

        }
        
    
        
    
        let img = worker.avatar
            
            imageView.dalSetImage(url: img)
        
    }
  

    @IBAction func callChangeStatusBt(_ sender: UIButton) {
        
        if sender.tag == PROFILETAG {
            
            print("profile")
            pickerContainer.isHidden = false
            
        }else{
     
           let m =  worker.contactMethod
            
            print(m)
            var url = ""
            
            if m == "Whatsapp"{
                url = "whatsapp://send?phone=1"
                
            }
            else if m == "Telegram"{
                url = "tg://msg?to=1"
            }
            else if m == "Calling"{
                url = "tel://"
            }
            else if m == "Texting"{
                url = "sms:"
            }
            url += cleanPhoneNumber(worker.contactNumber)

            print(url)

            if let urlFromStr = URL(string: url) {
                
                if UIApplication.shared.canOpenURL(urlFromStr) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(urlFromStr, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(urlFromStr)
                    }
                }
            }

        }
    }
    
    @IBAction func closeBt(_ sender: Any) {
        guard dalbbaseView != nil else {
            return
        }
        dalbbaseView?.dismiss() 
    }
    
    
    //MARK: - picker
    func setUpPicker() {
        
        var pickerRect = UIScreen.main.bounds
        pickerContainer.isHidden = true

        pickerRect.size.height = 300
        pickerRect.origin.x = -15
        pickerRect.origin.y = UIScreen.main.bounds.height-pickerRect.height

        pickerContainer.frame = pickerRect
        self.view.addSubview(pickerContainer)
        PickerChangeStatus.frame = CGRect(x: 0, y: 40, width: pickerRect.width, height: 250)
        PickerChangeStatus.delegate = self
        PickerChangeStatus.dataSource = self
        PickerChangeStatus.backgroundColor = .dalwhite
        self.pickerContainer.addSubview(PickerChangeStatus)
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: pickerRect.width, height: 50))
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.dalHeaderColor()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: " Done   ", style: UIBarButtonItemStyle.plain, target: self, action: #selector(pickerViewContactsDoneBt))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "  Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(pickerViewContactsCancelBt))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.becomeFirstResponder()
        
        pickerContainer.addSubview(toolBar)
    }
    
    @objc func pickerViewContactsDoneBt() {
        print("profile")

        let selectedValue = self.StatusdataSource[PickerChangeStatus.selectedRow(inComponent: 0)]
        

        guard !worker.id.isEmpty else {
            return
        }
        
        restAPI.shared.updateStatus(userID: worker.id, status: selectedValue) { (_) in
            
            if selectedValue == "active"{
                
                self.worker.status = .active
            }else{
                self.worker.status = .busy
            }
            
            self.checkWorkerStatus(.profile)
            
            self.pickerContainer.isHidden = true
        }


    }
    @objc func pickerViewContactsCancelBt() {
        
        
        pickerContainer.isHidden = true
        print("profile")

    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return StatusdataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return StatusdataSource[row]
    }
    
    
    func cleanPhoneNumber(_ str: String) -> String {
        struct Constants {
            static let validChars = Set("1234567890".characters)
        }
        return String(str.characters.filter { Constants.validChars.contains($0) })
    }

    
 

}
