//
//  SectionCollectionVC.swift
//  Dal
//
//  Created by khalid almalki on 4/3/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
private let reuseIdentifier = "Cell"

class WorkerCollectionVC: UICollectionViewController,UICollectionViewDelegateFlowLayout,DidloadChange {
    func viewDidloadChange(With sectionData: sectionModel) {
        print("viewDidloadChange")
        reloadWorkers(n: sectionData)
    }
    

    var section:sectionModel = sectionModel()
    var count:Int = 0

    var workers:[workerModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        print("viewDidLoad",section)
        // Register cell classes
        collectionView?.register(UINib(nibName: "workerCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)

     
    
        workers = []
    }


    func getSectionID(with skillID:String) -> String{
      let sections = applicationDelegate.sections
        
        let index = sections.index(where: {$0.skills.contains(where: {$0.id == skillID})})
        
        guard index != nil else {
            return ""
        }
        
        return sections[index!].id
    }
    @objc func reloadWorkers(n:sectionModel)  {
       
        section = n
        print(section.id)

       
        self.workers.removeAll()
        

        applicationDelegate.ref.child("workers/worker").observeSingleEvent(of: .value, with: { (snap) in

                 for worker in snap.children {
             
                    let aworker = worker as! DataSnapshot
                    
                    let value = aworker.value  as! [String:AnyObject]

                    let skillsIDstring = convertString(value["skills"])
                    let skillsID = applicationDelegate.convertToAarry(skillsIDstring)
                    
                    
                    // get the detall f skilla where its belongs
                    for id in skillsID{
                        
                    let sectionID = self.getSectionID(with: id)
                    
                        
                        if sectionID == self.section.id {
                   
                            let aWorker =  applicationDelegate.parseWorkerFirbaseValue(value)
                            
                            if !self.workers.contains(where: {$0.id == aWorker.id} ){
                                                              self.workers.append(aWorker)
                              
                                        }

                        }
                        
                    }
              
                    
                
                    }
                                      self.collectionView?.reloadData()

            
        })

//        print( self.workers.count, )
        
      //  getSectionUser()
    }
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource
//    func collectionView(_ collectionView: UICollectionView, layout
//        collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection
//        section: Int) -> CGSize {
//
//
//        return CGSize(width: self.view.frame.width, height: 65)
//    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.workers.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! workerCell
    
        let worker = workers[indexPath.row]
        cell.name.text = worker.name
//        cell.address.text = "\(worker.location[0])"
        cell.skill.text = section.name
        cell.imageView.dalSetImage(url: worker.avatar)
        
        // Configure the cell
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let profile = dalBaseView(storyBoard: "workerDetailsVC")
        let vc =   profile.getViewController() as! workerDetailsVC
        vc.workerDetails = workers[indexPath.row]
        vc.setUp()
        profile.showOnWindos()
        
        
        
    }
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
