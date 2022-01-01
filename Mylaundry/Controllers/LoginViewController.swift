//
//  LoginViewController.swift
//  Mylaundry
//
//  Created by Nada Alansari on 21/05/1443 AH.
//

import UIKit

class LoginViewController: UIViewController {

    @IBAction func loginBtn(_ sender: Any) {
        let db = DatabaseHandler()
        var logedUser = customerLogin(email: email.text!, password: password.text!)
        db.customerLogin(loggedUser: logedUser)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "homeId")
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


}
