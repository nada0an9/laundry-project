//
//  MapViewController.swift
//  Mylaundry
//  Created by Nada Alansari on 21/05/1443 AH.

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
    
    @IBAction func saveBtn(_ sender: Any) {
        print("we uupdate")
        let db = DatabaseHandler()
        
        UserDefaults.standard.bool(forKey: "userLoggedIn")
        let id = UserDefaults.standard.string(forKey: "userId")
        print("my id \(id!)")
        let myProfile = customerProfile(
                    customerId: id!,
                    geolat: Double(geolat!),
                    geolng: Double(geolat!),
                    administrativeArea: administrativeArea!,
                    country: country!)
        
        db.updateCcustomerProfile(newProfile: myProfile)
        print("we uupdate")
        

    }

    var geolat : Float?
    var geolng : Float?
    var administrativeArea : String?
    var country: String?
    var locationManager = CLLocationManager()
    let newPin = MKPointAnnotation()
    var canMove: Bool = true

    @IBOutlet weak var customerMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            if CLLocationManager.locationServicesEnabled(){
                locationManager.startUpdatingLocation()
            }
        canMove = !canMove

        // Do any additional setup after loading the view.
    }
    
    //MARK: - location delegate methods
func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let userLocation :CLLocation = locations[0] as CLLocation
    geolat = Float(userLocation.coordinate.latitude)
    geolng = Float(userLocation.coordinate.longitude)
    
    print("user latitude = \(userLocation.coordinate.latitude)")
    print("user longitude = \(userLocation.coordinate.longitude)")


    let geocoder = CLGeocoder()
    geocoder.reverseGeocodeLocation(userLocation) { [self] (placemarks, error) in
        if (error != nil){
            print("error in reverseGeocode")
        }
        let placemark = placemarks! as [CLPlacemark]
        if placemark.count>0{
            let placemark = placemarks![0]
            self.administrativeArea = placemark.administrativeArea
            self.country = placemark.country
            print(placemark.locality!)
            print(placemark.administrativeArea!)
            print(placemark.country!)
      
        }
    }
    addMarkerPin(for: locations.last?.coordinate)


}
    func addMarkerPin(for location: CLLocationCoordinate2D?) {

        //MARK: Set some random location if its nil - just for demo
        var coordinate = location
        if (coordinate == nil) {
            coordinate = CLLocationCoordinate2D(latitude: +37.33756603, longitude: -122.04120235)
        }
        
        //MARK: Add a map pin
        let mapPin = MKPointAnnotation()
        mapPin.coordinate = coordinate!
        customerMap.addAnnotation(mapPin)
        
        //MARK: Zoom to the selected pin
        if (canMove) {
            let region = MKCoordinateRegion(center: coordinate!, span: MKCoordinateSpan(latitudeDelta: 0, longitudeDelta: 0))
            customerMap.setRegion(region, animated: true)
        }
    }
func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Error \(error)")
}
    

 

}
