//
//  DatabaseHandler.swift
//  laundryApp
//  Created by Nada Alansari on 14/05/1443 AH.

import Foundation
import FirebaseAuth
import FirebaseFirestore


class DatabaseHandler{
    

    //connection with firestore
    let dbStore = Firestore.firestore()
    var logedUserId : String?
    
    func createServiceProvider(newUser : serviceProvider){
        //create the service provider
        Auth.auth().createUser(withEmail: newUser.email, password: newUser.password) { result, error in
            if(error == nil){
                
                self.logedUserId  = result?.user.uid
                print(self.logedUserId)
                //add the company to the colllection
                self.dbStore.collection("serviceProvider").addDocument(data: [
                    "userId": self.logedUserId,
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
        
        var checkloggedUser : Bool = false
        
        Auth.auth().signIn(withEmail: loggedUser.email, password:loggedUser.password) { result, error in
            if(error == nil){
                self.logedUserId = result?.user.uid
                checkloggedUser = true
                print("we go")
                print("the user loged id \(self.logedUserId)")
                UserDefaults.standard.set(true, forKey: "userLoggedIn")
                UserDefaults.standard.set(result?.user.uid, forKey: "userId")
                UserDefaults.standard.synchronize()
                
            }
            else{
                print("login fali")
                print(error?.localizedDescription ?? "")
                checkloggedUser = false
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
    
}


