//
//  services.swift
//  laundryApp
//
//  Created by Nada Alansari on 14/05/1443 AH.
//

import Foundation


struct services{
    var serviceId : String
    var serviceName : String
    var servicePhoto : String
    var servicePrice :String
    var serviceStatus :String
}
struct order{
    var orderID : String
    var orderDate : String
    var orderStatus : String
    var serviceProviderId: String
    var coustomerId:String
    var arrOrderServices = [orderServices]()
    var customer : customer

}
struct orderServices{
    var serviceID : String
    var servicesQty : String
    var servicesName : String
    var servicesPic : String
    var servicesPrice : String

}
struct customer{
    var customerId : String
    var customerName : String
    var customerMobile : String
}

