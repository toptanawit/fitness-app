//
//  ProfileViewController.swift
//  FinalProject
//
//  Created by Tanawit Poumloyfha on 8/12/2564 BE.
//

import UIKit

class ProfileViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var viewBlock: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var fieldUsername: UITextField!
    @IBOutlet weak var fieldEmail: UITextField!
    @IBOutlet weak var fieldPassword: UITextField!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var btnCam: UIButton!
    
    var user: [String] = []
    var defaults = UserDefaults.standard
    
    @IBAction func btnShowPassword(_ sender: Any) {
        let btn: UIButton = sender as! UIButton
        fieldPassword.isSecureTextEntry.toggle()
        btn.setImage(UIImage(systemName: fieldPassword.isSecureTextEntry ? "eye" : "eye.slash"), for: .normal)
    }
    
    @IBAction func btnLogout(_ sender: Any) {
        let storyBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mvc = storyBoard.instantiateViewController(identifier: "LoginVC") as! LoginViewController
        let alert = UIAlertController(title: "Confirm Logout", message: "Are you sure?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Confirm", style: .destructive, handler: {(UIAlertAction) in
            self.defaults.removeObject(forKey: "savedUser")
            self.view.window?.rootViewController = mvc
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: {(UIAlertAction) in
            print("Cancle Logout")
        }))
        
        self.present(alert, animated:  true, completion: {
            print("Showed logout alert")
        })
    }
    
    @IBAction func btnCam(_ sender: Any) {
        let alert = UIAlertController(title: "Change Profile Picture", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Choose from Library", style: .default, handler: {(UIAlertAction) in
            let vc = UIImagePickerController()
            vc.sourceType = .photoLibrary
            vc.delegate = self
            vc.allowsEditing = true
            self.present(vc, animated: true)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: {(UIAlertAction) in
            print("Cancle changing picture")
        }))
        
        self.present(alert, animated:  true, completion: {
            print("Showed alert")
        })
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            imgProfile.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewBlock.layer.cornerRadius = 20
        self.viewBlock.layer.shadowColor = UIColor.gray.cgColor
        self.viewBlock.layer.shadowOpacity = 1
        self.viewBlock.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.viewBlock.layer.shadowRadius = 2
        self.title = "Profile"
        imgProfile.layer.cornerRadius = 20
        btnLogout.layer.cornerRadius = 10
        btnCam.layer.cornerRadius = 10
        
        user = defaults.object(forKey: "savedUser") as! [String]
        self.fieldUsername.text = user[1]
        self.txtName.text = user[2]
        self.fieldEmail.text = user[4]
        self.fieldPassword.text = user[5]
        
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
