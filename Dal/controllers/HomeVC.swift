//
//  ViewController.swift
//  Dal
//
//  Created by khalid almalki on 4/3/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import UIKit
class HomeVC: SectionVC {


    @IBOutlet weak var PagingView: UIView!
    var pageMenu : CAPSPageMenu?
    var controllerArray : [UIViewController] = []

    var sectionItems:[sectionModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        applicationDelegate.delgate = self
        self.view.backgroundColor = UIColor.dalHeaderColor()
        setUPPagingVC()
       // setUPPagingVC()
     }



private func setUPPagingVC() {
    // Do any additional setup after loading the view, typically from a nib.
    

    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let controller = storyboard.instantiateViewController(withIdentifier: "WorkerCollectionVC")
    
    controller.title = "SAMPLE TITLE hghg"
    controllerArray.append(controller)
//    
//    let parameters: [CAPSPageMenuOption] = [
//        .menuItemSeparatorWidth(0.0),
//        .scrollMenuBackgroundColor(UIColor.dalLightColor()),
//        .viewBackgroundColor(UIColor.dalHeaderColor()),
//        .bottomMenuHairlineColor(UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 0.1)),
//        .selectionIndicatorColor(UIColor.white),
//        .menuMargin(10.0),
//        .menuHeight(50),
//        .selectedMenuItemLabelColor(UIColor.white),
//        .unselectedMenuItemLabelColor(UIColor(red: 76.0/255.0, green: 76.0/255.0, blue:76.0/255.0, alpha: 1)),
//        .menuItemFont(UIFont(name: "HelveticaNeue-Medium", size: 12.0)!),
//        .useMenuLikeSegmentedControl(false),
//        .menuItemSeparatorRoundEdges(true),
//        .selectionIndicatorHeight(3.0),
//        .menuItemSeparatorPercentageHeight(0.0),
//        .menuItemWidthBasedOnTitleTextWidth(true)
//    ]
        let  configuration = CAPSPageMenuConfiguration()
            configuration.menuHeight = 65
            configuration.selectionIndicatorColor = .white
            configuration.scrollMenuBackgroundColor = UIColor.dalHeaderColor()
            configuration.viewBackgroundColor = .white
            configuration.menuItemWidthBasedOnTitleTextWidth = true
    
    var o:[PageMenuDataModel] = []
    o.append(PageMenuDataModel(controller: controller, MenuItemView: MenuItemViewDataModel(name: "khalid", logo: "http://servstore.net/images/ScreenBeautiful/ScreenBeautiful.png") ))
    o.append(PageMenuDataModel(controller: controller, MenuItemView: MenuItemViewDataModel(name: "khalid almalki", logo: "http://servstore.net/images/ScreenBeautiful/ScreenBeautiful.png") ))

    o.append(PageMenuDataModel(controller: controller, MenuItemView: MenuItemViewDataModel(name: "khalid almalki 3", logo: "http://servstore.net/images/ScreenBeautiful/ScreenBeautiful.png") ))


    pageMenu = CAPSPageMenu(pageMenuDataModel: o, frame: PagingView.frame, configuration: configuration)
    
    self.PagingView.addSubview(pageMenu!.view)
    
}
}
extension HomeVC:dataFeederProtocol{
    func sectionDataDidUpdate(data: [sectionModel]) {
        print("sectionDataDidUpdate")
        sectionItems = data
        self.sectionItems = self.sectionItems.sorted(by: { $0.sort < $1.sort })


    }
    
  
    
    
}


