//
//  orderProudectsCollectionViewCell.swift
//  Mylaundry
//
//  Created by Nada Alansari on 18/06/1443 AH.
//

import UIKit

class orderProudectsCollectionViewCell: UICollectionViewCell {
    var obj : (() -> Void)? = nil

    @IBAction func update(_ sender: Any) {
        if let btnAction = self.obj
              {
                  btnAction()
              }
    }
    @IBOutlet weak var qty: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var name: UILabel!
    
    
}
