//
//  ServicesCollectionViewCell.swift
//  Mylaundry
//
//  Created by Nada Alansari on 28/05/1443 AH.
//

import UIKit

class ServicesCollectionViewCell: UICollectionViewCell {
    var obj : (() -> Void)? = nil

    @IBAction func add(_ sender: Any) {
        if let btnAction = self.obj
              {
                  btnAction()
              }
        //array of servise id & qty
        //the after confirm the array send it to 
    }
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var qty: UITextField!
    var id  : String = ""
}
