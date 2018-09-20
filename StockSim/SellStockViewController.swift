//
//  SellStockViewController.swift
//  StockSim
//
//  Created by Tanna Jane Quale Kaul on 6/8/18.
//  Copyright © 2018 Tanna Jane Quale Kaul. All rights reserved.
//

import UIKit

class SellStockViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    var pickerData: [String] = [String]()
    var indexToCelebMap = [Int : Celebrity]()
    var currentCelebrityToBuy: Celebrity?
    var celebToBuyInt: Int?
    var user: Profile?
    var numShares: Int?
    @IBOutlet weak var moneyAvailable: UITextField!
    
    @IBOutlet weak var estimatedValueTextField: UITextField!
    @IBOutlet weak var marketPriceTextField: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var currentStockTextField: UITextField!
    override func viewDidLoad() {
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
        self.estimatedValueTextField.text = String(numShares!*(currentCelebrityToBuy?.price)!)
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
