//
//  BuyStockViewController.swift
//  StockSim
//
//  Created by Tanna Jane Quale Kaul on 6/8/18.
//  Copyright © 2018 Tanna Jane Quale Kaul. All rights reserved.
//

import UIKit
import Firebase
class BuyStockViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    var indexToCelebMap = [Int : Celebrity]()
    var user: Profile?
    var currentCelebrityToBuy: Celebrity?
    var celebToBuyInt: Int?
    var numShares: Int?
    /*NOTE FOR WHEN SOBER
      PASS AROUND THE CELEB OBJECT FOR CELEB DATA */
    var pickerData: [String] = [String]()
    var ref: DatabaseReference!
    @IBOutlet weak var marketPriceTextField: UITextField!
    @IBOutlet weak var stockToBuy: UITextField!
    @IBOutlet weak var availableUserMoney: UITextField!
    @IBOutlet weak var estimatedCostTextField: UITextField!
    
    @IBOutlet weak var picker: UIPickerView!

    override func viewDidLoad() {
       
        self.picker.dataSource = self
        self.picker.delegate = self
        super.viewDidLoad()
        availableUserMoney.text = String(describing: (user?.money)!)
        let celeb = indexToCelebMap[celebToBuyInt!]
        currentCelebrityToBuy = celeb
        stockToBuy.text = celeb?.name
        marketPriceTextField.text = String(describing: (celeb?.price)!)
        estimatedCostTextField.text = String(describing: (celeb?.price)!)

        // Connect data:
        for i in 0...99{
            self.pickerData.append(String(i+1))
        }
        //moneyTextField.text = String(user.money)
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerData.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        numShares = row+1
        self.estimatedCostTextField.text = String(numShares!*(currentCelebrityToBuy?.price)!)
    }
    

    @IBAction func buyButton(_ sender: UIButton) {
        ref = Database.database().reference()
        let num = numShares!
        let celebIndex = (currentCelebrityToBuy?.index)!
        let celebPrice = (currentCelebrityToBuy?.price)!
        let totalPrice = Int(self.estimatedCostTextField.text!)!
       //sender is the buy button and sender's tag is the celebrities price
        //does the user have enough money to buy the stock
        if ((user?.money)! >= celebPrice){
            //yes they do.
            
            //subtract the user's money in the object
            user?.money = (user?.money)! - totalPrice
            //subtract the user's money in the database
            let userID = Auth.auth().currentUser?.uid
            self.ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let username = value?["username"] as? String ?? ""
                var userMoney = value?["money"] as? Int
                //subtract userMoney by the estimated cost (stock price * amount of stocks purchased)
                userMoney = userMoney! - totalPrice
                
                //update the value in the database
                let childUpdates = ["/users/" + userID! + "/money": userMoney]
                self.ref.updateChildValues(childUpdates)
                
                //add the stock to the user's object
                var str1: String? = String(describing: num)
                var str2: String? = String(describing: celebIndex)
                var str = str2!+str1!
                self.user?.celebStockList += str + "x"
                
                //add the stock to the user's object in the database
                let childUpdates2 = ["/users/" + userID! + "/celebstocksowned": self.user?.celebStockList]
                self.ref.updateChildValues(childUpdates2)
                
                
                let celebView = self.storyboard?.instantiateViewController(withIdentifier: "CelebrityTableViewController") as! CelebrityTableViewController
                celebView.user = self.user
                self.present(celebView, animated: true, completion: nil)

                
            }) { (error) in
                print(error.localizedDescription)
            }
        }else{
            let alertController = UIAlertController(title: "Error", message: "You do not have enough money to purchase this stock.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
 
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as?
            MainViewController {
            destination.user = self.user
        }
        if let destination = segue.destination as?
            CelebrityTableViewController {
            destination.user = self.user
            destination.indexToCelebMap = self.indexToCelebMap
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
