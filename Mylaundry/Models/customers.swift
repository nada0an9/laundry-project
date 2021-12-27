//
//  customers.swift
//  laundryApp
//
//  Created by Nada Alansari on 21/05/1443 AH.
//

import Foundation
import CoreLocation

struct customer{
    var customerId : String
    var customerName : String
    var customerEmail : String
    var customerMobile : String
    var geolat : Float
    var geolng : Float
    var administrativeArea : String
    var country : String
    var password : String

}
struct customerProfile{
    var customerId : String
    var geolat : Float
    var geolng : Float
    var administrativeArea : String
    var country : String
}
struct customerLogin{
    var email : String
    var password : String
}
struct closetProvider {
    
    var id : String
    var name: String
    var coord : CLLocation
    var distance : Double
}
