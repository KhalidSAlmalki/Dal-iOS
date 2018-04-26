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
    
    
    static var currentLocation = CLLocationCoordinate2D()
    lazy var searchBar:UISearchBar = UISearchBar(frame:CGRect(x: 0, y: 0, width: 200, height: 20))


    @IBAction func profileBt(_ sender: Any) {
        
        let add = dalBaseView(storyBoard: "workerDetailsVC")
        let vc = add.getViewController() as! workerDetailsVC
            vc.setUP()
        add.showOnWindos()

        
    }

    
    private func setUP() {

        
        
        Locator.shared.authorize { (status) in
            
            if status ==  Locator.ResultL.Success {
                
                Locator.shared.locate(callback: { (sta) in
                    if sta == .Success {
                        
                        HomeVC.currentLocation = (Locator.shared.location?.coordinate)!
                        
                        self.getSectionBased(location: CLLocation(latitude: HomeVC.currentLocation.latitude, longitude: HomeVC.currentLocation.longitude))

                    }
                })
            }else{
//                let alert = UIAlertController()
//                alert.addAction(UIAlertAction(title: "got it", style: .alert, handler: nil))
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
        

    
        
        if userSessionManagement.isLoginedIn() == nil {
            let phoneRege = "^(\\([0-9]{3}\\) |[0-9]{3}-)[0-9]{3}-[0-9]{4}$"
            
            let alert:dalalert = dalalert(self,iconImage:UIImage(named: "logo"),textfied:DalTextfieldOption(name: "Phone Number", keyboradType:UIKeyboardType.decimalPad, MustHasData: true, MustCkeckRegex: phoneRege))
            
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

        

        
        if !userSessionManagement.IsLogined.isEmpty{
            
            restAPI.shared.getWorkerDetail(usingUserID: userSessionManagement.isLoginedIn()!) { (currentUser) in
                
                if currentUser.getRole() == .user{
                    self.navigationItem.rightBarButtonItems?.remove(at: 0)
                }else{
                    self.navigationItem.rightBarButtonItems?.append(self.profileBt)
                }
            }
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
        
        restAPI.shared.get(sectionWithLocation: location) { (sections) in
            self.sectionItems = sections
            
            self.sectionItems = self.sectionItems.sorted(by: { $0.sort < $1.sort })
            
            guard  self.sectionItems.count != 0  else{
                return
            }
            self.setUPPagingVC()
            
            self.pageMenu?.sendDelgateMessage()
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



