//
//  PortfolioViewController.swift
//  CoinPrices
//
//  Created by Jijun Lu on 4/7/18.
//  Copyright © 2018 Jijun Lu. All rights reserved.
//

import UIKit

class PortfolioViewController: UIViewController {

    @IBOutlet weak var portfolioTotalLabel: UILabel!
    
    var assetByCoinPair = [String: Float]()
    var assetCoinTypes = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        calculatePortfolioTotal()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func calculatePortfolioTotal() -> Void {
        let pricesByCoinPair = UserDefaults.standard.object(forKey: Constants.coinPriceDictKey) as! [String: String]
        let assetByCoinPairDict = getAssetDict()

        var totalUsd : Float = 0
        for (coinPair, amount) in assetByCoinPairDict {
            totalUsd += amount * Float(pricesByCoinPair[coinPair]!)!
        }
        
        portfolioTotalLabel.text! = String(format: "Total: %f", totalUsd)
    }
    
    func getAssetDict() -> [String: Float] {
        return [
            "BTC/USD": 1.0273109,
            "ETH/USD": 10
        ]
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
