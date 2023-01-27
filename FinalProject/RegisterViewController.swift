//
//  RegisterViewController.swift
//  FinalProject
//
//  Created by Tanawit Poumloyfha on 8/12/2564 BE.
//

import UIKit
import GRDB

class RegisterViewController: UIViewController {
    
    var dbPath: String = ""
    var dbResourcePath : String = ""
    var config = Configuration()
    let fileManager = FileManager.default

    @IBOutlet weak var fieldUsername: UITextField!
    @IBOutlet weak var fieldEmail: UITextField!
    @IBOutlet weak var fieldPassword: UITextField!
    @IBOutlet weak var fieldConPass: UITextField!
    @IBOutlet weak var btnCreate: UIButton!
    @IBOutlet weak var fieldMemid: UITextField!
    @IBOutlet weak var fieldFName: UITextField!
    @IBOutlet weak var fieldLName: UITextField!
    
    @IBAction func btnShowPassword(_ sender: Any) {
        let btn: UIButton = sender as! UIButton
        fieldPassword.isSecureTextEntry.toggle()
        btn.setImage(UIImage(systemName: fieldPassword.isSecureTextEntry ? "eye" : "eye.slash"), for: .normal)
    }
    
    @IBAction func btnShowConPass(_ sender: Any) {
        let btn: UIButton = sender as! UIButton
        fieldConPass.isSecureTextEntry.toggle()
        btn.setImage(UIImage(systemName: fieldConPass.isSecureTextEntry ? "eye" : "eye.slash"), for: .normal)
    }
    
    @objc func tap(sender: UITapGestureRecognizer){
            print("tapped")
            view.endEditing(true)
    }
    
    @IBAction func fieldEmail(_ sender: Any) {
        if (fieldEmail.text?.isValidEmail())! == false {
            alertWithTitle(title: "EMAIL ERROR!", message: "Email is in invalid format!")
        }
    }
    
    @IBAction func fieldConPass(_ sender: Any) {
        if fieldPassword.text != fieldConPass.text{
            alertWithTitle(title: "REPASSWORD ERROR!", message: "Incorrect Password")
        }
    }
    
    func alertWithTitle(title: String!, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel,handler: {_ in
            if title=="EMAIL ERROR!"{
                self.fieldEmail.becomeFirstResponder()
            }
            else if title=="MEMID ERROR!"{
                    self.fieldUsername.becomeFirstResponder()
            }
            else if title=="MEMNAME ERROR!"{
                    self.fieldMemid.becomeFirstResponder()
            }
            else if title=="PASSWORD ERROR!"{
                    self.fieldPassword.becomeFirstResponder()
            }
            else if title=="REPASSWORD ERROR!"{
                    self.fieldConPass.becomeFirstResponder()
            }
            else{
//                self.txtRepass.becomeFirstResponder()
            }
        });
        alert.addAction(action)
        self.present(alert, animated: true, completion:nil)
    }
    
    func checkTextfieldisEmpty(){
        if fieldMemid.text!.isEmpty {
            alertWithTitle(title: "MEMID ERROR!", message: "Missing MemberID")
        }
        else if fieldFName.text!.isEmpty {
            alertWithTitle(title: "MEMNAME ERROR!", message: "Missing Name")
        }
        else if fieldPassword.text!.isEmpty {
            alertWithTitle(title: "PASSWORD ERROR!", message: "Missing Password")
        }
        else if fieldConPass.text!.isEmpty {
            alertWithTitle(title: "REPASSWORD ERROR!", message: "Incorrect Password")
        }
        else if fieldEmail.text!.isEmpty {
            alertWithTitle(title: "EMAIL ERROR!", message: "Missing Email")
        }
    }
    
    @IBAction func btnCreate(_ sender: Any) {
        checkTextfieldisEmpty()
        let memid: Int = Int(fieldMemid.text!)!
        
        do {
            config.readonly=false
            let dbQueue = try DatabaseQueue(path: dbPath, configuration: config)
            try dbQueue.write { db in
                try db.execute(sql: "INSERT INTO member (member_id,first_name,last_name,username,email,password,active) VALUES (?, ?, ?, ?, ?, ?, ?)", arguments: [memid, fieldFName.text, fieldLName.text, fieldUsername.text, fieldEmail.text,  fieldPassword.text,1])
                } //try dbQueue.write
//            try dbQueue.write { db in
//                try db.execute(sql: "update member set member_id = (?)", arguments: [memid+1])
//                } //try dbQueue.write
            alertWithTitle(title: "Successfully saved data to database", message: "Success")
        } catch {
            print(error.localizedDescription)
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
    
    func readDB4memberID(){
        do {
        let dbQueue = try DatabaseQueue(path: dbPath, configuration: config)
            try dbQueue.inDatabase { db in
                let rows = try Int.fetchOne(db, sql:
                "SELECT max(member_id) FROM member")
                fieldMemid.text=(rows!+1).description
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
        connect2DB()
        readDB4memberID()
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

extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}
