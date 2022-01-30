//
//  ProfileViewController.swift
//  laundryApp
//
//  Created by Nada Alansari on 25/06/1443 AH.
//

import UIKit
import FirebaseStorage
import FirebaseAuth

class ProfileViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var imagePicker = UIImagePickerController()
    @IBOutlet weak var logoImg: UIImageView!
    
    func albumOpen(){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
        
    }
    @IBAction func uploadLogo(_ sender: Any) {
        albumOpen()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
          // Load the image into imageview
        let image = info[.originalImage] as! UIImage
        self.logoImg.image = image
        self.logoImg.layer.masksToBounds = true
        self.logoImg.layer.cornerRadius = logoImg.frame.height/2
          // Convert the image to data
          let data = image.pngData()
        
          // Handle for FB Storage
          let fbStorage = Storage.storage().reference()
        
        // Handle for the image path and name to be saved
        let imgRef = fbStorage.child("Cloud/newimage\(Auth.auth().currentUser?.uid).png")
        
        // Put the data into FB
         imgRef.putData(data!)
         imgRef.downloadURL { url, error in
            print(url)
        }
        print("sucsess")
        dismiss(animated: true, completion: nil)

    }
  


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


}
