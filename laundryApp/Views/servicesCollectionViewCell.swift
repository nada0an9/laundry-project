//
//  servicesCollectionViewCell.swift
//  laundryApp
//
//  Created by Nada Alansari on 19/05/1443 AH.
//

import UIKit

class servicesCollectionViewCell: UICollectionViewCell {
    
    @IBAction func saveBtn(_ sender: Any) {
        if let btnAction = self.btnObject
              {
                  btnAction()
              }
    }
    var btnObject : (() -> Void)? = nil

    @IBOutlet weak var onOrOff: UISwitch!
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var servicePic: UIImageView!
    @IBOutlet weak var priceText: UITextField!
    
}
