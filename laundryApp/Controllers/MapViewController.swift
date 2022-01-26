//
//  MapViewController.swift
//  laundryApp
//
//  Created by Nada Alansari on 15/05/1443 AH.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet weak var number: UITextField!
    
    @IBOutlet weak var commericalNumber: UITextField!
    var geolat : Float?
    var geolng : Float?
    var administrativeArea : String?
    var country: String?

    @IBAction func updateProfile(_ sender: Any) {
        
         let db = DatabaseHandler()
         UserDefaults.standard.bool(forKey: "userLoggedIn")  // true
         let id = UserDefaults.standard.string(forKey: "userId")
         print("my id \(id!)")
         
         let myProfile = serviceProviderPrpfile(id: id!, commericalNumber: commericalNumber.text!, geolat: geolat!, geolng: geolng!, administrativeArea: administrativeArea!, country: country!)
         db.updateServiceProviderProfile(newProfile: myProfile)
    }

    @IBOutlet weak var laundryLocation: MKMapView!
    var locationManager = CLLocationManager()
    let newPin = MKPointAnnotation()
    var canMove: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()

            if CLLocationManager.locationServicesEnabled(){
                locationManager.startUpdatingLocation()
            }
        
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

}
func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Error \(error)")
}


}
