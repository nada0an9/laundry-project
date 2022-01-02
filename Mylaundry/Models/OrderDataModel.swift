//
//  OrderDataModel.swift
//  Mylaundry
//
//  Created by Nada Alansari on 28/05/1443 AH.
//

import Foundation

struct order{
    var orderID : String
    var orderDate : String
    var orderStatus : String
    var serviceProviderId: String
    var coustomerId:String
    var arrOrderServices = [orderServices]()
}
struct orderServices{
    var serviceID : String
    var servicesQty : String
}
