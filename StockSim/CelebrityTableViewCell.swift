//
//  CelebrityTableViewCell.swift
//  StockSim
//
//  Created by Tanna Jane Quale Kaul on 5/16/18.
//  Copyright © 2018 Tanna Jane Quale Kaul. All rights reserved.
//

import UIKit

class CelebrityTableViewCell: UITableViewCell {
    var user: Profile?
    var currentCelebIntIdentifier: Int?
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var stockPriceTextField: UITextField!
    @IBOutlet weak var buyButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        //tableView.register(MyTableViewCell.self, forCellReuseIdentifier: "Cell")
    }

}
