//
//  ViewController.swift
//  StockSim
//
//  Created by Tanna Jane Quale Kaul on 5/15/18.
//  Copyright © 2018 Tanna Jane Quale Kaul. All rights reserved.
//

import UIKit
import Firebase

//Sign Up View Controller
class ViewController: UIViewController {
    var ref: DatabaseReference!
    
     var handle: AuthStateDidChangeListenerHandle?
    //properties
    var user: Profile!
    let baseMoney = 1000000
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var UsernameTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        ref = Database.database().reference()
        Auth.auth().createUser(withEmail: UsernameTextField.text!, password: PasswordTextField.text!, completion: { (authData, error)  in
            if error == nil {
                self.user = Profile(name: self.UsernameTextField.text!, money:self.baseMoney)
                //print(self.ref.debugDescription)
                let userId = Auth.auth().currentUser!.uid
                self.ref.child("users/\(userId)/username").setValue(self.user.name)
                self.ref.child("users/\(userId)/money").setValue(self.user.money)
                
               // var authD = authData
               // var user = authData!.user
               // var x = authData?.value(forKey: "uid")
                
                
                let loginView = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                //self.present(vc, animated: true, completion: nil)
                self.navigationController?.pushViewController(loginView, animated: true)
                
            }else{
                //print(error!.localizedDescription)
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
            
        })
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

