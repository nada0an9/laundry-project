//
//  CategoryViewController.swift
//  Mylaundry
//
//  Created by Nada Alansari on 20/06/1443 AH.
//

import UIKit

class CategoryViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categoryImage.count
    }
    
    @IBOutlet weak var categoryCellView: UIView!

    @IBOutlet weak var categoryCollection: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! CategoryCollectionViewCell
        cell.catergoryImage.clipsToBounds = false
        cell.catergoryImage.image = categoryImage[indexPath.row]
        return cell
        
            
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "", sender: self)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryCollection.dataSource = self
        categoryCollection.delegate = self
//        settingCell()
  
    }
    
    
    var categoryImage: [UIImage] = [
        UIImage(named: "laundry-app-design-8.png")!,
        UIImage(named: "laundry-app-design-10.png")!,
        UIImage(named: "laundry-app-design-11.png")!,
        UIImage(named: "laundry-app-design-12.png")!,
        UIImage(named: "laundry-app-design-13.png")!,
        UIImage(named: "laundry-app-design-14.png")!

    ]



}
