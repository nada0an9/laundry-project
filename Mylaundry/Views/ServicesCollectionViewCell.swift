//
//  ServicesCollectionViewCell.swift
//  Mylaundry
//
//  Created by Nada Alansari on 28/05/1443 AH.
//

import UIKit

class ServicesCollectionViewCell: UICollectionViewCell {
    var obj : (() -> Void)? = nil

    @IBOutlet weak var serviseImage: UIImageView!
    @IBAction func add(_ sender: Any) {
        if let btnAction = self.obj
              {
                  btnAction()
              }
    }
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var qty: UITextField!
    var id  : String = ""
}
