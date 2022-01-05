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


class DatabaseHandler {
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
            
        //add the customer to the customer colllection
        self.dbStore.collection("Customer").document(newUser.customerId).setData([
                    "userId": newUser.customerId,
                    "customerName" : newUser.customerName,
                    "customerMobile" : newUser.customerMobile,

                ])
                print("Customer Added sucsessfuly")
         
    }
    
    func customerLogin(loggedUser : customerLogin, completion: @escaping (String) -> Void) {
        var status : String = ""
        Auth.auth().signIn(withEmail: loggedUser.email, password:loggedUser.password)
        { result, error in
            if(error == nil){
                self.logedUserId = result?.user.uid
                print("we go")
                print("the user loged id \(self.logedUserId!)")
                UserDefaults.standard.set(true, forKey: "userLoggedIn")
                UserDefaults.standard.set(result?.user.uid, forKey: "userId")
                UserDefaults.standard.synchronize()
               status = "sucsess"
                completion(status)
            }
            else{
                if let error = error, let errorCode = AuthErrorCode(rawValue: error._code) {
                    switch errorCode {
                    case .invalidCredential:
                        status = "incorrect password"
                        completion(status)

                    case .wrongPassword:
                        status = "incorrect password"
                        completion(status)

                    case .userNotFound,
                            .invalidEmail:
                        status = " email address not found"
                        completion(status)

                    default:
                        status = "something went wrong"
                        completion(status)

                    }
                }
            }
        }
    }
    
    func updateCcustomerProfile(newProfile : customerProfile) {
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
    
    func getCustomerLocation(completion: @escaping (String) -> Void){
        //get customer location
        var  administrativeArea1 : String!
        
        let id = UserDefaults.standard.string(forKey: "userId")
        dbStore.collection("Customer").whereField("userId", isEqualTo: id!)
            .getDocuments(){ (querySnapshot, err) in
                if let document = querySnapshot!.documents.first{
        
                    administrativeArea1 =  document["administrativeArea"] as? String ?? ""
                    completion(administrativeArea1)

                }
                
            }
        

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
                        var b = ""
                        var s = ""
                        
                        var docRef = self.dbStore.collection("services").document(serviceId)
                        docRef.getDocument { (document, error) in
                            if let document = document, document.exists {
                                s = document["servicePic"] as? String ?? ""
                                b = document["serviceName"] as? String ?? ""
                                
                                //object from the services model
                                let services = services(providerId: serviceProviderId, serviceId: serviceId, serviceName: b, servicePhoto: s, servicePrice: servicePrice)
                                self.myServices.append(services)
                                                                
                            } else {
                                print("Document does not exist")
                                
                            }
                            self.sendSpesificServices.readProviderServices(myServices: self.myServices)
                            
                        }

                    }
                    
                    
                    
                }
            }
    }
    
    // MARK: Orders
    
    //function to add order with services
    func addOrder(newOrder: order) {
        
        //add order
        let ref = dbStore.collection("order").document()
        
        // ref is a DocumentReference
        let id = ref.documentID
        
        ref.setData([
            "orderDate" : newOrder.orderDate,
            "orderStatus" : newOrder.orderStatus,
            "customerId" : newOrder.coustomerId,
            "serviceProviderId": newOrder.serviceProviderId
        ])
        
        for item in newOrder.arrOrderServices{
            //add order proudect
            dbStore.collection("order").document(id).collection("orderService").addDocument(data: [
                "qty" : item.servicesQty,
                "serviceId": item.serviceID
                
            ])
            
        }
        print("Order Added sucsessfuly")
        
    }
    
    
    func readAllOrder(completion: @escaping ([order]) -> Void){
        // crrunt logged in user
    
        let id = UserDefaults.standard.string(forKey: "userId")
        var orderArray = [order]()


        dbStore.collection("order").whereField("customerId",isEqualTo: id!).addSnapshotListener { [self] snapshot, error in
            if let doc = snapshot?.documents{
                for item in doc {
                    let date = item["orderDate"] as? String ?? ""
                    let status = item["orderStatus"] as? String ?? ""
                    let serviceProvider = item["serviceProvider"] as? String ?? ""

                    var docRef = self.dbStore.collection("serviceProvider").document(serviceProvider)
                    docRef.getDocument { (document, error) in
                        if let document = document, document.exists {
                            let name = document["companyName"] as? String ?? ""
                            //object from order model
                            let order = order(orderID: item.documentID, orderDate: date, orderStatus: status, serviceProviderId: serviceProvider, coustomerId: id!)
                            orderArray.append(order)
                            completion(orderArray)
                        }
                    }
                
                }
            }
        }
    }
    func cancelOrder(orderId : String){
        
        dbStore.collection("order").document(orderId).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        
        
    }
    func doSomeDbOperation(completion: @escaping (String) -> Void) {
        
        var orderArray = [String]()
        
        dbStore.collection("order").getDocuments { snapshot, error in
            
            for doc in snapshot!.documents {
                let value = doc.data() as! [String: String]
                let status = value["orderStatus"] as? String
                guard let status = status else { return }
                orderArray.append(status)
            }
        }
        // We have the array to sent back
        completion(orderArray.first!)
    }
}

