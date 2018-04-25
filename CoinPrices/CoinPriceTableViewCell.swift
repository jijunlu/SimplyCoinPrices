//
//  CoinPriceTableViewCell.swift
//  CoinPrices
//
//  Created by Jijun Lu on 4/16/18.
//  Copyright © 2018 Jijun Lu. All rights reserved.
//

import UIKit

class CoinPriceTableViewCell: UITableViewCell {

    @IBOutlet weak var coinNameColumn: UILabel!
    @IBOutlet weak var priceColumn: UILabel!
    @IBOutlet weak var changePercentColumn: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
