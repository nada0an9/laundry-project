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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath as IndexPath) as! CategoryCollectionViewCell
        cell.layer.cornerRadius = 12
        
        cell.categoryImage.layer.cornerRadius = 16
        cell.categoryImage.clipsToBounds = true
        cell.categoryImage.image = categoryImage[indexPath.row]
        let layer = cell.layer
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 6
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.5
        layer.frame = cell.frame
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "", sender: self)
    }
    @IBOutlet weak var categoryCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryCollection.dataSource = self
        categoryCollection.delegate = self
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
