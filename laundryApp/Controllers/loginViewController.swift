//
//  loginViewController.swift
//  laundryApp
//
//  Created by Nada Alansari on 15/05/1443 AH.
//

import UIKit

class loginViewController: UIViewController {
    

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    @IBAction func loginBtn(_ sender: Any) {
        var db = DatabaseHandler()
        var logedUser = serviceProviderLogin(email: emailField.text!, password: passwordField.text!)

        db.login(loggedUser: logedUser)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "homeId")
        self.present(vc, animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    



}
