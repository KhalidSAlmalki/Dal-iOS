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
        reloadWorkers(n: sectionData)
    }
    

    var section:sectionModel = sectionModel()
    var count:Int = 0

    var workers:[workerModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        collectionView?.register(UINib(nibName: "workerCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)

     
    
        workers = []
    }


    func getSectionID(with skillID:String) -> String{
      let sections = applicationDelegate.sections
        print("getSectionID",sections)
        let index = sections.index(where: {$0.skills.contains(where: {$0.id == skillID})})
        
        guard index != nil else {
            return ""
        }
        
        return sections[index!].id
    }
    @objc func reloadWorkers(n:sectionModel)  {
       
        section = n
        print("seection ID ", section.id)

       
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
                    
                        print("sectionID", sectionID)

                        if sectionID == self.section.id {
                   
                            let aWorker =  applicationDelegate.parseWorkerFirbaseValue(value)
                            print("aWorker", aWorker)

                            if !self.workers.contains(where: {$0.id == aWorker.id} ){
                                    self.workers.append(aWorker)
                              
                                }

                        }

                    }
              
                    self.collectionView?.reloadData()

                
                    }

            
        })

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
    
}
