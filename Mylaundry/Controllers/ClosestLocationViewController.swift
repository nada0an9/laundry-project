//
//  ClosestLocationViewController.swift
//  Mylaundry
//  Created by Nada Alansari on 21/05/1443 AH.

import UIKit
import CoreLocation


class ClosestLocationViewController: UIViewController ,UICollectionViewDataSource, UICollectionViewDelegate {
    
    var s = [services]()
    var closetLocation = [closetProvider]()
    
    var ServicesId : String = ""
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCategory"
        {
            let detailsVC = segue.destination as! CategoryViewController
            detailsVC.id = self.ServicesId
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        closetLocation.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_S", for: indexPath as IndexPath) as! ServicesProviderCollectionViewCell
        cell.layer.cornerRadius = 12;
        cell.nameLable.text =  closetLocation[indexPath.row].name
        var distanse = " "
        distanse += String(round(closetLocation[indexPath.row].distance * 10) / 10.0)
        distanse += " Km"
        cell.distanceLable.text = distanse
        cell.distanceLable.layer.masksToBounds = true
        cell.distanceLable.layer.cornerRadius = 12
        cell.id = closetLocation[indexPath.row].id
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                ServicesId = closetLocation[indexPath.row].id
        performSegue(withIdentifier: "goToCategory", sender: self)
        
    }
    
    @IBOutlet weak var locationLable: UILabel!
    @IBOutlet weak var closetsLocationsCollection: UICollectionView!
 
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        // go to the map view
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "mapId")
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        closetsLocationsCollection.dataSource = self
        closetsLocationsCollection.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ClosestLocationViewController.tapFunction))
        locationLable.isUserInteractionEnabled = true
        locationLable.addGestureRecognizer(tap)

   
        let db = DatabaseHandler()
        db.getCustomerLocation { s in
            print("my area")
            print(s)
            self.locationLable.text = s
            let tap = UITapGestureRecognizer(target: self, action: #selector(ClosestLocationViewController.tapFunction))
                self.locationLable.isUserInteractionEnabled = true
                self.locationLable.addGestureRecognizer(tap)
            
        }
        db.ListClosestServiceProvider { [self] result in
            self.closetLocation = result
            print("closetLocation")
            print(self.closetLocation)
            DispatchQueue.main.async {
                self.closetsLocationsCollection.reloadData()
                
            }
            
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false

    }
    
    
}
