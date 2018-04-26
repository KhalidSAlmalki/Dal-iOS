//
//  locationModel.swift
//  Dal
//
//  Created by khalid almalki on 4/17/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import Foundation
import CoreLocation

class locationModel: NSObject {
   
    
  
    var location: CLLocationCoordinate2D
    var Range: Float
    var zoom:Float
    
    override var description: String{
        
        return "latitude:  \(location.latitude), \n latitude: \(location.longitude)"
    }

    override init() {
        location = CLLocationCoordinate2D()
        Range = 8.04672*0.62137119
        zoom = 15
    }
   convenience init(location: CLLocationCoordinate2D, Range: Float,zoom:Float) {
        self.init()
        self.location = location
        self.Range = Range
        self.zoom = zoom

    }
  
    func getDesc(completion:@escaping (String) -> ()){
        
        getCountryAndCity { (Country, City) in
            
            completion("\(Country),\(City),\(self.Range)")
        }
        
    }

   func getCountryAndCity(completion: @escaping (String, String) -> ()) {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: location.latitude, longitude: location.longitude)) { placemarks, error in
            if error != nil {
            } else if let country = placemarks?.first?.country,
                let city = placemarks?.first?.locality {
                completion(country, city)
            }
        }
    }

    
    
    
    
}
