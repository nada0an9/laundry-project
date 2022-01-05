//
//  OrderViewController.swift
//  Mylaundry
//
//  Created by Nada Alansari on 01/06/1443 AH.
//

import UIKit

class OrderViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var orderArray = [order]()
    
    @IBOutlet weak var orderCollection: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        orderArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "orderCell", for: indexPath as IndexPath) as! OrderCollectionViewCell
        cell.layer.cornerRadius = 12;
        cell.orderId.text =  orderArray[indexPath.row].orderID
        cell.date.text =  orderArray[indexPath.row].orderDate
        cell.status.text =  orderArray[indexPath.row].orderStatus
        cell.providerName.text =  orderArray[indexPath.row].serviceProviderId
        return cell

    }
    override func viewDidAppear(_ animated: Bool) {
        orderCollection.dataSource = self
        orderCollection.delegate = self
        print("viewWillAppear count")
        print(orderArray.count)
        orderCollection.reloadData()
        
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        orderCollection.dataSource = self
        orderCollection.delegate = self
        
        var db = DatabaseHandler()
        db.readAllOrder { ss in
            print("my orders")
            self.orderArray = ss
            for item in ss {
                print(item.orderID)
            }
        }

        // Do any additional setup after loading the view.
    }
    

}
