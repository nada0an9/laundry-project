//
//  DatabaseHandelr.swift
//  Mylaundry
//
//  Created by Nada Alansari on 21/05/1443 AH.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import CoreLocation

protocol DatabaseDategate  {
        func readAllClosestServices(result: [closetProvider])
        func readProviderServices(myServices: [services])

}

class DatabaseHandler{
    //connection with firestore
    let dbStore = Firestore.firestore()
    var logedUserId : String?
    var result = [closetProvider]()
    var delegate: DatabaseDategate!

    var userAdministrativeArea: String = ""
    var geoLat: Double?
    var geoLan: Double?
    var userLocation = CLLocation(latitude: 53.45678, longitude: 13.54455)
    var myServices = [services]()

    func createCustomer(newUser : customer){
        //create the Customer
        Auth.auth().createUser(withEmail: newUser.customerEmail, password: newUser.password) { result, error in
            if(error == nil){
                self.logedUserId  = result?.user.uid
                print(self.logedUserId!)
                //add the customer to the customer colllection
                self.dbStore.collection("Customer").document(self.logedUserId!).setData([
                    "userId": self.logedUserId!,
                    "customerName" : newUser.customerName,
                    "geolat" : newUser.geolat,
                    "geolng" : newUser.geolng,
                    "administrativeArea" : newUser.administrativeArea,
                    "country": newUser.country
                    
                ])
                print("Customer Added sucsessfuly")
            }
            else{
                print(error?.localizedDescription ?? "")
            }
        }
    }
    func customerLogin(loggedUser : customerLogin){
        Auth.auth().signIn(withEmail: loggedUser.email, password:loggedUser.password) { result, error in
            if(error == nil){
                self.logedUserId = result?.user.uid
                print("we go")
                print("the user loged id \(self.logedUserId!)")
                UserDefaults.standard.set(true, forKey: "userLoggedIn")
                UserDefaults.standard.set(result?.user.uid, forKey: "userId")
                UserDefaults.standard.synchronize()
            }
            else{
                print("login fali")
                print(error?.localizedDescription ?? "")
            }
        }
    }
    
    func updateCcustomerProfile(newProfile : customerProfile){
        dbStore.collection("Customer")
            .whereField("userId", isEqualTo: newProfile.customerId)
            .getDocuments() { (querySnapshot, err) in
                if let document = querySnapshot!.documents.first{
                    document.reference.updateData([
                        "geolat" : newProfile.geolat,
                        "geolng" : newProfile.geolng,
                        "administrativeArea" : newProfile.administrativeArea,
                        "country": newProfile.country
                    ])
                }
            }
        print("Profile Updated Sucsessfuly")
    }

    func ListClosestServiceProvider(){
        let id = UserDefaults.standard.string(forKey: "userId")
        dbStore.collection("Customer").whereField("userId", isEqualTo: id!)
            .getDocuments(){ (querySnapshot, err) in
                if let document = querySnapshot!.documents.first{
                    let administrativeArea =  document["administrativeArea"] as? String ?? ""
                    let geolat =  document["geolat"] as? Double ?? 1.7777
                    let geolng =  document["geolng"] as? Double ?? 3.777

                    print("administrativeArea")
                    self.userAdministrativeArea = administrativeArea
                    self.geoLat = geolat
                    self.geoLan = geolng
                    self.userLocation = CLLocation(latitude: self.geoLat!, longitude: self.geoLan!)


                    //list all service provider in same administrative area of the customer
                    self.dbStore.collection("serviceProvider").whereField("administrativeArea", isEqualTo: self.userAdministrativeArea).addSnapshotListener { [self] snapshot, error in
                        if let doc = snapshot?.documents{
                            for item in doc {
                                let name = item["companyName"] as? String ?? ""
                                let id = item["userId"]as? String ?? ""
                                let geolat = item["geolat"] as? Double ?? 1.666
                                let geolng = item["geolng"] as? Double ?? 2.666
                                let coord = CLLocation(latitude: geolat, longitude: geolng)
                                
                                //Finding my distance to my next destination (in km)
                                let distance = self.userLocation.distance(from: coord) / 1000
                                
                                //object from the closetProvider model
                                let closetProvider = closetProvider(id:id, name: name, coord: coord, distance: distance)
                                
                                self.result.append(closetProvider)
                                
                   
                            }
                            
                            delegate.readAllClosestServices(result: self.result.sorted(by: { $0.coord.distance(from: self.userLocation) < $1.coord.distance(from: self.userLocation) })

                            )
                        }
                    }
                    
                    print("geolng")
                    self.geoLan = geolng
                    print(self.geoLan ?? 4.44)
                    
                    print("geolat")
                    self.geoLat = geolat
                    print(self.geoLat ?? 8.99)
                }
            }
        let s = "Al Madinah"
        let r = self.userAdministrativeArea
        print(s)
        print("here r")
        print(r)

    }
    
    //function to get all services for the spesific service provider  and fetch it to the model
    func getSpesificServices(serviceProviderId :String){
        
        dbStore.collection("serviceProvider")
            .document(serviceProviderId)
            .collection("services")
            .getDocuments() { (querySnapshot, err) in
                if let doc = querySnapshot?.documents{
                    for item in doc {
                        let serviceId = item["servicesID"] as? String ?? ""
                        let serviceName = item["serviceName"] as? String ?? ""
                        let servicePrice = item["price"] as? String ?? ""
                        let serviceStatus = item["serviceName"] as? String ?? ""
                        let servicePic = item["servicePic"] as? String ?? ""
                        
                        //object from the services model
                        let services = services(providerId: serviceProviderId, serviceId: serviceId, serviceName: serviceName, servicePhoto: servicePic, servicePrice: servicePic)
                        
                        self.myServices.append(services)
                        print( self.myServices)
                    }
                    self.delegate.readProviderServices(myServices: self.myServices)

                }
            }
    }
}
         
          
