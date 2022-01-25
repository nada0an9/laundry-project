//
//  DatabaseHandler.swift
//  laundryApp
//  Created by Nada Alansari on 14/05/1443 AH.

import Foundation
import FirebaseAuth
import FirebaseFirestore


protocol DatabaseDategate  {
    
    func readAllservices(result: [services])
    func readMyservices(myServices: [services])
    
}
class DatabaseHandler{
    
    //connection with firestore
    let dbStore = Firestore.firestore()
    var logedUserId : String?
    var result = [services]()
    var delegate: DatabaseDategate!
    var myServices = [services]()
    
    func createServiceProvider(newUser : serviceProvider){
        //create the service provider
        Auth.auth().createUser(withEmail: newUser.email, password: newUser.password) { result, error in
            if(error == nil){
                self.logedUserId  = result?.user.uid
                print(self.logedUserId!)
                //add the company to the colllection
                self.dbStore.collection("serviceProvider").document(self.logedUserId!).setData([
                    "userId": self.logedUserId!,
                    "companyName" : newUser.companyName
                    
                ])
                print("Service Provider Added sucsessfuly")
            }
            else{
                print(error?.localizedDescription ?? "")
            }
        }
    }
    func login(loggedUser : serviceProviderLogin){
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
    
    func updateServiceProviderProfile(newProfile : serviceProviderPrpfile){
        dbStore.collection("serviceProvider")
            .whereField("userId", isEqualTo: newProfile.id)
            .getDocuments() { (querySnapshot, err) in
                if let document = querySnapshot!.documents.first{
                    document.reference.updateData([
                        "commericalNumber" : newProfile.commericalNumber,
                        "geolat" : newProfile.geolat,
                        "geolng" : newProfile.geolng,
                        "administrativeArea" : newProfile.administrativeArea,
                        "country": newProfile.country
                    ])
                }
            }
        print("Service Provider Profile Updated Sucsessfuly")
    }
    
    func readAllservices(){
        dbStore.collection("services").addSnapshotListener { [self] snapshot, error in
            if let doc = snapshot?.documents{
                for item in doc {
                    let name = item["serviceName"] as? String ?? ""
                    //object from services model
                    let s =  services(serviceId: item.documentID, serviceName: name, servicePhoto: "", servicePrice: "3", serviceStatus: "off")
                    self.result.append(s)
                }
                delegate.readAllservices(result: self.result)
                
            }
        }
    }
    func addServices(service : services){
        //getting the user id from the UserDefaults
        let id = UserDefaults.standard.string(forKey: "userId")
        //add service for the service's provider
        dbStore.collection("serviceProvider").document(id!).collection("services").addDocument(data: [
            "servicesID" : service.serviceId,
            "price" : service.servicePrice,
            "serviceName" : service.serviceName,
            "servicePic" : service.servicePhoto,
            "serviceStatus" : "on"
        ])
        print("you go")
    }
    
    func readMyServices(){
        //getting the user id from the UserDefaults
        let id = UserDefaults.standard.string(forKey: "userId")
        dbStore.collection("serviceProvider")
            .document(id!)
            .collection("services")
            .getDocuments() { (querySnapshot, err) in
                if let doc = querySnapshot?.documents{
                    for item in doc {
                        let serviceId = item["servicesID"] as? String ?? ""
                        let serviceName = item["serviceName"] as? String ?? ""
                        let servicePrice = item["price"] as? String ?? ""
                        let serviceStatus = item["serviceName"] as? String ?? ""
                        let servicePic = item["servicePic"] as? String ?? ""
                        //object from services model
                        let s =  services(serviceId: serviceId, serviceName: serviceName, servicePhoto: servicePic, servicePrice: servicePrice, serviceStatus: serviceStatus)
                        self.myServices.append(s)
                        print( self.myServices)
                    }
                    self.delegate.readMyservices(myServices: self.myServices)
                    
                }
            }
    }
    
    // MARK:  READ Orders
    func readAllOrder(completion: @escaping ([order]) -> Void ){

        var orderArray = [order]()
        dbStore.collection("order").whereField("serviceProviderId",isEqualTo: Auth.auth().currentUser?.uid).addSnapshotListener { [] snapshot, error in
            if let doc = snapshot?.documents{
                for item in doc {
                    let date = item["orderDate"] as? String ?? ""
                    let status = item["orderStatus"] as? String ?? ""
                    let serviceProvider = item["serviceProvider"] as? String ?? ""
                    let coustomerId = item["customerId"] as? String ?? ""
                    //object from order model
          
                    // read customer info
                    let docRef = self.dbStore.collection("Customer").document(coustomerId)
                    docRef.getDocument { (document, error) in
                        if let document = document, document.exists {
                            let customerName = document["customerName"] as? String ?? ""
                            let customerMobile = document["customerMobile"] as? String ?? ""

                            let customer = customer(customerId: coustomerId, customerName: customerName, customerMobile: customerMobile )
                            let order = order(orderID: item.documentID, orderDate: date, orderStatus: status, serviceProviderId: serviceProvider, coustomerId:coustomerId, customer: customer)
                            orderArray.append(order)
                            completion(orderArray)
                    
                    
                        }
                    }
                    
                }
            }
        }
    }
    
    // MARK:  READ Orders Detaile
    
    func readOrderDeatails(orderId : String ,completion: @escaping (order, [orderServices]) -> Void ){
        var orderProudect = [orderServices]()
        
        let docRef = self.dbStore.collection("order").document(orderId)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let date = document["orderDate"] as? String ?? ""
                let status = document["orderStatus"] as? String ?? ""
                let serviceProvider = document["serviceProviderId"] as? String ?? ""
                let coustomerId = document["customerId"] as? String ?? ""
                
                // read customer info
                let docRef = self.dbStore.collection("Customer").document(coustomerId)
                docRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        let name = document["customerName"] as? String ?? ""
                        let mobile = document["customerMobile"] as? String ?? ""
                        
                        // object from customer  model
                        var customerObj = customer(customerId: coustomerId, customerName: name, customerMobile: mobile)
                        
                        // object from order  model
                        var s = [orderServices]()
                        var order = order(orderID: orderId, orderDate: date, orderStatus: status, serviceProviderId: serviceProvider, coustomerId: coustomerId, arrOrderServices: s, customer: customerObj)

                        //read order services
                        self.dbStore.collection("order").document(orderId).collection("orderService").addSnapshotListener
                        { [] snapshot, error in
                            if let doc = snapshot?.documents{
                                for item in doc {
                                    let qty = item["qty"] as? String ?? ""
                                    let serviceId = item["serviceId"] as? String ?? ""
                                    let serviceName = item["serviceName"] as? String ?? ""
                                    let servicePic  = item["servicePic"] as? String ?? ""
                                    
                                    
                                    print("the servise provider id \(serviceProvider)")
                                 
                                    // object from order servises model
                                    var orderService = orderServices(serviceID: serviceId, servicesQty: qty, servicesName: serviceName, servicesPic: servicePic, servicesPrice: "0")
                                    
           
                                    orderProudect.append(orderService)
                                    completion(order,orderProudect)

                                    
                                    
                                }
                            }
                        }
                        
                    }
                }
            }
        }
        
    }
    
    func findPrice(serviceId: String , ProviderId : String, completion: @escaping (String) -> Void){
        var servicePrice = ""
        dbStore.collection("serviceProvider").document(ProviderId).collection("services").whereField("serviceId", isEqualTo: serviceId).addSnapshotListener { [] snapshot, error in
            if let doc = snapshot?.documents{
                for item in doc {
                    let price = item["price"] as? String ?? ""
                    servicePrice = price
                    completion(price)
                    
                }
            }
        }
    }
    
    // MARK:  updated Orders Status
    func updatedOrdersStatus(orderId : String, status : String){
        dbStore.collection("order").document(orderId).updateData(["orderStatus": status])
         print("Updated Sucsessfuly")
        
    }

    
}


