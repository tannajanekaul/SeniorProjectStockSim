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
    
    var handle: AuthStateDidChangeListenerHandle?
    var user: Profile!
    @IBOutlet weak var moneyTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBAction func addMoneyButton(_ sender: Any) {
        
        ref = Database.database().reference()
        
        //get users current money
        let userID = Auth.auth().currentUser?.uid
        self.ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            var userMoney = value?["money"] as? Int
           
            //add 1 dollar to user's money
            userMoney = userMoney! + 100000
            
            //update the value in the database
            let childUpdates = ["/users/" + userID! + "/money": userMoney]
            self.ref.updateChildValues(childUpdates)
            
            //update the user object
            self.user.money = userMoney!
            
            //update the text field
            self.moneyTextField.text = String(self.user.money)
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
    }
    @IBAction func subtractMoneyButton(_ sender: Any) {
        ref = Database.database().reference()
        
        //get users current money
        let userID = Auth.auth().currentUser?.uid
        self.ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            var userMoney = value?["money"] as? Int
            
            //add 1 dollar to user's money
            userMoney = userMoney! - 1
            
            //update the value in the database
            let childUpdates = ["/users/" + userID! + "/money": userMoney]
            self.ref.updateChildValues(childUpdates)
            
            //update the user object
            self.user.money = userMoney!
            
            //update the text field
            self.moneyTextField.text = String(self.user.money)
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.text = user.name
        moneyTextField.text = String(user.money)
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
