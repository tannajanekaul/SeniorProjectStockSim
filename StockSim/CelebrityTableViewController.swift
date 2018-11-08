//
//  CelebrityTableViewController.swift
//  StockSim
//
//  Created by Tanna Jane Quale Kaul on 5/16/18.
//  Copyright © 2018 Tanna Jane Quale Kaul. All rights reserved.
//


import UIKit
import Firebase
import Foundation
import SwiftSoup

class CelebrityTableViewController: UITableViewController {
    var user: Profile?
    var ref: DatabaseReference!
    var celebrities = [Celebrity]()
    var thisData: Data?
    var indexToCelebMap = [Int : Celebrity]()
    var thisResponce: URLResponse?
    var globalTableView: UITableView?
    var x: Int = 0;
    var userfollowing : Int?
    let useACAccount = true
    let semaphore = DispatchSemaphore(value: 1)
    
    
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
        let bool = true;
        let numCelebs = 8
        let photo1 = UIImage(named: "kimkardashian")
        let photo2 = UIImage(named: "jk_rowling")
        let photo3 = UIImage(named: "drake")
        let photo4 = UIImage(named: "beyonce")
        let photo5 = UIImage(named: "diddy")
        let photo6 = UIImage(named: "elonmusk")
        let photo7 = UIImage(named: "trvisXX")
        let photo8 = UIImage(named: "kyliejenner")
    
        
        var kimPrice = -1;
        var jkPrice = -1
        var drakePrice = -1
        var beyoncePrice = -1
        var diddyPrice = -1
        var elonPrice = -1
        var travisPrice = -1
        var kyliePrice = -1
        var count = 0
        
        guard let kim = Celebrity(name: "Kim Kardashian", price: kimPrice, photo: photo1!,index: count) else {
            fatalError("Unable to instantiate celeb")
        }
        count = count+1
        guard let jk = Celebrity(name: "JK Rowling", price: jkPrice, photo: photo2!,index: count) else {
            fatalError("Unable to instantiate celeb")
        }
        count = count+1
        guard let drake = Celebrity(name: "Drake", price: drakePrice, photo: photo3!,index:count) else {
            fatalError("Unable to instantiate celeb")
        }
        count = count+1
        guard let beyonce = Celebrity(name: "Beyonce", price: beyoncePrice, photo: photo4!, index: count) else {
            fatalError("Unable to instantiate celeb")
        }
        count = count+1
        guard let diddy = Celebrity(name: "Diddy", price: diddyPrice, photo: photo5!,index: count) else {
            fatalError("Unable to instantiate celeb")
        }
        count = count+1
        guard let elonmusk = Celebrity(name: "Elon Musk", price: elonPrice, photo: photo6!, index: count) else {
            fatalError("Unable to instantiate celeb")
        }
        count = count+1
        guard let travisscott = Celebrity(name: "Travis Scott", price: travisPrice, photo: photo7!, index: count) else {
            fatalError("Unable to instantiate celeb")
        }
        count = count+1
        guard let kyliejenner = Celebrity(name: "Kylie Jenner", price: kyliePrice, photo: photo8!, index: count) else {
            fatalError("Unable to instantiate celeb")
        }
        count = count+1
        
        if (!bool) {
            kimPrice = getPriceFromScrape(celebName: "kimkardashian", index: kim.index)
            jkPrice = getPriceFromScrape(celebName: "jk_rowling", index: jk.index)
            drakePrice = getPriceFromScrape(celebName: "drake",index: drake.index)
            beyoncePrice = getPriceFromScrape(celebName: "beyonce",index: beyonce.index)
            diddyPrice = getPriceFromScrape(celebName: "diddy",index: diddy.index)
            elonPrice = getPriceFromScrape(celebName: "elonmusk",index: elonmusk.index)
            travisPrice = getPriceFromScrape(celebName: "trvisXX",index: travisscott.index)
            kyliePrice = getPriceFromScrape(celebName: "kyliejenner",index: kyliejenner.index)
        } else {
            kimPrice = getPriceFromDB(celebName: "kimkardashian",index: kim.index)
            jkPrice = getPriceFromDB(celebName: "jk_rowling",index: jk.index)
            drakePrice = getPriceFromDB(celebName: "drake",index: drake.index)
            beyoncePrice = getPriceFromDB(celebName: "beyonce",index: beyonce.index)
            diddyPrice = getPriceFromDB(celebName: "diddy", index: diddy.index)
            elonPrice = getPriceFromDB(celebName: "elonmusk",index: elonmusk.index)
            travisPrice = getPriceFromDB(celebName: "trvisXX",index: travisscott.index)
            kyliePrice = getPriceFromDB(celebName: "kyliejenner",index: kyliejenner.index)
        }

        kim.price = kimPrice;
        jk.price = jkPrice;
        drake.price = drakePrice;
        beyonce.price = beyoncePrice;
        diddy.price = diddyPrice;
        elonmusk.price = elonPrice;
        travisscott.price = travisPrice;
        kyliejenner.price = kyliePrice;
        
        celebrities += [kim,jk,drake,beyonce,diddy,elonmusk,travisscott,kyliejenner]
        
        
    }
//    func callDB(indexVal) {
//        var celebMoney = nil;
//        ref.child("celebs").child(indexVal!).observeSingleEvent(of: .value, with: { (snapshot) in
//            // Get user value
//            let value = snapshot.value as? NSDictionary
//            celebMoney = (value?["money"] as? Int)!
//            //let user = User(username: username)
//
//            // ...
//        }) { (error) in
//            print(error.localizedDescription)
//        }
//    }
    
    func getPriceFromDB(celebName: String, index: Int) -> Int {
        ref = Database.database().reference()
        let indexVal: String? = String(index)
        var moneyReturn: Int = -1;
        var celebMoney: Int = -1;
        //down the semaphore
        print("first wait semaphore");
        semaphore.wait()
        ref.child("celebs").child(indexVal!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            print("hello inside db");
            let value = snapshot.value as? NSDictionary
            celebMoney = (value?["money"] as? Int)!
            //let user = User(username: username)
            self.semaphore.signal()
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        // up the semaphore
        
        print("waiting for the semaphore");
        semaphore.wait()
        print("semaphore open now");
        moneyReturn = celebMoney
        semaphore.signal()
        return moneyReturn;
    }
    
    func getPriceFromScrape(celebName: String, index: Int)  -> Int {
        let urlString = "https://twitter.com/" + celebName
        let url = URL(string: urlString)
        
        let request = URLRequest(url: url!)
        
        guard let myURL = url else {
            print("Error: \(String(describing: url)) doesn't seem to be a valid URL")
            return -1;
        }
        
        let html = try! String(contentsOf: myURL, encoding: .utf8)
        
        do {
            let doc: Document = try SwiftSoup.parseBodyFragment(html)
            let headerTitle = try doc.title()
            
            // my body
            let body = doc.body()
            do {
                let followerElement: Element? = try body?.getElementById("page-container");
                //print(followerElement)
                let child = try followerElement?.child(1).text()
                
                let stringArray = child?.split(separator: " ");

                var followerIndex: Int = 0;
                var i: Int = 0
                for elem in stringArray! {
                    print("Index[", i , "] =" , elem)
                    if (elem == "Followers") {
                        followerIndex = i + 1;
                    }
                    i = i+1
                }
                
                var followerString = stringArray![followerIndex]
                followerString = followerString.dropLast()
                var newString = String(followerString)
                //print("[", followerString,"]")
                let myFloat = (newString as NSString).doubleValue
                //print(myFloat);
                
                let moneyValue = Int(myFloat*1000)
                
                let intVal: String? = String(index)
                //save to database
                self.ref.child("celebs").child(intVal!).setValue(["name": celebName])
                self.ref.child("celebs").child(intVal!).setValue(["money": moneyValue])
                x = x+1;
                return moneyValue
                
            }catch {
                print("error getting follower element")
            }
            
            print("Header title: \(headerTitle)")
        } catch Exception.Error(let type, let message) {
            print("Message: \(message)")
        } catch {
            print("error")
        }
        return -1;
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
