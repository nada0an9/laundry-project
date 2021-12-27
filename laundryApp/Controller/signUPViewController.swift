

import UIKit

class signUPViewController: UIViewController {


    @IBAction func signUpBtn(_ sender: Any) {
        
        //object from database
        var db = DatabaseHandler()
        
        //object from serviceProvider
        var newUser = serviceProvider(id: "0", companyName: laundaryName.text!, password: passwordField.text!, email: emailField.text!, commericalNumber: commericalNumbers.text!, geolat: 33.77, geolng: 77.98765, address: "")
        
        //ading new user
        db.createServiceProvider(newUser: newUser)
        
    }
    @IBOutlet weak var commericalNumbers: UITextField!
    @IBOutlet weak var laundaryName: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    override func viewDidLoad() {
    super.viewDidLoad()

    
    }
    

}
