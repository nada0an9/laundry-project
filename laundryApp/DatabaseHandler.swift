//
//  DatabaseHandler.swift
//  laundryApp
//
//  Created by Nada Alansari on 14/05/1443 AH.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


class DatabaseHandler{
    
    //connection with firestore
    let dbStore = Firestore.firestore()
    
    func createServiceProvider(newUser : serviceProvider){
        
        //create the service provider
        Auth.auth().createUser(withEmail: "", password: "") { result, error in
            if(error == nil){
                
                print(result?.user.email ?? "No email")
            }
            else{
                print(error?.localizedDescription ?? "")
            }
        }
        
        //add the company to the colllection
        dbStore.collection("serviceProvider").addDocument(data: [
            "userId": newUser.id,
            "CompanyName" : newUser.companyName,
            "commericalNumber" : newUser.commericalNumber,
            "geolat" : newUser.geolat,
            "geolng" : newUser.geolng,
            "address" : newUser.address

        ])
        print("Service Provider Added sucsessfuly")
    }
    
}


