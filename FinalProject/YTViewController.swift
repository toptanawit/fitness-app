//
//  YTViewController.swift
//  FinalProject
//
//  Created by Tanawit Poumloyfha on 8/12/2564 BE.
//

import UIKit
import WebKit

class YTViewController: UIViewController, WKUIDelegate {

    @IBOutlet weak var ytView: WKWebView!
    
    public var ytLink: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let encodedURL = ytLink.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let myURL = URL(string: encodedURL!)
        let myRequest = URLRequest(url: myURL!)
        ytView.load(myRequest)

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
