//
//  AllServicesViewController.swift
//  laundryApp
//
//  Created by Nada Alansari on 20/05/1443 AH.
//

import UIKit

class AllServicesViewController: UIViewController ,DatabaseDategate,UICollectionViewDataSource, UICollectionViewDelegate{
    func readMyservices(myServices: [services]) {
        print(myServices)
    }
    
    @IBOutlet weak var servicesCollection: UICollectionView!
    var allServices = [services]()
    
    func readAllservices(result: [services]) {
        print(result)
        let s = result
        print("s")
        print(s.count)
        allServices = s
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        allServices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_id", for: indexPath as IndexPath) as! servicesCollectionViewCell
        cell.layer.cornerRadius = 12;
        cell.serviceName.text =  allServices[indexPath.row].serviceName
        cell.priceText.text = allServices[indexPath.row].servicePrice
        cell.onOrOff.isOn = false
        cell.btnObject = {
            cell.onOrOff.isOn = true
            let service = services(
                serviceId: self.allServices[indexPath.row].serviceId,
                serviceName: self.allServices[indexPath.row].serviceName,
                servicePhoto: self.allServices[indexPath.row].servicePhoto,
                servicePrice: cell.priceText.text!,
                serviceStatus: "On")
            let db = DatabaseHandler()
            db.addServices(service: service)
        }
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let db = DatabaseHandler()
        db.delegate = self
        db.readAllservices()
        print("my")
        db.readMyServices()
        servicesCollection.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        servicesCollection.dataSource = self
        servicesCollection.delegate = self
        servicesCollection.reloadData()
        print("viewWillAppear")
        print(allServices.count)
        
        
    }
    
    
    
    
}
