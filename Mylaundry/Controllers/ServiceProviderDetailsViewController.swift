//
//  ServiceProviderDetailsViewController.swift
//  Mylaundry
//
//  Created by Nada Alansari on 22/05/1443 AH.
//

import UIKit

class ServiceProviderDetailsViewController: UIViewController, sendSpesificServices {
    func readProviderServices(myServices: [services]) {
        print(myServices)
    }
    
    var s :String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        print("my services")
        print(s)
        let db = DatabaseHandler()
        db.sendSpesificServices = self
        db.getSpesificServices(serviceProviderId: s)
    }
    



}
