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
}
protocol sendSpesificServices{
    func readProviderServices(myServices: [services])

}


class DatabaseHandler{
    //connection with firestore
    let dbStore = Firestore.firestore()
    var logedUserId : String?
    var result = [closetProvider]()
    var delegate: DatabaseDategate!
    var sendSpesificServices: sendSpesificServices!

    var userAdministrativeArea: String = ""
    var geoLat: Double?
    var geoLan: Double?
    var userLocation = CLLocation(latitude: 53.45678, longitude: 13.54455)
    
    var myServices = [services]()
    
    
    // MARK: Authentication

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
    
    // MARK: Services
    
    func ListClosestServiceProvider(){
        //get customer location
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
                }
            }

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
                        let servicePrice = item["price"] as? String ?? ""
                        let services = services(providerId: serviceProviderId, serviceId: serviceId, serviceName:  "b", servicePhoto: "s", servicePrice: servicePrice)
                        self.myServices.append(services)
                        
//                        var s :String = ""
//                        var b :String = ""

//                        var docRef = self.dbStore.collection("services").document(serviceId)
//                        docRef.getDocument { (document, error) in
//                            if let document = document, document.exists {
//                               s = document["servicePic"] as? String ?? ""
//                               b = document["serviceName"] as? String ?? ""
//                                //object from the services model
//
//                            } else {
//                                print("Document does not exist")
//                            }
//
//                        }
     
                    }
                    
               self.sendSpesificServices.readProviderServices(myServices: self.myServices)

                }
            }
    }
    
    // MARK: Orders

    //function to add order with services
    func addOrder(newOrder: order, orderServices: orderServices) {
        
        //add order
        let ref = dbStore.collection("order").document()
        
        // ref is a DocumentReference
        let id = ref.documentID
        
        ref.setData([
            "orderDate" : newOrder.orderDate,
            "orderStatus" : newOrder.orderStatus,
            "customerId" : UserDefaults.standard.string(forKey: "userId"),
            "serviceProviderId": newOrder.serviceProviderId
        ])
        
        //add order proudect
//        dbStore.collection("Orders").document(id).collection("order_Products").addDocument(data: [
//            "qty" : orderServices.servicesQty,
//            "productID": orderServices.serviceID
//
//        ])
        
        print("Order Added sucsessfuly")

    }
    
    


}
         
          
