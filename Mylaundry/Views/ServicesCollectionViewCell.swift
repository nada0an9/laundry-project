//
//  ServicesCollectionViewCell.swift
//  Mylaundry
//
//  Created by Nada Alansari on 28/05/1443 AH.
//

import UIKit

class ServicesCollectionViewCell: UICollectionViewCell {
    var obj : (() -> Void)? = nil
    var obj2 : (() -> Void)? = nil


    @IBAction func minusBtn(_ sender: Any) {
        if let btnAction = self.obj2
              {
                  btnAction()
              }
    }
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var serviseImage: UIImageView!
    @IBAction func add(_ sender: Any) {
        if let btnAction = self.obj
              {
                  btnAction()
              }
    }
    @IBOutlet weak var qty: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var name: UILabel!
    var id  : String = ""
}
