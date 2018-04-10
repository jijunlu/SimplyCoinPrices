//
//  PortfolioViewController.swift
//  CoinPrices
//
//  Created by Jijun Lu on 4/7/18.
//  Copyright © 2018 Jijun Lu. All rights reserved.
//

import UIKit

class PortfolioViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var portfolioTotalLabel: UILabel!
    @IBOutlet weak var portfolioTableView: UITableView!
    @IBOutlet weak var editButton: UIButton!
    
    var assetByCoinType = [String: Float]()
    var assetCoinTypes = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editButton.titleLabel?.font = UIFont(name: "Avenir", size:18)
        portfolioTableView.dataSource = self
        portfolioTableView.delegate = self
        
        portfolioTableView.rowHeight = 58
        
        calculatePortfolioTotal()
    }

    override func viewDidAppear(_ animated: Bool) {
        calculatePortfolioTotal()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func calculatePortfolioTotal() -> Void {
        let pricesByCoinType = UserDefaults.standard.object(forKey: Constants.coinPriceDictKey) as! [String: String]
        
        assetByCoinType = getAssetDict()
        assetCoinTypes = assetByCoinType.keys.sorted()

        var totalUsd : Float = 0
        for (coin, amount) in assetByCoinType {
            if(pricesByCoinType.keys.contains(coin.uppercased())){
                totalUsd += amount * Float(pricesByCoinType[coin.uppercased()]!)!
            }
        }
        
        portfolioTotalLabel.text! = String(format: "Total: %f", totalUsd)
        portfolioTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assetByCoinType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "portfolioCell", for: indexPath as IndexPath) as! TwoColumnsTableViewCell
        
        let coinType = self.assetCoinTypes[indexPath.row]
        cell.column1?.text = Constants.CoinMap[coinType]!["FullName"]
        cell.column2?.text = String(assetByCoinType[coinType]!)
        
        cell.column1?.textAlignment = .center
        cell.column2?.textAlignment = .center
        
        return cell
    }
    
    func getAssetDict() -> [String: Float] {
        guard let assetByCoinDict = UserDefaults.standard.object(forKey: Constants.assetByCoinDictKey) else {
            return [String: Float]()
        }
        
        var ret = assetByCoinDict as! [String: Float]
        for (asset, amount) in ret {
            if(amount == 0) {
                ret.removeValue(forKey: asset)
            }
        }
        return ret
    }

}
