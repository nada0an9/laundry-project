//
//  OrderDetailsViewController.swift
//  Mylaundry
//
//  Created by Nada Alansari on 03/06/1443 AH.
//

import UIKit

class OrderDetailsViewController: UIViewController{
    
    @IBOutlet weak var collection: UICollectionView!
    @IBAction func cancel(_ sender: Any) {
        
        
        db.orderDetails(orderId: orderId) { order, orderServices2 in
            if  (order.orderStatus == "completed" || order.orderStatus == "in collect" ){
                
                let alert = UIAlertController(title: "Alert", message: "You can't cancel this order ", preferredStyle: UIAlertController.Style.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
            else{
                
                self.db.cancelOrder(orderId: self.orderId)
                self.navigationController?.popViewController(animated: true)
                
            }
        }}
    
    
    
    
    
    var db = DatabaseHandler()
    @IBOutlet weak var providerName: UILabel!
    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var servisesCollection: UICollectionView!
    @IBOutlet weak var orderStatus: UILabel!
    var orderId : String = ""
    var orderServices = [orderServices2]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.dataSource = self
        collection.delegate = self
        
        db.orderDetails(orderId: orderId) { order, orderServices in
            self.providerName.text = order.serviceProviderId
            self.orderDate.text = order.orderDate
            self.orderStatus.text = order.orderStatus
            self.orderServices = orderServices
            DispatchQueue.main.async {
                self.collection.reloadData()
            }
        }
        print(orderId)
        
    }
    
}

extension OrderDetailsViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        orderServices.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "orderProudectsCollectionViewCell", for: indexPath as IndexPath) as! orderProudectsCollectionViewCell
        cell.layer.cornerRadius = 12;
        cell.name.text =  orderServices[indexPath.row].servicesName
        cell.qty.text = orderServices[indexPath.row].servicesQty
        cell.id = orderServices[indexPath.row].serviceID
        cell.price.text =  orderServices[indexPath.row].servicesPrice
        cell.obj =
        {
            var myString = cell.qty.text!
            if let myNumber = NumberFormatter().number(from: myString) {
                var myInt = myNumber.intValue
                var qyt = myInt
                cell.qty.text = String(qyt+1)
                DispatchQueue.main.async {
                    self.db.updateOrder(updatedOrderID: self.orderId, qty:String(qyt+1), serviseID: self.orderServices[indexPath.row].serviceID)
                    self.collection.reloadData()
                }
            }
        
        }
        return cell
        
    }
    
    
    
    
    
    
}
