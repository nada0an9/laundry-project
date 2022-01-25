//
//  SignUpViewController.swift
//  Mylaundry
//
//  Created by Nada Alansari on 21/05/1443 AH.
//

import UIKit
import FirebaseAuth
class SignUpViewController: UIViewController {
    
    @IBOutlet weak var mobile: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var email: UITextField!
    
    @IBAction func signUp(_ sender: Any) {
        
        Auth.auth().createUser(withEmail: email.text ?? "", password: pass.text ?? "") { result, error in
            if(error == nil){
                let logedUserId  = result?.user.uid
                print(logedUserId!)
                //object from database
                let db = DatabaseHandler()
                //object from customer
                let newUser = customer(customerId: logedUserId!, customerName: self.name.text!, customerMobile: self.mobile.text!)
                //ading new user
                db.createCustomer(newUser: newUser)
                //add the customer to the customer colllection
                print("Customer Added sucsessfuly")
            }
            else{
                if let error = error, let errorCode = AuthErrorCode(rawValue: error._code) {
                    switch errorCode {
                    case .weakPassword:
                        let alert = UIAlertController(title: "Weak password", message: "The password you entered is not strong enough with varied characters. Please try a different password", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: { (action: UIAlertAction!) in
                            
                        }))
                        self.present(alert, animated: true, completion: {() -> Void in })
                    case .emailAlreadyInUse:
                        let alert = UIAlertController(title: "Account exists", message: "The email address already exists. Either login with the password for that address or click the help button if you have forgotten your password", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: { (action: UIAlertAction!) in
                            
                        }))
                        self.present(alert, animated: true, completion: {() -> Void in })
                    case .invalidEmail:
                        let alert = UIAlertController(title: "Incorrect Email Address", message: "The email address you entered doesn't appear to belong to an account. Please check your address and try again", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: { (action: UIAlertAction!) in
                            
                        }))
                        self.present(alert, animated: true, completion: {() -> Void in })
                    default:
                        let alert = UIAlertController(title: "There is an error", message: "Here is the message from Firebase: \(error.localizedDescription)", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: { (action: UIAlertAction!) in
                            
                            
                        }))
                        
                        self.present(alert, animated: true, completion: {() -> Void in })
                    }
                }
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    
}
