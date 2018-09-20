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
    var indexToCelebMap = [Int : Celebrity]()
    var thisResponce: URLResponse?
    var globalTableView: UITableView?
    //var i : Int
    var userfollowing : Int?
    let useACAccount = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.navigationController?.navigationBar.isHidden = false
        loadSampleCelebs()
    }

    
    @IBAction func sellButton(_ sender: UIButton) {
        let celebIndex = sender.tag
        let sellStockView = self.storyboard?.instantiateViewController(withIdentifier: "SellStockViewController") as! SellStockViewController
        sellStockView.celebToBuyInt = celebIndex
        sellStockView.user = self.user
        sellStockView.indexToCelebMap = self.indexToCelebMap
        self.present(sellStockView, animated: true, completion: nil)
    }
    
    @IBAction func buyButton(_ sender: UIButton) {
        let celebIndex = sender.tag
        let buyStockView = self.storyboard?.instantiateViewController(withIdentifier: "BuyStockViewController") as! BuyStockViewController
        buyStockView.celebToBuyInt = celebIndex
        buyStockView.user = self.user
        buyStockView.indexToCelebMap = self.indexToCelebMap
        self.present(buyStockView, animated: true, completion: nil)
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
        
        let kimPrice = 100
        let jkPrice = 100
        let drakePrice = 100
        let beyoncePrice = 100
        let diddyPrice = 100
        let elonPrice = 100
        let travisPrice = 100
        let kyliePrice = 100
        
       /* let url = URL(string: "https://twitter.com/kimkardashian")
        let task = URLSession.shared.dataTask(with:url!){ (data,response,error) in
            if error != nil
            {
                DispatchQueue.main.async {
                    if let errorMessage = error?.localizedDescription
                    {
                        //error, put error message
                    }else{
                        //error, put error message
                    }
                }
            }else {
                let webContent:String = String(data:data!,encoding: String.Encoding.utf8)!
                //get the name
                var array:[String] = webContent.components(separatedBy: "<title>")
                array = array[1].components(separatedBy: " |")
                let name = array[0]
                array.removeAll()
                
                //get the profile picture
                array = webContent.components(separatedBy: "data-resolved-url-large=\"")
                array = array[1].components(separatedBy: "\"")
                let profilePicture = array[0]
                print(profilePicture)
                
                //get the tweets
                array = webContent.components(separatedBy: "data-aria-label-part=\"0\">")
                array.remove(at: 0)
                
            }
        }
        task.resume() */
        
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
        cell.buyButton.tag = indexPath.row
        indexToCelebMap[indexPath.row] = celebrity
        
        return cell
    }
    
    func celebNameToInt(celebName: String) -> Int{
        var returnVar = ""
        
        for c in celebName {
            let x = c
            let letterInt = String(mapToInt(letter: String(c))) + " "
            returnVar = returnVar + letterInt
        }
        return Int(returnVar)!
        
    }
    
    func mapToInt(letter: String) -> Int{
        var returnInt = 0
        switch (letter) {
        case " ":
            returnInt = 0
        default:
            break
        }
        return returnInt
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
            SellStockViewController {
            destination.user = self.user
        }
    }


}
