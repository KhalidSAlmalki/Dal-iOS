//
//  ViewController.swift
//  Dal
//
//  Created by khalid almalki on 4/3/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import UIKit
import Parchment

class HomeVC: SectionVC {


    @IBOutlet weak var PagingView: UIView!
    

    var sectionItems:[sectionModel] = []
    let pagingViewController = PagingViewController<sectionItem>()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        applicationDelegate.delgate = self
        
        setUPPagingVC()
       // setUPPagingVC()
     }



private func setUPPagingVC() {
    // Do any additional setup after loading the view, typically from a nib.
    
    
    pagingViewController.menuItemClass = SectionPagingCell.self
    pagingViewController.menuItemSize = .sizeToFit(minWidth: 80, height: 80)
    addChildViewController(pagingViewController)
    PagingView.addSubview(pagingViewController.view)
    PagingView.constrainToEdges(pagingViewController.view)
    pagingViewController.didMove(toParentViewController: self)
    
    // Set our custom data source.
    pagingViewController.dataSource = self
    
    
    
}
}
extension HomeVC:sectionProtocol{
    func sectionDataDidUpdate(data: [sectionModel]) {
        print("sectionDataDidUpdate")
        sectionItems = data
        self.sectionItems = self.sectionItems.sorted(by: { $0.sort < $1.sort })
        print(sectionItems)
        pagingViewController.reloadData()
        pagingViewController.select(pagingItem: (sectionItems.first?.SectionItem)!)
    }
    
  
    
    
}
extension HomeVC: PagingViewControllerDataSource {
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, viewControllerForIndex index: Int) -> UIViewController {
     
        return sectionVC(index: sectionItems[index].name)
    }
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, pagingItemForIndex index: Int) -> T {
        let s = sectionItems[index]
        return s.SectionItem as! T
    }
    
    func numberOfViewControllers<T>(in: PagingViewController<T>) -> Int{
        return sectionItems.count
    }
    
}
