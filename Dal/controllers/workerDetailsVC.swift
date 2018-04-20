//
//  workerDetailsVC.swift
//  Dal
//
//  Created by khalid almalki on 4/7/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import UIKit

class workerDetailsVC: baseViewController {

    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var skill: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var callBt: UIButton!

    var workerDetails:workerModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        
     }

    private func getWorkerSkillName(_ worker: workerModel?) {
        var skillsName = ""
        if let spiltID = worker?.skillIDs.split(separator: ";"){
            
            for ids in spiltID{
                for id in ids{
                    
                    for s in applicationDelegate.sections{
                        
                        if let sm = s.getSkillModel(by: id){
                            print(sm)
                            skillsName += sm.name
                            skillsName += ","
                            
                        }
                    }
                    
                }
                skillsName.removeLast()
                skill.text = skillsName
            }
        }
    }
    
    func setUp(){
        let worker = workerDetails
        name.text = worker?.name
        
        desc.text = worker?.desc
        
        
        
        getWorkerSkillName(worker)
        

        
       // skill.text = applicationDelegate.get
        if let status = worker?.status{
            
            print(status)

        }
    
        if let img = worker?.avatar {
            
            imageView.dalSetImage(url: img)
        }
    }

    @IBAction func closeBt(_ sender: Any) {
        guard dalbbaseView != nil else {
            return
        }
        dalbbaseView?.dismiss() 
    }
    
 

}
