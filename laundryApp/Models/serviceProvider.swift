//
//  serviceProvider.swift
//  laundryApp
//
//  Created by Nada Alansari on 14/05/1443 AH.
//

import Foundation

struct serviceProvider {
    var id : String
    var companyName : String
    var password : String
    var email : String
    var commericalNumber : String
    var geolat : Float
    var geolng : Float
    var address : String
//    var serviceProviderServices : serviceProviderServices
}
struct serviceProviderPrpfile{
    var id : String
    var commericalNumber : String
    var geolat : Float
    var geolng : Float
    var administrativeArea : String
    var country : String

}

struct serviceProviderLogin{
    var email : String
    var password : String
}
