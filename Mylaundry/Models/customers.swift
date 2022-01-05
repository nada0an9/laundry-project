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
    var customerMobile : String
}
struct customerProfile{
    var customerId : String
    var geolat : Double
    var geolng : Double
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
