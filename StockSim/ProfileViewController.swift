//
//  ProfileViewController.swift
//  StockSim
//
//  Created by Tanna Jane Quale Kaul on 5/15/18.
//  Copyright © 2018 Tanna Jane Quale Kaul. All rights reserved.
//

import UIKit
import Firebase
class ProfileViewController: UIViewController {
    var ref: DatabaseReference!
    var celebDict = [String : Int]()
    var handle: AuthStateDidChangeListenerHandle?
    var user: Profile!
    @IBOutlet weak var moneyTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var stocksOwned: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        celebDict["Kim Kardashian"] = 0
        celebDict["JK Rowling"] = 1
        celebDict["Drake"] = 2
        celebDict["Beyonce"] = 3
        celebDict["Diddy"] = 4
        celebDict["Elon Musk"] = 5
        celebDict["Travis Scott"] = 6
        celebDict["Kylie Jenner"] = 7
        usernameTextField.text = user.name
        moneyTextField.text = String(user.money)
        let stockList = user?.celebStockList.split(separator:"x")
        for stock in stockList! {
            let stockString = String(stock)
            let celeb = Int(String(stockString.first!))
            let shares = Int(String(stockString.last!))
            var celebName = ""
            for (str, val) in celebDict {
                if (val == celeb) {
                    celebName = str
                }
            }
            stocksOwned.text = stocksOwned.text! + celebName + " Shares: " + String(describing: shares!)
            stocksOwned.text = stocksOwned.text! + "\n"
        }
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destination = segue.destination as? MainViewController {
            destination.user = self.user
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            // ...
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }

}
