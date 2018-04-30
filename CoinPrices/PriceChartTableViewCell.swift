//
//  PriceChartTableViewCell.swift
//  CoinPrices
//
//  Created by Jijun Lu on 4/29/18.
//  Copyright © 2018 Jijun Lu. All rights reserved.
//

import UIKit

class PriceChartTableViewCell: UITableViewCell {

    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
