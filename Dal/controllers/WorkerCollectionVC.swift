//
//  SectionCollectionVC.swift
//  Dal
//
//  Created by khalid almalki on 4/3/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class WorkerCollectionVC: UICollectionViewController,UICollectionViewDelegateFlowLayout,dataFeederProtocol {

    var sectionID:String = ""
   lazy var  width = (Double((self.collectionView?.frame.size.width )!-30))
    var workers:[workerModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(sectionID)
        applicationDelegate.delgate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        collectionView?.register(UINib(nibName: "workerCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)

        
        getSectionUser()
    }

    func workerDataDidUpdate(data: [workerModel]) {
        workers.removeAll()
        for aWorker in data {

            if aWorker.sectionID[0] == sectionID{
                self.workers.append(aWorker)
                
            }
            
        }
        self.collectionView?.reloadData()
    }
    func getSectionUser()  {
        
        applicationDelegate.getworkers()
//         applicationDelegate.ref.child("workers").observeSingleEvent(of: .value, with: { (snapshot) in
//
////
////            for section in snapshot.children {
////                let snap = section as! DataSnapshot
////                let key = snap.key
////                let value = snap.value  as! [String:AnyObject]
////
////                self.sections.append(sectionModel(id: key, name: convertString(value["name"] ) , avatar:convertString(value["avatar"]), sort:convertInt(value["sort"])))
////            }
//
//
//        })
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
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection
        section: Int) -> CGSize {
        
      
        return CGSize(width: width, height: 65)
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.workers.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
        return cell
    }

    // MARK: UICollectionViewDelegate

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
