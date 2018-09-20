//
//  LoginViewController.swift
//  StockSim
//
//  Created by Tanna Jane Quale Kaul on 5/15/18.
//  Copyright © 2018 Tanna Jane Quale Kaul. All rights reserved.
//

import UIKit
import Firebase
import CoreFoundation

class LoginViewController: UIViewController {
    var handle: AuthStateDidChangeListenerHandle?
    var user: Profile!
    var ref: DatabaseReference!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBAction func loginButton(_ sender: Any) {
        ref = Database.database().reference()
        Auth.auth().signIn(withEmail: usernameTextField.text!, password: passwordTextField.text!) { (userData, error) in
            if error == nil{
                //user signed in
                let userID = Auth.auth().currentUser?.uid
                self.ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get user value
                    let value = snapshot.value as? NSDictionary
                    let username = value?["username"] as? String ?? ""
                    let money = value?["money"] as? Int
                    //var celebStockList = value?["celebStockList"] as? [(celeb: Celebrity, shares: Int)]
                    self.user = Profile(name: username, money:money!,celebStockList: [])
                    
                    
                    
                    
                    
                    let mainView = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                    mainView.user = self.user
                    //self.performSegue(withIdentifier: "MainViewController", sender: Any?.self)
                    //self.navigationController?.pushViewController(mainView, animated: true)
                    self.present(mainView, animated: true, completion: nil)
                }) { (error) in
                    print(error.localizedDescription)
                }
            
            } else {
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            }

        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.destination is MainViewController){
            let mainView = segue.destination as! MainViewController
            mainView.user = self.user
        }
    }
    @IBAction func signUpButton(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
