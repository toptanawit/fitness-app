//
//  LoginViewController.swift
//  FinalProject
//
//  Created by Tanawit Poumloyfha on 8/12/2564 BE.
//

import UIKit
import GRDB

class LoginViewController: UIViewController {
    
    var dbPath: String = ""
    var dbResourcePath : String = ""
    var config = Configuration()
    let fileManager = FileManager.default
    var defaults = UserDefaults.standard
    var user:[String]=[]

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var fieldUsername: UITextField!
    @IBOutlet weak var fieldPassword: UITextField!
    @IBOutlet weak var btnSignIn: UIButton!
    
    @IBAction func btnShowPassword(_ sender: Any) {
        let btn: UIButton = sender as! UIButton
        fieldPassword.isSecureTextEntry.toggle()
        btn.setImage(UIImage(systemName: fieldPassword.isSecureTextEntry ? "eye" : "eye.slash"), for: .normal)
    }
    
    @IBAction func btnSignIn(_ sender: Any) {
        print("Sign in Attempt")
        readDB4memberID(memid: fieldUsername.text!, mempass: fieldPassword.text!)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           if let _ = string.rangeOfCharacter(from: NSCharacterSet.decimalDigits) {
           return true
        } else {
           return false
        }
    }
    
    func connect2DB() {
        config.readonly = true
        do {
            dbPath = try fileManager
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("Fitness.db")
            .path
            if !fileManager.fileExists(atPath: dbPath) {
                 dbResourcePath = Bundle.main.path(forResource: "Fitness", ofType: "db")!
                 try fileManager.copyItem(atPath: dbResourcePath, toPath: dbPath)
            }
         } catch {
             print("An error has occured")
         }
    }
    
    func alertWithTitle(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel,handler: { _ in
            if title == "ERROR" {
                self.fieldPassword.becomeFirstResponder()
            }
        });
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func readDB4memberID(memid: String, mempass: String){
        do {
            let dbQueue = try DatabaseQueue(path: dbPath, configuration: config)
            try dbQueue.inDatabase { db in
                let rows = try Row.fetchCursor(db, sql: "select m.member_id , m.username , m.first_name , m.last_name , m.password , m.email from member m where m.active = 1 and m.username = (?) and m.password = (?)", arguments: [memid,mempass])
                while let row = try rows.next() {
                     if memid == row["username"] && mempass == row["password"] {
                        alertWithTitle(title: "Success", message: "Sign In Successful")
                        let storyBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let mvc = storyBoard.instantiateViewController(identifier: "MainNC") as! NavigationViewController
                        user.append(row["member_id"])
                        user.append(row["username"])
                        user.append(row["first_name"])
                        user.append(row["last_name"])
                        user.append(row["email"])
                        user.append(row["password"])
                        defaults.set(user, forKey: "savedUser")
                        self.view.window?.rootViewController = mvc
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connect2DB()
        imgView.layer.cornerRadius = 20
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
