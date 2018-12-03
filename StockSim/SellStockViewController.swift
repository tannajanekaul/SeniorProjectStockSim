//
//  SellStockViewController.swift
//  StockSim
//
//  Created by Tanna Jane Quale Kaul on 6/8/18.
//  Copyright © 2018 Tanna Jane Quale Kaul. All rights reserved.
//

import UIKit
import Firebase

class SellStockViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    var pickerData: [String] = [String]()
    var indexToCelebMap = [Int : Celebrity]()
    var currentCelebrityToBuy: Celebrity?
    var celebToBuyInt: Int?
    var user: Profile?
    var numShares: Int?
    var totalSoldMoney: Int?
    var ref: DatabaseReference!

    @IBOutlet weak var moneyAvailable: UITextField!
    @IBOutlet weak var estimatedValueTextField: UITextField!
    @IBOutlet weak var marketPriceTextField: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var currentStockTextField: UITextField!
    
    override func viewDidLoad() {
        numShares = 1
        self.picker.dataSource = self
        self.picker.delegate = self
        super.viewDidLoad()
        
        let celeb = indexToCelebMap[celebToBuyInt!]
        currentCelebrityToBuy = celeb
        self.currentStockTextField.text = celeb?.name
        self.marketPriceTextField.text = String(describing: (celeb?.price)!)
        self.estimatedValueTextField.text = String(describing: (celeb?.price)!)
        
        // Do any additional setup after loading the view.
        // Connect data:
        for i in 0...99{
            self.pickerData.append(String(i+1))
        }
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
        totalSoldMoney = numShares!*((currentCelebrityToBuy?.price)!)
        self.estimatedValueTextField.text = String(numShares!*(currentCelebrityToBuy?.price)!)
    }

    @IBAction func sellButton(_ sender: UIButton) {
        ref = Database.database().reference()
        let stockList = user?.celebStockList.split(separator:"x")
        var doesUserHaveStock = false
        var newStockString = ""
        for stock in stockList! {
            let str = ""
            let stockString = String(stock)
            let celeb = Int(String(stockString.first!))
            let shares = Int(String(stockString.last!))
            let index = currentCelebrityToBuy?.index
            if (index == celeb && numShares! <= shares!) {
                doesUserHaveStock = true
            }
        }
        
        
        
        if (doesUserHaveStock) {
            for stock in stockList! {
                let stockString = String(stock)
                let celeb = Int(String(stockString.first!))
                let index = currentCelebrityToBuy?.index
                let shares = Int(String(stockString.last!))
                let newShares = shares! - numShares!
                let newString = String(describing: index!) + String(describing: newShares)
                
                if (index == celeb) {
                    user?.celebStockList = (user?.celebStockList.replacingOccurrences(of: stockString, with: newString))!
//                    newStockString = newStockString + String(describing: celeb);
//                    newStockString = newStockString + String(describing: newShares);
//                    newStockString = newStockString + "x"
                } else {
//                    newStockString = newStockString + String(describing: stock)
//                    newStockString = newStockString + "x"
                }
            }
        }
        
        if (doesUserHaveStock) {
            //subtract stock from stock list
            //subtract money in object
            //subtract money and stock in database
            
            let moneyEarned = (currentCelebrityToBuy?.price)!*numShares!
            user?.money = (user?.money)! + moneyEarned
            let userID = Auth.auth().currentUser?.uid
            
            self.ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let username = value?["username"] as? String ?? ""
                var userMoney = value?["money"] as? Int
                //subtract userMoney by the estimated cost (stock price * amount of stocks purchased)
                userMoney = userMoney! + moneyEarned
                
                //update the value in the database
                let childUpdates = ["/users/" + userID! + "/money": userMoney]
                self.ref.updateChildValues(childUpdates)
                
                //add the stock to the user's object

                //add the stock to the user's object in the database
                let childUpdates2 = ["/users/" + userID! + "/celebstocksowned": self.user?.celebStockList]
                self.ref.updateChildValues(childUpdates2)
//
//
                let profileView = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                profileView.user = self.user
                self.present(profileView, animated: true, completion: nil)
                
                
            }) { (error) in
                print(error.localizedDescription)
            }
            
            
        } else {
    //error out, do
            let alertController = UIAlertController(title: "Error", message: "You do not have enough of this stock to sell.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destination = segue.destination as?
            MainViewController {
            destination.user = self.user
        }
        if let destination = segue.destination as?
            CelebrityTableViewController {
            destination.user = self.user
            destination.indexToCelebMap = self.indexToCelebMap
        }
    }
    

}
