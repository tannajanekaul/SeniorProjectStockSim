//
//  CelebrityTableViewController.swift
//  StockSim
//
//  Created by Tanna Jane Quale Kaul on 5/16/18.
//  Copyright © 2018 Tanna Jane Quale Kaul. All rights reserved.
//


import UIKit
import TwitterKit
import Firebase

class CelebrityTableViewController: UITableViewController {
    var user: Profile?
    var ref: DatabaseReference!
    var celebrities = [Celebrity]()
    var thisData: Data?
    var thisResponce: URLResponse?
    var globalTableView: UITableView?
    //var i : Int
    var userfollowing : Int?
    let useACAccount = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSampleCelebs()
    }

    @IBAction func buyButton(_ sender: UIButton) {
        ref = Database.database().reference()
        let celebPrice = sender.tag
        //sender is the buy button and sender's tag is the celebrities price
        //does the user have enough money to buy the stock
        if ((user?.money)! >= celebPrice){
            //yes they do.
            
            //subtract the user's money in the object
            user?.money = (user?.money)! - celebPrice
            //subtract the user's money in the database
            let userID = Auth.auth().currentUser?.uid
            self.ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let username = value?["username"] as? String ?? ""
                var userMoney = value?["money"] as? Int
                
                //subtract userMoney by stock price
                userMoney = userMoney! - celebPrice
                
                //update the value in the database
                let childUpdates = ["/users/" + userID! + "/money": userMoney]
                self.ref.updateChildValues(childUpdates)
                
                //update the user object
                //self.user.money = userMoney!
                
                //update the text field
                //self.moneyTextField.text = String(self.user.money)
                
            }) { (error) in
                print(error.localizedDescription)
            }
            //add the stock to the user's object
            
            //add the stock to the user's object in the database
        }
        else{
            let alertController = UIAlertController(title: "Error", message: "You do not have enough money to purchase this stock.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        
    }

    func loadSampleCelebs() {

        let photo1 = UIImage(named: "kimkardashian")
        let photo2 = UIImage(named: "jkrowling")
        let photo3 = UIImage(named: "drake")
        let photo4 = UIImage(named: "beyonce")
        let photo5 = UIImage(named: "diddy")
        let photo6 = UIImage(named: "elonmusk")
        let photo7 = UIImage(named: "travisscott")
        let photo8 = UIImage(named: "kyliejenner")
        
        let kimPrice = 30
        let jkPrice = 1000
        let drakePrice = 1000
        let beyoncePrice = 1000
        let diddyPrice = 1000
        let elonPrice = 1000
        let travisPrice = 1000
        let kyliePrice = 1000
        
        
        guard let kim = Celebrity(name: "Kim Kardashian", price: kimPrice, photo: photo1!) else {
            fatalError("Unable to instantiate celeb")
        }
        
        guard let jk = Celebrity(name: "JK Rowling", price: jkPrice, photo: photo2!) else {
            fatalError("Unable to instantiate celeb")
        }
        
        guard let drake = Celebrity(name: "Drake", price: drakePrice, photo: photo3!) else {
            fatalError("Unable to instantiate celeb")
        }
        guard let beyonce = Celebrity(name: "Beyonce", price: beyoncePrice, photo: photo4!) else {
            fatalError("Unable to instantiate celeb")
        }
        guard let diddy = Celebrity(name: "Diddy", price: diddyPrice, photo: photo5!) else {
            fatalError("Unable to instantiate celeb")
        }
        guard let elonmusk = Celebrity(name: "Elon Musk", price: elonPrice, photo: photo6!) else {
            fatalError("Unable to instantiate celeb")
        }
        guard let travisscott = Celebrity(name: "Travis Scott", price: travisPrice, photo: photo7!) else {
            fatalError("Unable to instantiate celeb")
        }
        guard let kyliejenner = Celebrity(name: "Kylie Jenner", price: kyliePrice, photo: photo8!) else {
            fatalError("Unable to instantiate celeb")
        }
        celebrities += [kim,jk,drake,beyonce,diddy,elonmusk,travisscott,kyliejenner]
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return celebrities.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        globalTableView = tableView
        let cellIdentifier = "CelebrityTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CelebrityTableViewCell  else {
            fatalError("The dequeued cell is not an instance of CelebrityTableViewCell.")
        }
        let celebrity = celebrities[indexPath.row]

        cell.nameLabel.text = celebrity.name
        cell.photoImageView.image = celebrity.photo
        cell.stockPriceTextField.text = String(celebrity.price)
        //let celebString = celebrity.name + " " + String(celebrity.price)
        cell.buyButton.tag = celebrity.price
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
