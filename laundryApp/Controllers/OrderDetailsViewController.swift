//
//  OrderDetailsViewController.swift
//  laundryApp
//
//  Created by Nada Alansari on 19/06/1443 AH.
//

import UIKit

class OrderDetailsViewController: UIViewController ,UICollectionViewDataSource, UICollectionViewDelegate{
    
    var orderService = [orderServices]()
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderService.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "orderProudectsCollectionViewCell", for: indexPath as IndexPath) as! orderProudectsCollectionViewCell
        cell.layer.cornerRadius = 12;
        cell.name.text =  orderService[indexPath.row].servicesName
        cell.qty.text = orderService[indexPath.row].servicesQty
        
        return cell
    }
    
    var orderId = ""

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var mobile: UILabel!
    @IBOutlet weak var orderStatusSegemnt: UISegmentedControl!
    @IBOutlet weak var orderProudectCollection: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orderStatusSegemnt.addTarget(self, action: #selector(OrderDetailsViewController.indexChanged(_:)), for: .valueChanged)
        orderProudectCollection.delegate = self
        orderProudectCollection.dataSource = self
        let db = DatabaseHandler()
        db.readOrderDeatails(orderId: orderId) { order, orderServices in
            DispatchQueue.main.async {
                self.orderService = orderServices
                self.orderProudectCollection.reloadData()
                
                self.name.text = order.customer.customerName
                self.mobile.text = order.customer.customerMobile
                self.orderDate.text = order.orderDate
                if(order.orderStatus == "new order"){
                    self.orderStatusSegemnt.selectedSegmentIndex = 0
                }
                else if(order.orderStatus == "completed"){
                    self.orderStatusSegemnt.selectedSegmentIndex = 1
                }
                else{
                    self.orderStatusSegemnt.selectedSegmentIndex = 3
                }
                
            }
        }
        
    }
    @objc func indexChanged(_ sender: UISegmentedControl) {
        let db = DatabaseHandler()
        
        if orderStatusSegemnt.selectedSegmentIndex == 0 {
            db.updatedOrdersStatus(orderId: orderId, status: "new order")
            
        } else if orderStatusSegemnt.selectedSegmentIndex == 1 {
            db.updatedOrdersStatus(orderId: orderId, status: "completed")
            
        } else {
            db.updatedOrdersStatus(orderId: orderId, status: "in collect")
            
        }
        
        
        
    }
    
    
}

