//
//  SignUpViewController.swift
//  Mylaundry
//
//  Created by Nada Alansari on 21/05/1443 AH.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var mobile: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var email: UITextField!
    
    @IBAction func signUp(_ sender: Any) {
        //object from database
        let db = DatabaseHandler()
        
        //object from customer
        let newUser = customer(customerId: "0", customerName: name.text!, customerEmail: email.text!, customerMobile: mobile.text!, geolat: 4.8765, geolng: 6.8888, administrativeArea: "almadinah", country: "KSA", password: pass.text!)
    
        //ading new user
        db.createCustomer(newUser: newUser)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
