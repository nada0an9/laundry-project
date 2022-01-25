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
    var servicesName : String
    var servicesPic : String
    var servicesPrice : String

    

}
struct  orderServices2 {
    var serviceID : String
    var servicesName : String
    var servicesPic : String
    var servicesQty : String
    var servicesPrice : String


}


struct servicesInfo{
    var orderServices : orderServices!
    var servicesName : String
    var servicesPic : String
    var servicesPrice : String
    
    
}
