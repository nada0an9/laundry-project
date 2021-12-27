////
////  servicesViewController.swift
////  laundryApp
////  Created by Nada Alansari on 16/05/1443 AH.
////
//
//import UIKit
//
//class servicesViewController: UIViewController,DatabaseDategate,UICollectionViewDataSource, UICollectionViewDelegate {
//    var allServices = [services]()
//
//
//    func readAllservices(result: [services])  {
//        let s = result
//        print("s")
//        print(s.count)
//        allServices = s
//    }
// 
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        allServices.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_id", for: indexPath as IndexPath) as! servicesCollectionViewCell
//        cell.layer.cornerRadius = 12;
//        cell.serviceName.text = allServices[indexPath.row].serviceName
//        cell.priceText.text = "3 RS"
//        cell.btnObject = {
//            let service = services(serviceId: self.allServices[indexPath.row].serviceId, serviceName: self.allServices[indexPath.row].serviceName, servicePhoto: "pic2", servicePrice: "2", serviceStatus: "off")
//            let db = DatabaseHandler()
//            db.addServices(service: service)
//        }
//        return cell
//    }
//    
//    @IBOutlet weak var servicesCollection: UICollectionView!
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let db = DatabaseHandler()
//        db.delegate = self
//        db.readAllservices()
//        servicesCollection.reloadData()
// 
//    }
//    override func viewWillAppear(_ animated: Bool) {
//        servicesCollection.dataSource = self
//        servicesCollection.delegate = self
//        servicesCollection.reloadData()
//        print("viewDidAppear")
//        print(allServices.count)
//
//
//    }
//    
//    
//    
//    
//}
