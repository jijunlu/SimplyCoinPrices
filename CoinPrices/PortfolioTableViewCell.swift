//
//  PriceTableViewCell.swift
//  CoinPrices
//
//  Created by Jijun Lu on 4/8/18.
//  Copyright © 2018 Jijun Lu. All rights reserved.
//

import UIKit

class PortfolioTableViewCell: UITableViewCell {

    
    @IBOutlet weak var column1: UILabel!
    @IBOutlet weak var column2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
