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
    
    var id = ""
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show_servises"
        {
            let detailsVC = segue.destination as! ServiceProviderDetailsViewController
            detailsVC.s = self.id
        }
        
    }
    @IBOutlet weak var categoryCollection: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! CategoryCollectionViewCell
        cell.catergoryImage.clipsToBounds = false
        cell.catergoryImage.image = categoryImage[indexPath.row]
        return cell
        
            
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "show_servises", sender: self)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryCollection.dataSource = self
        categoryCollection.delegate = self
  
    }
    
    
    var categoryImage: [UIImage] = [
        UIImage(named: "powder.png")!,
        UIImage(named: "deep.png")!,
        UIImage(named: "dry.png")!,
        UIImage(named: "stream.png")!,
        UIImage(named: "washing.png")!,
        UIImage(named: "formal.png")!

    ]



}
