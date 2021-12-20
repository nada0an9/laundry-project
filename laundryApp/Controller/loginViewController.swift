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
    
        performSegue(withIdentifier: "home", sender: self)
//        if(s == true){
//            print("true")
//            performSegue(withIdentifier: "home", sender: self)
//        }
//        else{
//            print("cannot login")
//        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    



}
