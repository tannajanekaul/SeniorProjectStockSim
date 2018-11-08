//
//  Celebrity.swift
//  StockSim
//
//  Created by Tanna Jane Quale Kaul on 5/16/18.
//  Copyright © 2018 Tanna Jane Quale Kaul. All rights reserved.
//

import Foundation
import UIKit

class Celebrity{
    var name: String
    var price: Int
    var photo: UIImage
    var index: Int
    init?(name: String,price: Int, photo: UIImage, index: Int){
        if (name.isEmpty){
            return nil
        }
        self.name = name
        self.price = price
        self.photo = photo
        self.index = index
        
    }

}
