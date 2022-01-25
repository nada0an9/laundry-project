//
//  ServiceProviderDetailsViewController.swift
//  Mylaundry
//
//  Created by Nada Alansari on 22/05/1443 AH.
//

import UIKit

class ServiceProviderDetailsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {
    let db = DatabaseHandler()
    
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
        cell.price.text!  += " RS" 
        cell.qty.text = result[indexPath.row].servicePrice
        
        var image = UIImage(named: "Screen Shot 1443-06-21 at 9.13.36 AM.png")
        cell.serviseImage.layer.cornerRadius = 8.0
        cell.serviseImage.clipsToBounds = false
        cell.serviseImage.layer.shadowOffset = CGSize(width: 0, height: 1)
        cell.serviseImage.layer.shadowColor = UIColor.lightGray.cgColor
        cell.serviseImage.layer.shadowRadius = 5
        cell.serviseImage.layer.shadowOpacity = 0.4
        cell.serviseImage.image = image
        cell.qty.text = "0"
        cell.obj =
        {
            var myString = cell.qty.text!
            if let myNumber = NumberFormatter().number(from: myString) {
                var myInt = myNumber.intValue
                var qyt = myInt
                cell.qty.text = String(qyt+1)
                //when the button is tapped here
                var orderServices = orderServices(serviceID: self.result[indexPath.row].serviceId, servicesQty:  String(qyt+1), servicesName: cell.name.text!, servicesPic: "pic1", servicesPrice: self.result[indexPath.row].servicePrice)
                self.orderdSservicesArray.append(orderServices)
                print("added")
                
            }
            
        }
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
        
        let order = order(orderID: "0", orderDate: formatter3.string(from: today), orderStatus: "new order", serviceProviderId: self.s, coustomerId: UserDefaults.standard.string(forKey: "userId")!, arrOrderServices: self.orderdSservicesArray)
        
        let db = DatabaseHandler()
        db.addOrder(newOrder: order)
    }
    
    @IBOutlet weak var orderList: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        orderList.dataSource = self
        orderList.delegate = self
        
        let db = DatabaseHandler()
        
        db.getSpesificServices(serviceProviderId: s) { services in
            self.result = services
            DispatchQueue.main.async {
                self.orderList.reloadData()
                
            }
            
        }
        
        
    }
    
    
    
    
    
    
}
