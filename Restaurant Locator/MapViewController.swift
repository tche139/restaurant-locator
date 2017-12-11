//
//  MapViewController.swift
//  Restaurant Locator
//
//  Created by Qingyun He on 30/08/2017.
//  Copyright © 2017 max. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    var locationManager:CLLocationManager!
    var mapView:MKMapView!
    var restaurantList = [NSManagedObject]()
    var userLocation:CLLocation = CLLocation()
    
    @IBOutlet weak var slider: UISlider!
    @IBAction func sliderChanged(_ sender: Any) {
        let value = Int(slider.value)
        radiusLabel.text = "\(value)"
    }
    @IBOutlet weak var radiusLabel: UILabel!
    
    
    
    @IBAction func searchButtonClicked(_ sender: Any) {
        //show limited restaurants on the map from core data
        for restaurant in restaurantList{
            setRestaurantPin(restaurant: restaurant)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //load map screen
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Create and Add MapView to our main view
        createMapView()
        //fetch data everytime the map screen load
        fetchData()
        //show all restaurants on the map from core data
        for restaurant in restaurantList{
            setAllRestaurantPin(restaurant: restaurant)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        determineCurrentLocation()
    }
    
    func createMapView()
    {
        mapView = MKMapView()
        mapView.showsUserLocation = true
        let leftMargin:CGFloat = 0
        let topMargin:CGFloat = 0
        let mapWidth:CGFloat = view.frame.size.width
        let mapHeight:CGFloat = view.frame.size.height - 120
        
        mapView.frame = CGRect(x:leftMargin, y:topMargin, width:mapWidth, height:mapHeight)
        
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        // Or, if needed, we can position map in the center of the view
        //mapView.set = view.topAnchor
        
        view.addSubview(mapView)
    }
    
    func determineCurrentLocation()
    {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            //locationManager.startUpdatingHeading()
            locationManager.startUpdatingLocation()
        }
    }
    
    //update user location when it changed
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[0] as CLLocation
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        //manager.stopUpdatingLocation()
        
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(region, animated: true)
        
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("Error \(error)")
    }
    
    
    //fetch restaurant data
    func fetchData(){
        let fetchRequest:NSFetchRequest<Restaurnt> = Restaurnt.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "orderPosition", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do{
            //fetching and casting to Category
            restaurantList = try DatabaseController.getContext().fetch(fetchRequest)
            print("number of results: \(restaurantList.count)")
            for restaurant in restaurantList {
                print((restaurant as! Restaurnt).name!)
            }
        }catch{
            print("Error: \(error)")
        }
    }
    
    //add all restaurant pins on map
    func setAllRestaurantPin(restaurant:NSManagedObject){
        let geoCoder = CLGeocoder()
        if let address = restaurant.value(forKey: "address") as? String{
            geoCoder.geocodeAddressString(address , completionHandler: {
                (placemarks:[CLPlacemark]?, error:Error?) -> Void in
                
                if error != nil {
                    print("error")
                    return
                }
                if let p = placemarks?[0]{
                    let lat = p.location?.coordinate.latitude
                    let lon = p.location?.coordinate.longitude
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
                    annotation.title = restaurant.value(forKey: "name") as? String
                    annotation.subtitle = "Rating: \(String(describing: restaurant.value(forKey: "rating")!))"
                    self.mapView.addAnnotation(annotation)
                    print(String(describing: lat!))
                    print(String(describing: lon!))
                    
                    
                } else {
                    print("No placemarks!")
                }
            })
        }
    }
    
    //add limited restuarant pin on map
    func setRestaurantPin(restaurant:NSManagedObject){
        //remove all pin on the map except user location
        self.mapView.annotations.forEach {
            if !($0 is MKUserLocation) {
                self.mapView.removeAnnotation($0)
            }
        }
        let geoCoder = CLGeocoder()
        if let address = restaurant.value(forKey: "address") as? String{
            geoCoder.geocodeAddressString(address , completionHandler: {
                (placemarks:[CLPlacemark]?, error:Error?) -> Void in
                
                if error != nil {
                    print("error")
                    return
                }
                if let p = placemarks?[0]{
                    let lat = p.location?.coordinate.latitude
                    let lon = p.location?.coordinate.longitude
                    let distance = self.userLocation.distance(from: p.location!) as Double
                    if distance < (Double(self.radiusLabel.text!))!{
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
                        annotation.title = restaurant.value(forKey: "name") as? String
                        annotation.subtitle = "Rating: \(String(describing: restaurant.value(forKey: "rating")!))"
                        self.mapView.addAnnotation(annotation)
                        print(String(describing: lat!))
                        print(String(describing: lon!))
                    }
                    
                } else {
                    print("No placemarks!")
                }
            })
        }
    }
}
