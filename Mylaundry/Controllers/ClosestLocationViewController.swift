//
//  ClosestLocationViewController.swift
//  Mylaundry
//  Created by Nada Alansari on 21/05/1443 AH.

import UIKit
import CoreLocation


class ClosestLocationViewController: UIViewController ,DatabaseDategate,UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var LoctionLable: UILabel!
    
    var s = [services]()
    var closetLocation = [closetProvider]()
    var ServicesId : String = ""
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show_det"
        {
            let detailsVC = segue.destination as! ServiceProviderDetailsViewController
            detailsVC.s = self.ServicesId
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        closetLocation.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_S", for: indexPath as IndexPath) as! ServicesProviderCollectionViewCell
        cell.layer.cornerRadius = 12;
        cell.nameLable.text =  closetLocation[indexPath.row].name
        cell.distanceLable.text = String(closetLocation[indexPath.row].distance)
        cell.id = closetLocation[indexPath.row].id
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        ServicesId = closetLocation[indexPath.row].id
        performSegue(withIdentifier: "show_det", sender: self)
        
    }
    
    @IBOutlet weak var closetsLocationsCollection: UICollectionView!
    
    func readAllClosestServices(result: [closetProvider]) {
        print("now we comeee")
        print(result)
        closetLocation = result
    }
    
    @IBAction func tapFunction(sender: UITapGestureRecognizer) {
           print("tap working")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "mapId")
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
       }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let db = DatabaseHandler()
        db.getCustomerLocation { s in
            print("my area")
            print(s)
            self.LoctionLable.text = s
        }
 
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ClosestLocationViewController.tapFunction))
        LoctionLable.isUserInteractionEnabled = true
        LoctionLable.addGestureRecognizer(tap)
        
        db.delegate = self
        db.ListClosestServiceProvider()
        closetsLocationsCollection.reloadData()
        print("here we are")
 
 
        
    }
    override func viewDidAppear(_ animated: Bool) {
        closetsLocationsCollection.dataSource = self
        closetsLocationsCollection.delegate = self
        print("viewWillAppear count")
        print(closetLocation.count)
        closetsLocationsCollection.reloadData()
        
    }
    
}
