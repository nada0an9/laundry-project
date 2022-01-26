//
//  File.swift
//  Mylaundry
//
//  Created by Nada Alansari on 23/06/1443 AH.
//

import UIKit

extension UIView {
    
    func settingCell(){
        self.layer.cornerRadius = 20
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 1
        self.layer.shadowOpacity = 0.3
        
        
    }
}
