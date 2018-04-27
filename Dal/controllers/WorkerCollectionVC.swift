//
//  SectionCollectionVC.swift
//  Dal
//
//  Created by khalid almalki on 4/3/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
private let reuseIdentifier = "Cell"

class WorkerCollectionVC: UICollectionViewController,UICollectionViewDelegateFlowLayout,DidloadChange {
    
    func viewDidloadChange(With sectionData: sectionModel) {
        reloadWorkers(n: sectionData)
    }
    

    var section:sectionModel = sectionModel()
    var count:Int = 0

    var workers:workersModel = workersModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        collectionView?.register(UINib(nibName: "workerCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)

        collectionView?.backgroundColor = UIColor.dalwhite
        
        

        workers = workersModel()
    }


    func getSectionID(with skillID:String) -> String{
      let sections = restAPI.shared.sections.getSections()

        let index = sections.index(where: {$0.skills.contains(where: {$0.id == skillID})})
        
        guard index != nil else {
            return ""
        }
        
        return sections[index!].id
    }
    
    
    private func addIntoWorkers(_ _aworker: workerModel) {
        
        let loc = CLLocation(latitude: HomeVC.currentLocation.latitude, longitude: HomeVC.currentLocation.longitude)

        
        for _skillID in _aworker.skillIDs{
            
            let section_ID = self.getSectionID(with: _skillID)
            
            // if the user belomn to current section add
            if section_ID == self.section.id {
                
                
                self.workers.add(worker: _aworker, currentlocation:loc)
                
            }
            
            
        }
    }
    
    @objc func reloadWorkers(n:sectionModel)  {
       
        section = n

       
        self.workers = workersModel()

        restAPI.shared.ref.child("workers/worker").observe(DataEventType.childChanged, with: { (changed) in
            let _aworker = workerModel(data: changed.value as! [String : AnyObject])
            
            
            self.workers.remove(workerID: _aworker.id)
            self.addIntoWorkers(_aworker)
            
            
            self.collectionView?.reloadData()
        })
        
 
        

         restAPI.shared.ref.child("workers/worker").observeSingleEvent(of: .value, with: { (snap) in


            
            let _workers = snap.value as! [String:AnyObject]
            
            for _worker in _workers{
                
                // getting aworker
                
                let _worker_ = _worker.value as! [String:AnyObject]
                
                let _aworker = workerModel(data: _worker_)
                
                
                    self.addIntoWorkers(_aworker)
                
            }
            self.collectionView?.reloadData()

        })
            


    }
   
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return CGSize(width: collectionView.frame.width, height: 90)
        
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items

  
        return self.workers.getWorkerList().count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! workerCell
    
        let worker = self.workers.getWorkerList()[indexPath.row]

        cell.setUP(worker, at: section)
   
        // Configure the cell
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let alert = UIAlertController(title: "Select One", message: "Rate a worker when you finsh or see a worker details", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "See Profile", style: .destructive, handler: { (Profile) in
            
                    let profile = dalBaseView(storyBoard: "workerDetailsVC")
                    let vc =   profile.getViewController() as! workerDetailsVC
            vc.setUp(worker: self.workers.getWorkerList()[indexPath.row], modeType: .workerDrtails)
                    profile.showOnWindos()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Rate", style: .default, handler: { (Rate) in
            
                let Rate = dalBaseView(storyBoard: "ratingVC")
                let vc =   Rate.getViewController() as! ratingVC
                vc.setUP(worker: self.workers.getWorkerList()[indexPath.row])
                Rate.showOnWindos()

        }))
        
        alert.addAction(UIAlertAction(title: "Cnacel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        

        
        
        
    }
    
}
