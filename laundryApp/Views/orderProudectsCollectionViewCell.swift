//
//  orderProudectsCollectionViewCell.swift
//  laundryApp
//
//  Created by Nada Alansari on 19/06/1443 AH.
//

import UIKit

class orderProudectsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var qty: UITextField!
    @IBOutlet weak var name: UILabel!
    var btnObject : (() -> Void)? = nil

    @IBOutlet weak var price: UILabel!
    @IBAction func btn(_ sender: Any) {
        if let btnAction = self.btnObject
              {
                  btnAction()
              }
    }
}
