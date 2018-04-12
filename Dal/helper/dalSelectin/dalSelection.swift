//
//  dalSelection.swift
//  Dal
//
//  Created by khalid almalki on 4/11/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import UIKit


class dalSelection: baseViewController,UITableViewDelegate,UITableViewDataSource {
    

    var sectionWithSkills = [sectionModel]()
    
    @IBOutlet weak private var secondTableView: UITableView!
    @IBOutlet weak private var firstTableView: UITableView!
    
    private var selectedIndexs = [String]()
    func setUP() {
        firstTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        secondTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        firstTableView.reloadData()
        secondTableView.reloadData()
        firstTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)


    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == firstTableView{
            return self.sectionWithSkills.count
        }else if tableView == secondTableView{
            guard firstTableView.indexPathForSelectedRow?.row != nil else{
                return 0
            }
    return
        
        self.sectionWithSkills[(firstTableView.indexPathForSelectedRow?.row)!].skills.count

        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if tableView == self.firstTableView {
            cell.textLabel?.text = sectionWithSkills[indexPath.row].name
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none

            return cell
        }
        
        let data = sectionWithSkills[(firstTableView.indexPathForSelectedRow?.row)!]
        cell.textLabel?.text = data.skills[indexPath.row].name
        cell.accessoryType = .checkmark
        
        if selectedIndexs.contains(data.skills[indexPath.row].id) {
            cell.tintColor = UIColor.red

        }else{
            cell.tintColor = UIColor.gray

        }

        cell.selectionStyle = .none


        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == firstTableView{
            
            secondTableView.reloadData()
        }else{
              let data = sectionWithSkills[(firstTableView.indexPathForSelectedRow?.row)!]
            addSelectedPath(index: data.skills[indexPath.row].id)
      

        }
    }
    
    func addSelectedPath(index:String) {
        if !selectedIndexs.contains(index){
            selectedIndexs.append(index)
        }else{
            selectedIndexs.remove(at: selectedIndexs.index(where: {$0 == index})!)
        }
        secondTableView.reloadData()
    }


    override func viewDidLoad() {
        
    }
    
    
}
