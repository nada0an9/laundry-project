//
//  AllOrdersViewController.swift
//  laundryApp
//
//  Created by Nada Alansari on 18/06/1443 AH.
//

import UIKit

class AllOrdersViewController: UIViewController ,UICollectionViewDataSource, UICollectionViewDelegate{
    
    var orderArray = [order]()
    var selectedOrderId : String = ""
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show_det"
        {
            let detailsVC = segue.destination as! OrderDetailsViewController
            detailsVC.orderId = self.selectedOrderId
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        orderArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = orderLists.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath as IndexPath) as! CollectionViewCell
        
        cell.layer.cornerRadius = 12;
        
        cell.name.text =  orderArray[indexPath.row].customer.customerName
        cell.date.text = orderArray[indexPath.row].orderDate
        cell.mobile.text = orderArray[indexPath.row].customer.customerMobile
        cell.status.text = orderArray[indexPath.row].orderStatus
        return cell
        
        
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let orderId = orderArray[indexPath.row].orderID
        selectedOrderId = orderId
        performSegue(withIdentifier: "show_det", sender: self)
    }
    
    
    @IBOutlet weak var orderSatutesSegement: UISegmentedControl!
    @IBOutlet weak var orderLists: UICollectionView!
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
        var filtredAray = orderArray
        if orderSatutesSegement.selectedSegmentIndex == 0 {
            let db = DatabaseHandler()
            db.readAllOrder { orders in
                DispatchQueue.main.async {
                    self.orderArray = orders.filter { $0.orderStatus == "new order" }
                    print(self.orderArray)
                    self.orderLists.reloadData()
                }
            }
            
        } else if orderSatutesSegement.selectedSegmentIndex == 1 {
            let db = DatabaseHandler()
            db.readAllOrder { orders in
                DispatchQueue.main.async {
                    self.orderArray = orders.filter { $0.orderStatus == "completed" }
                    print(self.orderArray)
                    self.orderLists.reloadData()
                }
            }
            
            
            
        } else {
            
            
            let db = DatabaseHandler()
            db.readAllOrder { orders in
                DispatchQueue.main.async {
                    self.orderArray = orders.filter { $0.orderStatus == "in collect" }
                    print(self.orderArray)
                    self.orderLists.reloadData()
                }
            }
            
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orderLists.dataSource = self
        orderLists.delegate = self
        orderSatutesSegement.addTarget(self, action: #selector(AllOrdersViewController.indexChanged(_:)), for: .valueChanged)
        
        
        let db = DatabaseHandler()
        db.readAllOrder { orders in
            DispatchQueue.main.async {
                self.orderArray = orders.filter { $0.orderStatus == "new order" }
                print(self.orderArray)
                self.orderLists.reloadData()
            }
        }
        
        
    }
    
    
    
}
