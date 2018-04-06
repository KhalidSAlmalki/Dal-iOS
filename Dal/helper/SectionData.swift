////
////  SectionData.swift
////  Dall
////
////  Created by khalid almalki on 6/7/16.
////  Copyright © 2016 khalid almalki. All rights reserved.
////
//
//import UIKit
//import CoreLocation
//
//struct DictinaryPerSections {
//    var section_id :String
//    var DataOfWorkersforPerSection:[SectionDataOfWorkers]
//    
//    
//}
//// genreal data as id , name , stataus and image which are important 
//struct GeneralData {
//    
//    let id:Int!
//    let name:String!
//    var status:Int!
//    let imageUrl:String!
//}
//struct GeneralSkills {
//    let id:Int
//    let name:String
//    let section_ID:Int
//    var isChecked:Bool
//    
//
//}
//
//struct PlacesOfworker {
//    let id:Int
//    let City:String
//}
//struct SectionsWithGskils {
//    
//    let sectioN:SectionDetials
//    var skills:[GeneralSkills]
//    
//    
//}
//
//struct SectionDataOfWorkers {
//   
//   
//      let generaldata:GeneralData!
//      var lat: Int!
//      var lng: Int!
//      var IsBusy:Bool!
//      let distance: Float
//      var skills:[SkillsOfWorkrss]!
//      var contacts:[ContactsOfWorkres]!
//      var Places:[PlacesOfworker]
//    
//}
//class WorkersData{
//    fileprivate var WorkerInfor:SectionDataOfWorkers! = nil
//    fileprivate var ImageData:Data! = nil
//    
//    init(W:SectionDataOfWorkers,D:Data){
//        
//        WorkerInfor=W
//        ImageData=D
//    }
//    init(){
//        print("initliaze")
//    }
//    func GetWorkerInfor() -> SectionDataOfWorkers {
//        return WorkerInfor
//    }
//    
//   
//    func GetImageData() -> Data {
//        return ImageData
//    }
//    
//    // fouc to putt all skills name in one string
//    
//    func Put_all_skills_in_one_Line()-> (highlight: String, nurmer:String) {
//        
//         var temp = ""
//        for  NameOfstring  in  WorkerInfor.skills    {
//            
//            
//            
//            
//              temp+="\(NameOfstring.nameOfSkill! )"
//            if NameOfstring.id  != WorkerInfor.skills.last?.id{
//                
//                temp+="-"
//
//            }
//            
//          
//        }
//        
//        return (highlight: temp, nurmer:temp)
//    }
//}
//struct SkillsOfWorkrss {
//    
//    var id : Int!
//    var nameOfSkill:String!
//    var section_id:Int!
//    var image:String!
//    
//    
//}
//struct SubtableData {
//    let Name:String!
//    let ID:String
//}
//
//struct generalContact {
//    var generalData:GeneralData
//}
//
//struct ContactsOfWorkres {
//    var id:Int!
//    var key:String!
//    var name:String!
//    var value:String!
//    var status:String!
//    var worker_id:Int!
//    var image:String
//    
//}
//class LocationData: NSObject {
//    
//    var location: CLLocationCoordinate2D
//    var Range: Float 
//    var zoom:Float
//    
//    init(location: CLLocationCoordinate2D, Range: Float,zoom:Float) {
//        self.location = location
//        self.Range = Range
//        self.zoom = zoom 
//    }
//    
//    
//    
//    
//}
//class DataLocation: NSObject {
//    
//    let city: String!
//    let subcity: String!
//    
//    init(city: String,subcity: String) {
//        self.city = city
//        self.subcity = subcity
//    }
//    
//    func getCity() -> String {
//        print("init",self.city)
//        
//        return city
//    }
//    func getSubcity() -> String {
//        print("init",self.subcity)
//        
//        return subcity
//    }
//    
//}
//
//public struct SectionDetials {
//    
//    let SectionDetials:GeneralData
//    
//}
//
//struct WidthIteamsOfEach {
//    static var WidthView:CGFloat = 64.00
//}
//
////convert
//func ConvertToInt(_ int:AnyObject!) -> Int {
//    
//    return int! as! Int
//    
//}
//
//func ConvertToString(_ string:AnyObject!) -> String {
//    
//        return  string! as! String
//
//    }
//
//func verifyUrl (urlString: String?) -> Bool {
//    if let urlString = urlString {
//        if let url  = NSURL(string: urlString) {
//            return UIApplication.shared.canOpenURL(url as URL)
//        }
//    }
//    return false
//}
//func checkIfHasImageURl(_ ImageUrl:String!) -> String {
//    let ServerId = "http://178.62.16.186/"
//    var url: String
//    
//    
//    if verifyUrl(urlString: ImageUrl) == true  {
//        
//        url = "\(ImageUrl!)"
//
//    }else{
//        
//        url = "\(ServerId)uploads/avatars/bqC6rg_carre_homme.jpg"
//
//    }
//    
//
//
//       
//    return url
//    
//}
//
//func ConvertToURL(_ string:AnyObject!) -> URL {
//    
//    return string! as! URL
//    
//}
//
//
//
//
