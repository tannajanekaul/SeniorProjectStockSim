//
//  Profile.swift
//  StockSim
//
//  Created by Tanna Jane Quale Kaul on 5/15/18.
//  Copyright © 2018 Tanna Jane Quale Kaul. All rights reserved.
//

import Foundation
import UIKit

class Profile{
    var name: String
    var money: Int
    
    init?(name: String, money: Int){
        if (name.isEmpty){
            return nil
        }
        self.name = name
        self.money = money
    }
}
