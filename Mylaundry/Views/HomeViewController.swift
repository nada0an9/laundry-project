//
//  HomeViewController.swift
//  Mylaundry
//
//  Created by Nada Alansari on 22/06/1443 AH.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginBtn.backgroundColor = .clear
        loginBtn.layer.cornerRadius = 5
        loginBtn.layer.borderWidth = 1
        loginBtn.layer.borderColor = UIColor.white.cgColor

    }
    
    



}
