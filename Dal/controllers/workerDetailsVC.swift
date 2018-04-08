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
    var workerDetails:workerModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        
     }

    func setUp(){
        let worker = workerDetails
        name.text = worker?.name
        desc.text = worker?.desc
    //    imageView.dalSetImage(url:(worker?.avatar)!)
    }

    @IBAction func closeBt(_ sender: Any) {
        guard dalbbaseView != nil else {
            return
        }
        dalbbaseView?.dismiss() 
    }
    
    @IBOutlet weak var callBt: UIButton!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
