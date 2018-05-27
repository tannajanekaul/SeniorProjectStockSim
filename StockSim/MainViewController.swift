//
//  MainViewController.swift
//  StockSim
//
//  Created by Tanna Jane Quale Kaul on 5/15/18.
//  Copyright © 2018 Tanna Jane Quale Kaul. All rights reserved.
//

import UIKit
import Firebase
class MainViewController: UIViewController {
    var handle: AuthStateDidChangeListenerHandle?
    var user: Profile!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var moneyTextField: UITextField!
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
            if let destination = segue.destination as? ProfileViewController {
                destination.user = self.user
            }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        usernameTextField.text = user.name
        moneyTextField.text = String(user.money)
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
