//
//  SectionCollectionVC.swift
//  Dal
//
//  Created by khalid almalki on 4/3/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import UIKit
import Firebase
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

//    func workerDataDidUpdate(data: [workerModel]) {
//        workers.removeAll()
//        for aWorker in data {
//
//            if aWorker.sectionID[0] == sectionID{
//                self.workers.append(aWorker)
//
//            }
//
//        }
//        self.collectionView?.reloadData()
//    }
    
    @objc func reloadWorkers(n:sectionModel)  {
       
        section = n
        print(section.id)

       
        self.workers.removeAll()
        

        applicationDelegate.ref.child("workers").observeSingleEvent(of: .value, with: { (snap) in

                 for worker in snap.children {
             
                    let section = worker as! DataSnapshot

                    if let sectionID = section.childSnapshot(forPath: "sectionID").value as? [String]{
                        
                      
                        if sectionID.contains(self.section.id) {
                            
                            let value = section.value  as! [String:AnyObject]
                            let aWorker = workerModel(id: convertString(value["id"]) ,
                                                      sectionID: (value["sectionID"] as? [String])!,
                                                      contactNumber: convertString(value["contactNumber"] ) ,
                                                      name: convertString(value["name"] ),
                                                      description: convertString(value["desc"] ),
                                                      avatar: convertString(value["avatar"] ),
                                                      location: value["loc"] as! [Double])
                            self.workers.append(aWorker)
                            
                            
                            print(aWorker.name)
                            
                            self.collectionView?.reloadData()
                        }
                    }
                
                    }
            
        })

//        print( self.workers.count, )
        
      //  getSectionUser()
    }
    @objc func getSectionUser()  {
        
    
       
        

        print("start fetching in section name",section.name)
        applicationDelegate.getworkers(completion: { data in
            print("get something  ")

               self.workers = data
            for aWorker in data {
                
                if aWorker.sectionID[0] == self.section.id{
                    self.workers.append(aWorker)
                    
                }
                
            }
            
            print("finish fetching",self.workers.count)
            self.collectionView?.reloadData()
            
        })

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
        cell.address.text = "\(worker.location[0])"
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
