//
//  ServiceProviderDetailsViewController.swift
//  Mylaundry
//
//  Created by Nada Alansari on 22/05/1443 AH.
//

import UIKit

class ServiceProviderDetailsViewController: UIViewController, sendSpesificServices,UICollectionViewDataSource, UICollectionViewDelegate  {
    
    var result = [services]()
    var s :String = ""
    var orderdSservicesArray = [orderServices]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        result.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServicesCell", for: indexPath as IndexPath) as! ServicesCollectionViewCell
        cell.layer.cornerRadius = 12;
        cell.name.text =  result[indexPath.row].serviceName
        cell.price.text = result[indexPath.row].servicePrice
        cell.obj =
                    {
                        //when the button is tapped here
                        
                        var orderServices = orderServices(serviceID: self.result[indexPath.row].serviceId, servicesQty:  cell.qty.text!)
                        self.orderdSservicesArray.append(orderServices)
                        print("added")
                }
//        cell.id = result[indexPath.row].s
        return cell
    }
    
    func readProviderServices(myServices: [services]) {
        result = myServices
        print("my services")

        print(myServices)
    }
    
    @IBAction func confirmOrder(_ sender: Any) {
        
        let today = Date()
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "HH:mm E, d MMM y"
        
        let order = order(orderID: "0", orderDate: formatter3.string(from: today), orderStatus: "in sent", serviceProviderId: self.s, coustomerId: UserDefaults.standard.string(forKey: "userId")!, arrOrderServices: self.orderdSservicesArray)

        let db = DatabaseHandler()
        db.addOrder(newOrder: order)
    }

    @IBOutlet weak var orderList: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let db = DatabaseHandler()
        db.sendSpesificServices = self
        db.getSpesificServices(serviceProviderId: s)
    }
    override func viewDidAppear(_ animated: Bool) {
        orderList.reloadData()

    }
    override func viewWillAppear(_ animated: Bool) {
        let db = DatabaseHandler()
        db.sendSpesificServices = self
        db.getSpesificServices(serviceProviderId: s)
        orderList.dataSource = self
        orderList.delegate = self
        orderList.reloadData()

    }
    



}
