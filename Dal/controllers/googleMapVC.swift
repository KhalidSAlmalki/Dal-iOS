//
//  googleMapVC.swift
//  Dal
//
//  Created by khalid almalki on 4/11/18.
//  Copyright © 2018 khalid almalki. All rights reserved.
//

import UIKit
import GoogleMaps
protocol googleMapDelegate :class{
    func googleMapDataDidSelected(locationModel:locationModel)
}
protocol googleMapDataSource :class{
    
    func googleMapDataSourceUserLocation() -> locationModel
}
class googleMapVC: baseViewController,GMSMapViewDelegate {

    
    private var circleView = UIView()
    private var width = CGFloat()
    private var height = CGFloat()
    private var circlePath = UIBezierPath()
    
    var delegate:googleMapDelegate?
    var dataSource:googleMapDataSource?


    @IBOutlet weak var googleMapView: GMSMapView!
    
    
    var userLocation:locationModel = locationModel()
    
    func setUP(loction:[String],range:String) {
        
        width =  self.view.frame.size.width-10
        height = self.view.frame.size.height-63
        
        drawCircle()
        
        googleMapView.delegate = self
        googleMapView.isMyLocationEnabled = true
        googleMapView.isMyLocationEnabled = true
        googleMapView.settings.myLocationButton = true
        
        if let data = dataSource?.googleMapDataSourceUserLocation(){
                      userLocation = data
            
            setMapCamera()

        }
        
        
        
    }
    
    func changeTitleDependOnLocation() {
       
       // Bartitle.text = "مساحة التغطية (  \((CurrentLocationData?.Range)!) كم )"
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
        print("the current didTapAt ", userLocation.location as Any)
        userLocation = locationModel(location: coordinate, Range:Float(getRadius()/1000), zoom: mapView.camera.zoom)
        print("the current didTapAt after", userLocation.location as Any)
        
        setMapCamera()
        
    }
    
    
    func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition) {
        
        googleMapView.clear()
  
        userLocation = locationModel(location: cameraPosition.target, Range:Float(getRadius()/1000), zoom: cameraPosition.zoom)
        changeTitleDependOnLocation()
        self.setMapCamera()
    }
    
    private func setMapCamera() {
        googleMapView.clear()
        CATransaction.begin()
        CATransaction.setValue(0.5, forKey: kCATransactionAnimationDuration)
        googleMapView?.animate(to: GMSCameraPosition.camera(withTarget: userLocation.location, zoom: userLocation.zoom))
        CATransaction.commit()
        
        
    }
    
    private func constraint() {
        let heightConstraint = NSLayoutConstraint(item: circleView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant:self.view.frame.width-20
        )
        let widthConstraint = NSLayoutConstraint(item: circleView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant:self.view.frame.width-20
        )
        let centerXConstraint = NSLayoutConstraint(item: circleView, attribute: .centerX, relatedBy: .equal, toItem: googleMapView, attribute: .centerX, multiplier: 1, constant: 0)
        let centerYConstraint = NSLayoutConstraint(item: circleView, attribute: .centerY, relatedBy: .equal, toItem: googleMapView, attribute: .centerY, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([heightConstraint, widthConstraint, centerXConstraint, centerYConstraint])
        
        view.updateConstraints()
    }
    
    func drawCircle() {
        
        circleView.backgroundColor = UIColor.clear
        
        self.googleMapView.addSubview(circleView)
        circleView.translatesAutoresizingMaskIntoConstraints = false
        
        constraint()
        
        UIView.animate(withDuration: 0.0, animations: {
            self.view.layoutIfNeeded()
            self.circleView.circleView = true
            self.circleView.borderWidth = 1.5
            self.circleView.BorderColor = UIColor.dalHeaderColor()
            self.circleView.isUserInteractionEnabled = false
        })
        
        let path = UIBezierPath(rect: googleMapView.bounds)
        
        
        circlePath =  UIBezierPath(roundedRect: CGRect(x: circleView.frame.origin.x, y: circleView.frame.origin.y, width:circleView.frame.width, height: circleView.frame.height) , cornerRadius: circleView.frame.width)
        path.append(circlePath)
        
        path.usesEvenOddFillRule = true
        
        let fillLayer = CAShapeLayer()
        fillLayer.path = path.cgPath
        fillLayer.fillRule = kCAFillRuleEvenOdd
        fillLayer.fillColor = UIColor.black.cgColor
        fillLayer.opacity = 0.2
        googleMapView.layer.addSublayer(fillLayer)
        
    }
    // calculate radius
    func getCenterCoordinate() -> CLLocationCoordinate2D {
        let centerPoint = self.circleView.center
        let centerCoordinate = self.googleMapView.projection.coordinate(for: centerPoint)
        
        
        return centerCoordinate
    }
    
    func getTopCenterCoordinate() -> (CLLocationCoordinate2D, CLLocationCoordinate2D) {
        // to get coordinate from CGPoint of your map
        
        let circleViewHeight = self.circleView.frame.height
        let circleViewY = self.circleView.frame.origin.y
        
        let topCenterCoor = self.circleView.convert(CGPoint(x: width/2, y:circleViewY), from: self.circleView)

        let point = self.googleMapView.projection.coordinate(for: topCenterCoor)
        

        let markerbottomcoor = self.circleView.convert(CGPoint(x: width/2, y: (circleViewY+circleViewHeight) ), from: self.circleView)
        let pointmarkerbottom = self.googleMapView.projection.coordinate(for: markerbottomcoor)
        
        return (point, pointmarkerbottom )
    }
    
    func getRadius() -> CLLocationDistance {
        let centerCoordinate =  self.getCenterCoordinate()
        
        
        // init center location from center coordinate
        let centerLocation = CLLocation(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude)
        let topCenterCoordinate = self.getTopCenterCoordinate().0
        let topCenterLocation = CLLocation(latitude: topCenterCoordinate.latitude, longitude: topCenterCoordinate.longitude)
        
        let radius = CLLocationDistance(centerLocation.distance(from: topCenterLocation))
        
        
        return round(radius)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func doneBt(_ sender: Any) {
        
        delegate?.googleMapDataDidSelected(locationModel: userLocation)
        dismissDalBaseView()
    }
    @IBAction func closeBt(_ sender: Any) {
        
        dismissDalBaseView()
    }
    


}
