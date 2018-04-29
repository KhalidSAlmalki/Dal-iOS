//
//  ViewController.swift
//  Dal
//
//  Created by khalid almalki on 4/3/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import UIKit
import CoreLocation
class HomeVC: SectionVC {


    @IBOutlet weak var profileBt: UIBarButtonItem!
    @IBOutlet weak var settingsBt: UIBarButtonItem!
    @IBOutlet weak var PagingView: UIView!
    
    var controllerArray : [UIViewController] = []
    var sectionItems:[sectionModel] = []
    
    var pageMenu : CAPSPageMenu?
    var delegate:DidloadChange?
    
    @IBOutlet var emptyMessage: UILabel!
    
    static var currentLocation = CLLocationCoordinate2D()
    lazy var searchBar:UISearchBar = UISearchBar(frame:CGRect(x: 0, y: 0, width: 200, height: 20))


    @IBAction func refreshBt(_ sender: UIBarButtonItem) {
        print("refreshBt")
        setUP()
        reloadSections()
        reloadHomeBarData()
    }
    
    @IBAction func profileBt(_ sender: Any) {
        
        restAPI.shared.getWorkerDetail(usingUserID: userSessionManagement.isLoginedIn()!) { (currentUser) in
            
            guard !currentUser.id.isEmpty else{
                return
            }
            
               if currentUser.getRole() == .user{
                
                let alert = UIAlertController(title: "Error", message: "You are normal user who will not be able to see his profile , go to setting to be  aworker", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                
                return
                }
            
            let add = dalBaseView(storyBoard: "workerDetailsVC")
            let vc = add.getViewController() as! workerDetailsVC
            vc.setUP()
            add.showOnWindos()

            
        }
      

        
    }

  
    func reloadHomeBarData()  {

        guard userSessionManagement.isLoginedIn() != nil else {
            return
        }
        restAPI.shared.getWorkerDetail(usingUserID: userSessionManagement.isLoginedIn()!) { (currentUser) in


            if var nv =  self.navigationItem.rightBarButtonItems{

                if currentUser.getRole() == .user{
                    if nv.count > 1{
                        nv.remove(at: 0)
                    }
                }else{
                    if nv.contains(where: {$0 == self.profileBt}){
                        nv.append(self.profileBt)

                    }


                }
            }

        }

    }
    
    func reloadSections()  {
        
        
        guard Locator.shared.location?.coordinate != nil else {
            
            let alert = UIAlertController(title: "Ops!!", message: "Something went wrong with locations", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
           
//            Locator.shared.locate { (s) in
//                print(<#T##items: Any...##Any#>)
//            }
            self.present(alert, animated: true, completion: nil)

            return
        }
        if HomeVC.currentLocation.latitude != 0 {
            HomeVC.currentLocation = (Locator.shared.location?.coordinate)!
        }
        self.getSectionBased(location: CLLocation(latitude: HomeVC.currentLocation.latitude, longitude: HomeVC.currentLocation.longitude))
    }
    private func setUP() {

        reloadSections()

        Locator.shared.authorize { (status) in
            
            if status ==  Locator.ResultL.Success {
                
                Locator.shared.locate(callback: { (sta) in
                    if sta == .Success {
                        
                        self.reloadSections()
                       
                        
                        
                   

                    }else{
                      
                     

                        
                    }
                })
            }else{
                
                let alert = UIAlertController(title: "Error", message: "Please enable the current location to show the data", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)

            }
        }
    }
    
    private func registerNewUser(_ phoneNumber: (String)) {
        let id = restAPI.shared.getRandomIDUsingFirBase()
        
        restAPI.shared.ref.child("workers/worker").child(id).setValue(["id":id,"contactNumber":phoneNumber], withCompletionBlock: { (erre, datarec) in
            
            let worker = workerModel(id: id, contactNumber: phoneNumber)
            userSessionManagement.saveUserData(worker: worker)
            self.setUP()
            
        })
    }
    
    override func viewDidLoad() {
         super.viewDidLoad()
        self.view.backgroundColor = UIColor.dalHeaderColor()
        setUpNvaBar()
        
       applicationDelegate.empty.configure(appendIn: self.view, data: emptyStatusData(name: "No skilled worker in current Location !!", image: "location"))
    
        if userSessionManagement.isLoginedIn() == nil {
            let phoneRege = "^(\\([0-9]{3}\\) |[0-9]{3}-)[0-9]{3}-[0-9]{4}$"
            
            let alert:dalalert = dalalert(self,iconImage:UIImage(named: "logo"),textfied:DalTextfieldOption(name: "Phone Number", keyboradType:UIKeyboardType.numbersAndPunctuation, MustHasData: true, MustCkeckRegex: phoneRege))
            
            alert.addAction { (phoneNumber) in
                
                 restAPI.shared.getWorkerDetail(usingPhoneNUmber: phoneNumber) { (worker) in

                    if worker.id.isEmpty{ // if there is no data belog to the phone number
                         self.registerNewUser(phoneNumber)
                        
                    }else{
                        userSessionManagement.saveUserData(worker: worker)
                    }
                    
                      alert.closeView(false)
                    self.setUP()
                }
                

            }
            alert.show()

        }else{
            
            setUP()
        }

        

  
      
        
     }
    
   
    @IBAction func addNewWorker(_ sender: UIBarButtonItem) {
        
        let add = dalBaseView(storyBoard: "addworkerVC")
        let vc = add.getViewController() as! addworkerVC
        vc.vcRequestedBased = .addWorker
        vc.setUp()
        add.showOnWindos()
        
  
    }
    private func getSectionBased(location:CLLocation) {
            applicationDelegate.loading()

        restAPI.shared.get(sectionWithLocation: location) { (sections) in
            self.sectionItems = sections
            
            print(sections)
            self.sectionItems = self.sectionItems.sorted(by: { $0.sort < $1.sort })
            
            guard  self.sectionItems.count != 0  else{
               
                applicationDelegate.Dismissloading()
                
                self.view.addSubview(self.emptyMessage)
                self.emptyMessage.isHidden = true
                self.emptyMessage.center = self.view.center
                return
            }
            applicationDelegate.empty.SSremove()
            self.setUPPagingVC()
            
            self.pageMenu?.sendDelgateMessage()
                applicationDelegate.Dismissloading()
        }
    }
private func setUpNvaBar(){
        
        searchBar.placeholder = "search"
        let leftNavBarButton = UIBarButtonItem(customView:searchBar)
        searchBar.barTintColor = UIColor.dalHeaderColor()
        self.navigationItem.leftBarButtonItems?.append(leftNavBarButton)

        self.navigationController!.navigationBar.barTintColor =  .dalHeaderColor()
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        UIApplication.shared.statusBarStyle = .lightContent
        navigationController!.navigationBar.backgroundColor = .dalHeaderColor()
        navigationController?.navigationBar.isTranslucent = false

    }
private func setUPPagingVC() {
    // Do any additional setup after loading the view, typically from a nib.
    
        let  configuration = CAPSPageMenuConfiguration()
            configuration.menuHeight = 65
            configuration.selectionIndicatorColor = .white
            configuration.scrollMenuBackgroundColor = UIColor.dalHeaderColor()
            configuration.viewBackgroundColor = .white
            configuration.menuItemWidthBasedOnTitleTextWidth = true
    

        pageMenu = CAPSPageMenu(pageMenuDataModel: genreatePageMenuDataModel(), frame: PagingView.frame, configuration: configuration)
        pageMenu?.delegate = self
        self.PagingView.addSubview(pageMenu!.view)
    
}
private func genreatePageMenuDataModel() -> [PageMenuDataModel] {
    
   
    var tempPageMenuDataModel:[PageMenuDataModel] = []
    var index = 0

    for section in  sectionItems {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "WorkerCollectionVC") as! WorkerCollectionVC
        controller.section = section
        controller.count = index
        index+=1
      let dataModel = MenuItemViewDataModel(name: section.name, logo: section.avatar, id: section.id)
                    controller.title = section.name
        tempPageMenuDataModel.append(PageMenuDataModel(controller: controller, MenuItemView: dataModel))
    }
    
    return tempPageMenuDataModel
    
    }
}
extension HomeVC:CAPSPageMenuDelegate{
    
    func didMoveToPage(_ controller: UIViewController, index: Int) {
        
        let worker = controller as! WorkerCollectionVC
        worker.section = sectionItems[index]
        self.delegate = worker
        
        delegate?.viewDidloadChange(With: sectionItems[index])
    }

   
}



