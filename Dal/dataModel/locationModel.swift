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
        return "(\(location))"
    }
    override init() {
        location = CLLocationCoordinate2D()
        Range = 1000
        zoom = 15
    }
   convenience init(location: CLLocationCoordinate2D, Range: Float,zoom:Float) {
        self.init()
        self.location = location
        self.Range = Range
        self.zoom = zoom

    }
    func getCity()-> String{
        
        return "String"
    }
    
   func getCountryAndCity(completion: @escaping (String, String) -> ()) {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: location.latitude, longitude: location.longitude)) { placemarks, error in
            if let error = error {
                print(error)
            } else if let country = placemarks?.first?.country,
                let city = placemarks?.first?.locality {
                completion(country, city)
            }
        }
    }

    
    
    
    
}
