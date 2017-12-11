//
//  RestaurantController.swift
//  Restaurant Locator
//
//  Created by Qingyun He on 10/08/2017.
//  Copyright © 2017 max. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import CoreLocation

class RestaurantController: UIViewController {
    var currentRestaurant = NSManagedObject()
    //radius distance
    let regionRadius: CLLocationDistance = 200
    
    @IBOutlet weak var detailRestaurantImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var addedDateLabel: UILabel!
    @IBOutlet weak var notificaitonLabel: UILabel!
    @IBOutlet weak var radiusLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = currentRestaurant.value(forKey: "name") as? String
        detailRestaurantImageView.contentMode = UIViewContentMode.scaleAspectFill;
        detailRestaurantImageView.layer.masksToBounds=true;
        if let imageData = currentRestaurant.value(forKey: "logo"){
            if let image = UIImage(data:imageData as! Data){
                detailRestaurantImageView.image = image
            }
        }
        cosmosView.settings.updateOnTouch = false
        cosmosView.settings.fillMode = .half
        cosmosView.rating = currentRestaurant.value(forKey: "rating") as! Double
        addressLabel.text = currentRestaurant.value(forKey: "address") as? String
        let fomatter = DateFormatter()
        fomatter.dateFormat = "dd.MM.yyyy"
        addedDateLabel.text = fomatter.string(from: currentRestaurant.value(forKey: "dateAdded") as! Date)
        let notification = currentRestaurant.value(forKey: "notification") as! Bool
        if notification{
            notificaitonLabel.text = "On"
        } else{
            notificaitonLabel.text = "Off"
        }
        radiusLabel.text = String(describing: currentRestaurant.value(forKey: "radius")! as! Int)
        categoryLabel.text = (currentRestaurant.value(forKey: "category") as! Category).title
        let adddress = currentRestaurant.value(forKey: "address")
        locationEncode(address: adddress as! String)
    }
    
    //reverse location
    //set pin and title on map
    func locationEncode(address:String){
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address , completionHandler: {
            (placemarks:[CLPlacemark]?, error:Error?) -> Void in
            
            if error != nil {
                self.addressLabel.text = "error"
                return
            }
            if let p = placemarks?[0]{
                let lat = p.location?.coordinate.latitude
                let lon = p.location?.coordinate.longitude
                let initialLocation = p.location
                self.centerMapOnLocation(location: initialLocation!)
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
                annotation.title = self.currentRestaurant.value(forKey: "name") as? String
                annotation.subtitle = "Rating: \(String(describing: self.currentRestaurant.value(forKey: "rating")!))"
                self.mapView.addAnnotation(annotation)
                self.mapView.selectAnnotation(annotation, animated: true)
                print(String(describing: lat!))
                print(String(describing: lon!))
            } else {
                print("No placemarks!")
            }
        })
    }
    
    //center map
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}
