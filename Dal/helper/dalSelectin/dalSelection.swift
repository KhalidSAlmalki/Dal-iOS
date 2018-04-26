//
//  dalSelection.swift
//  Dal
//
//  Created by khalid almalki on 4/11/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import UIKit



class dalSelection: baseViewController,UITableViewDelegate,UITableViewDataSource {

    
    

    var delgate:dalSelectionDelgate?
    var dataSource:dalSelectionDataSource?
    @IBOutlet weak private var secondTableView: UITableView!
    @IBOutlet weak private var firstTableView: UITableView!
    
    private var selectedSkills = [sectionModel]()
    
    
    
    func setUP() {
      

        if let data = dataSource?.dalSelectionSelectedSkills() {
            selectedSkills = data

        }
        firstTableView.reloadData()
        secondTableView.reloadData()
        firstTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)

        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == firstTableView{
            return  restAPI.shared.sections.count()
         }else if tableView == secondTableView{
            guard firstTableView.indexPathForSelectedRow?.row != nil else{
                return 0
            }
    return  restAPI.shared.sections.getSections()[(firstTableView.indexPathForSelectedRow?.row)!].skills.count
        

        }
        
        return 0
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if tableView == self.firstTableView {

            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)

            cell.textLabel?.text = restAPI.shared.sections.getSections()[indexPath.row].name
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .gray

            return cell
        }

        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)

        let data = restAPI.shared.sections.getSections()[(firstTableView.indexPathForSelectedRow?.row)!]
        cell.textLabel?.text = data.skills[indexPath.row].name
        cell.accessoryType = .checkmark

        if let index = selectedSkills.index(where:{$0.id == data.id}) {

            if selectedSkills[index].skills.contains(where :{$0.id ==  data.skills[indexPath.row].id }){
                        cell.tintColor = UIColor.red

            }else{
                        cell.tintColor = UIColor.gray

             }

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
            addSelectedPath(selectedIndex: indexPath.row)
      

        }
    }
    
    func addSelectedPath(selectedIndex:Int) {
        
    let data = restAPI.shared.sections.getSections()[(firstTableView.indexPathForSelectedRow?.row)!]
        let selected = data.skills[selectedIndex]
        
        if selectedSkills.contains(where:{$0.id == data.id}) {
            
            if let index =  selectedSkills.index(where:{$0.id == data.id}){
                
                if let indexS =   self.selectedSkills[index].skills.index(where: {$0.id == selected.id}){
                    
                    self.selectedSkills[index].skills.remove(at: indexS)
                    if self.selectedSkills[index].skills.count == 0{
                        self.selectedSkills.remove(at: index)
                    }
                }else{
                     self.selectedSkills[index].addSkill(aSkill: selected)

                }

            }
        }else{
            
             self.selectedSkills.append(sectionModel(id: data.id, name: data.name, avatar: data.avatar, sort: data.sort))
            self.addSelectedPath(selectedIndex: selectedIndex)
        }

        secondTableView.reloadData()
    }

    @IBAction func doneBt(_ sender: UIButton) {
              
        delgate?.dalSelectionDidSelected(skills: self.selectedSkills)
        dismissDalBaseView()

    }
    @IBAction func cancelBt(_ sender: UIButton) {
        dismissDalBaseView()
    }
    
   
    
    
}
