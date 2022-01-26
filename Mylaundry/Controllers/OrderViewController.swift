//
//  OrderViewController.swift
//  Mylaundry
//
//  Created by Nada Alansari on 01/06/1443 AH.
//

import UIKit

class OrderViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var orderArray = [order]()
    var selectedOrderId : String = ""
    @IBOutlet weak var orderCollection: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        orderArray.count
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show_det"
        {
            let detailsVC = segue.destination as! OrderDetailsViewController
            detailsVC.orderId = self.selectedOrderId
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "orderCell", for: indexPath as IndexPath) as! OrderCollectionViewCell
        cell.layer.shadowOffset = CGSize(width: 1, height: 1)
        cell.layer.shadowRadius = 3
        cell.layer.shadowOpacity = 3
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.cornerRadius = 12
        cell.orderId.text! +=  orderArray[indexPath.row].orderID
        cell.status.text =  orderArray[indexPath.row].orderStatus
        if(orderArray[indexPath.row].orderStatus == "New Order"){
            cell.orderImage.image = UIImage(named: "image-2.png")
        }
        else if(orderArray[indexPath.row].orderStatus == "completed"){
        cell.orderImage.image = UIImage(named: "image-2-2.png")
        }
        else{
            cell.orderImage.image = UIImage(named: "image-2-3.png")

        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let orderId = orderArray[indexPath.row].orderID
        selectedOrderId = orderId
        performSegue(withIdentifier: "show_det", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orderCollection.dataSource = self
        orderCollection.delegate = self

        let db = DatabaseHandler()
        db.readAllOrder { orderArray in
            print("my orders")
            
          
            self.orderArray = orderArray

            //reload the data
            DispatchQueue.main.async {
                self.orderCollection.reloadData()
            }
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        orderCollection.dataSource = self
        orderCollection.delegate = self

        let db = DatabaseHandler()
        db.readAllOrder { orderArray in
            print("my orders")
            self.orderArray = orderArray
            //reload the data
            DispatchQueue.main.async {
                self.orderCollection.reloadData()
            }
        }
    }
    
    
}
