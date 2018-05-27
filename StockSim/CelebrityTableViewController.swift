//
//  CelebrityTableViewController.swift
//  StockSim
//
//  Created by Tanna Jane Quale Kaul on 5/16/18.
//  Copyright © 2018 Tanna Jane Quale Kaul. All rights reserved.
//


import UIKit
import SwifteriOS

class CelebrityTableViewController: UITableViewController {

    var celebrities = [Celebrity]()
    var thisData: Data?
    var thisResponce: URLResponse?
    //var i : Int
    var userfollowing : Int?
    let useACAccount = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSampleCelebs()
    }

    func loadSampleCelebs() {
        let swifter =   Swifter(consumerKey: "9a1LPNy5eoomys5py02SOoZX4", consumerSecret: "DjgTRvTQcw19oLKWcHgDwnbgzHgRo6iMjfmoQjqp2rNR1y2iDb", appOnly: true)
        swifter.authorizeAppOnly(success: { (accessToken, response) -> Void in
            //  println("\(accessToken)")
           // self.userfollowing = swifter.getUserFollowing(for: .screenName("KimKardashian") )
           /* swifter.getSearchTweetsWithQuery("Kim Kardashian", geocode: "", lang: "", locale: "", resultType: "", count: 150, until: "", sinceID: "2009-01-01", maxID: "", includeEntities: true, callback: "", success: { (statuses, searchMetadata) -> Void in
                print(statuses)
                
            }) { (error) -> Void in
                print(error)
            }*/
            // println("\(response)")
        }, failure: { (error) -> Void in
            //  println(error)
        })
        
        let photo1 = UIImage(named: "kimkardashian")
        let photo2 = UIImage(named: "jkrowling")
        let photo3 = UIImage(named: "drake")
        let photo4 = UIImage(named: "beyonce")
        let photo5 = UIImage(named: "diddy")
        let photo6 = UIImage(named: "elonmusk")
        let photo7 = UIImage(named: "travisscott")
        let photo8 = UIImage(named: "kyliejenner")
        
        guard let kim = Celebrity(name: "Kim Kardashian", price: 1000, photo: photo1!) else {
            fatalError("Unable to instantiate celeb")
        }
        
        guard let jk = Celebrity(name: "JK Rowling", price: 1000, photo: photo2!) else {
            fatalError("Unable to instantiate celeb")
        }
        
        guard let drake = Celebrity(name: "Drake", price: 1000, photo: photo3!) else {
            fatalError("Unable to instantiate celeb")
        }
        guard let beyonce = Celebrity(name: "Beyonce", price: 1000, photo: photo4!) else {
            fatalError("Unable to instantiate celeb")
        }
        guard let diddy = Celebrity(name: "Diddy", price: 1000, photo: photo5!) else {
            fatalError("Unable to instantiate celeb")
        }
        guard let elonmusk = Celebrity(name: "Elon Musk", price: 1000, photo: photo6!) else {
            fatalError("Unable to instantiate celeb")
        }
        guard let travisscott = Celebrity(name: "Travis Scott", price: 1000, photo: photo7!) else {
            fatalError("Unable to instantiate celeb")
        }
        guard let kyliejenner = Celebrity(name: "Kylie Jenner", price: 1000, photo: photo8!) else {
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
        
        let cellIdentifier = "CelebrityTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CelebrityTableViewCell  else {
            fatalError("The dequeued cell is not an instance of CelebrityTableViewCell.")
        }
        let celebrity = celebrities[indexPath.row]

        cell.nameLabel.text = celebrity.name
        cell.photoImageView.image = celebrity.photo
        cell.stockPriceTextField.text = String(celebrity.price)

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
