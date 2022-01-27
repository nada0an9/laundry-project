//
//  ServiceProviderDetailsViewController.swift
//  Mylaundry
//
//  Created by Nada Alansari on 22/05/1443 AH.
//

import UIKit

class ServiceProviderDetailsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    let db = DatabaseHandler()
    var result = [services]()
    var s :String = ""
    var total = [Int]()
    var g = 0
    @IBOutlet weak var totalLable: UILabel!
    
    var orderdSservicesArray = [orderServices]()
    var searching:Bool = false
    var filteredArr = Array<services>()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(searching == false){
            return result.count
        }
        else{
            return filteredArr.count
        }
        
    }
    @IBOutlet weak var searchBar: UISearchBar!
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        db.getSpesificServices(serviceProviderId: s) { services in
            self.result = services
            self.filteredArr = self.result.filter{$0.serviceName.contains(searchBar.searchTextField.text!)}
            self.searching = true
            DispatchQueue.main.async {
                self.orderList.reloadData()
                print(self.result.count)
                self.orderList.reloadData()
                
            }
            
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.orderList.reloadData()
        print(self.result.count)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServicesCell", for: indexPath as IndexPath) as! ServicesCollectionViewCell
        if(searching == false){
            cell.layer.cornerRadius = 12;
            cell.name.text =  result[indexPath.row].serviceName
            cell.price.text = result[indexPath.row].servicePrice
            cell.price.text!  += " RS"
            cell.qty.text = result[indexPath.row].servicePrice
            cell.qty.text = "0"
            switch result[indexPath.row].serviceName {
            case "Shirt":
                let image = UIImage(named: "shirt.png")
                cell.serviseImage.image = image
            case  "T shirt" :
                let image = UIImage(named: "tshirt.png")
                cell.serviseImage.image = image
            case  "Pant" :
                let image = UIImage(named: "Pant.png")
                cell.serviseImage.image = image
            case  "Dress" :
                let image = UIImage(named: "Dress.png")
                cell.serviseImage.image = image
            default:
                let image = UIImage(named: "shirt.png")
                cell.serviseImage.image = image
            }
            cell.obj =
            { [self] in
                let myString = cell.qty.text!
                if let myNumber = NumberFormatter().number(from: myString) {
                    let myInt = myNumber.intValue
                    let qyt = myInt
                    cell.qty.text = String(qyt+1)
                    
                    
                    
                    //when the button is tapped here
                    let orderServices = orderServices(serviceID: self.result[indexPath.row].serviceId, servicesQty:  String(qyt+1), servicesName: cell.name.text!, servicesPic: "pic1", servicesPrice: self.result[indexPath.row].servicePrice)
                    self.orderdSservicesArray.append(orderServices)
                    
                    
                    
                    
                    if let myNumber = NumberFormatter().number(from: self.result[indexPath.row].servicePrice) {
                        let myInt = myNumber.intValue
                        let price = myInt
                        self.g += price
                        self.totalLable.text = String(self.g)
                        
                    }
                    print("added")
                }
            }
            
            cell.obj2 =
            { [self] in
                let myString = cell.qty.text!
                if let myNumber = NumberFormatter().number(from: myString) {
                    let myInt = myNumber.intValue
                    let qyt = myInt
                    cell.qty.text = String(qyt - 1)
                    //when the button is tapped here
                    let orderServices = orderServices(serviceID: self.result[indexPath.row].serviceId, servicesQty:  String(qyt-1), servicesName: cell.name.text!, servicesPic: "pic1", servicesPrice: self.result[indexPath.row].servicePrice)
                    
                    if let myNumber = NumberFormatter().number(from: self.result[indexPath.row].servicePrice) {
                        var myInt = myNumber.intValue
                        let price = myInt
                        var s = self.total.reduce(0, +)
                        s -= price
                        self.totalLable.text = String(self.total.reduce(0, +))
                        
                        
                    }
                    print("mmmmmm")
                }
            }
            return cell
        }
        else{
            cell.layer.cornerRadius = 12;
            cell.name.text =  filteredArr[indexPath.row].serviceName
            cell.price.text = filteredArr[indexPath.row].servicePrice
            cell.price.text!  += " RS"
            cell.qty.text = filteredArr[indexPath.row].servicePrice
            switch result[indexPath.row].serviceName {
            case "Shirt":
                let image = UIImage(named: "shirt.png")
                cell.serviseImage.image = image
            case  "T shirt" :
                let image = UIImage(named: "tshirt.png")
                cell.serviseImage.image = image
            case  "Pant" :
                let image = UIImage(named: "Pant.png")
                cell.serviseImage.image = image
            case  "Dress" :
                let image = UIImage(named: "Dress.png")
                cell.serviseImage.image = image
            default:
                let image = UIImage(named: "shirt.png")
                cell.serviseImage.image = image
                
            }
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
                    
                    
                    if let myNumber = NumberFormatter().number(from: self.result[indexPath.row].servicePrice) {
                        let myInt = myNumber.intValue
                        let price = myInt
                        self.g += price
                        self.totalLable.text = String(self.g)
                        
                        
                    }
                }
                
            }
            cell.obj2 =
            {
                var myString = cell.qty.text!
                if let myNumber = NumberFormatter().number(from: myString) {
                    var myInt = myNumber.intValue
                    var qyt = myInt
                    cell.qty.text = String(qyt - 1)

                    if let myNumber = NumberFormatter().number(from: self.result[indexPath.row].servicePrice) {
                        let myInt = myNumber.intValue
                        let price = myInt
                        self.g -= price
                        self.totalLable.text = String(self.g)
                        
                        
                    }
                }
                
            }
            return cell
        }
    }
    
    func readProviderServices(myServices: [services]) {
        result = myServices
        print("my services")
        
        print(myServices)
    }
    
    @IBAction func confirmOrder(_ sender: Any) {
        if  (self.orderdSservicesArray.count == 0){
            
            let alert = UIAlertController(title: "Alert", message: "Your Cart Is Empty ", preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        let today = Date()
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "HH:mm E, d MMM y"
        
        let order = order(orderID: "0", orderDate: formatter3.string(from: today), orderStatus: "New Order", serviceProviderId: self.s, coustomerId: UserDefaults.standard.string(forKey: "userId")!, arrOrderServices: self.orderdSservicesArray)
        
        let db = DatabaseHandler()
        db.addOrder(newOrder: order)
    }
    @IBOutlet weak var btn2: UIButton!
    
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var orderList: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        btn.layer.cornerRadius = 25
        btn2.layer.cornerRadius = 5
        orderList.dataSource = self
        orderList.delegate = self
        searchBar.delegate = self
        searchBar.searchTextField.backgroundColor = UIColor.white
        db.getSpesificServices(serviceProviderId: s) { services in
            self.result = services
            
            DispatchQueue.main.async {
                self.orderList.reloadData()
                print(self.result.count)
                self.orderList.reloadData()
                
                
            }
            
        }
        
        
    }
    
}
