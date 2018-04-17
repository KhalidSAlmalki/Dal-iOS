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


    @IBOutlet weak var PagingView: UIView!
    
    var controllerArray : [UIViewController] = []
    var sectionItems:[sectionModel] = []
    
    var pageMenu : CAPSPageMenu?
    var delegate:DidloadChange?
    
    
    var currentLocation = CLLocationCoordinate2D()
    lazy var searchBar:UISearchBar = UISearchBar(frame:CGRect(x: 0, y: 0, width: 200, height: 20))


    
    override func viewDidLoad() {
         super.viewDidLoad()
        
        
//        let alert:dalalert = dalalert(self,text: "khalid")
//        alert.show()
        
         self.view.backgroundColor = UIColor.dalHeaderColor()
         setUpNvaBar()
         getSectionBased(location: "")
        
        Locator.shared.authorize { (status) in
            
            if status ==  Locator.ResultL.Success {
                
                Locator.shared.locate(callback: { (sta) in
                    if sta == .Success {
                        
                self.currentLocation = (Locator.shared.location?.coordinate)!

                    }
                })
            }
        }
        
      
        
     }

    @IBAction func addNewWorker(_ sender: UIBarButtonItem) {
        
        let add = dalBaseView(storyBoard: "addworkerVC")
        add.showOnWindos()
        
  
    }
    private func getSectionBased(location:String) {
        
        applicationDelegate.get(sectionWithLocation: location) { (sections) in
            print("sectionWithLocation",sections)
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



