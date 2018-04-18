//
//  PortfolioViewController.swift
//  CoinPrices
//
//  Created by Jijun Lu on 4/7/18.
//  Copyright © 2018 Jijun Lu. All rights reserved.
//

import UIKit
import GoogleMobileAds

class PortfolioViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, GADBannerViewDelegate {

    @IBOutlet weak var portfolioTotalLabel: UILabel!
    @IBOutlet weak var portfolioTableView: UITableView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var adBanner: GADBannerView!
    
    var assetByCoinType = [String: Double]()
    var assetCoinTypes = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //editButton.titleLabel?.font = UIFont(name: "Avenir", size:18)
        portfolioTableView.dataSource = self
        portfolioTableView.delegate = self
        
        portfolioTableView.rowHeight = 58
        
        calculatePortfolioTotal()
        
        initAdMobBanner()
    }

    func initAdMobBanner() {
        adBanner.adUnitID = Constants.adMobBannerUnitId
        adBanner.rootViewController = self
        adBanner.load(GADRequest())
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
    
    func getSavedCoinPriceDict() -> [String: [String: String]] {
        let savedCoinPrices = UserDefaults.standard.object(forKey: Constants.CoinPricesKey) as! [[String: String]]
        
        var coinPriceDict = [String: [String: String]]()
        for coinPrice in savedCoinPrices {
            coinPriceDict[coinPrice["symbol"]!] = coinPrice
        }
        
        return coinPriceDict
    }
    
    func calculatePortfolioTotal() -> Void {
        let savedCoinPriceDict =  getSavedCoinPriceDict()
        
        assetByCoinType = getAssetDict()
        assetCoinTypes = assetByCoinType.keys.sorted()

        var totalUsd : Double = 0
        for (coin, amount) in assetByCoinType {
            if(savedCoinPriceDict.keys.contains(coin.uppercased())){
                totalUsd += amount * Double(savedCoinPriceDict[coin.uppercased()]!["price_usd"]!)!
            }
        }
        
        portfolioTotalLabel.text! = String(format: "Total value: $%.2f", totalUsd)
        portfolioTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assetByCoinType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "portfolioCell", for: indexPath as IndexPath) as! PortfolioTableViewCell
        
        let pricesByCoinType = getSavedCoinPriceDict()
        
        let coinType = self.assetCoinTypes[indexPath.row]
        cell.column1?.text = coinType
        cell.column2?.text = String(assetByCoinType[coinType]!)
        
        let value = pricesByCoinType.keys.sorted().contains(coinType.uppercased()) ? Double(pricesByCoinType[coinType.uppercased()]!["price_usd"]!)! * assetByCoinType[coinType]! : 0.0
        cell.column3?.text = String(format: "$%.2f", value)
        
        cell.column1?.textAlignment = .center
        cell.column2?.textAlignment = .center
        cell.column3?.textAlignment = .center
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coinType = self.assetCoinTypes[indexPath.row]
        let coinAmount = assetByCoinType[coinType] != nil ? assetByCoinType[coinType] : 0.0

        
        let editPortfolioViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "editPortfolioViewController") as! PortfolioPopUpViewController
        
        editPortfolioViewController.inputCoinType = coinType
        editPortfolioViewController.inputCoinAmount = coinAmount!
        
        showDetailViewController(editPortfolioViewController, sender: self)
    }
 
    func getAssetDict() -> [String: Double] {
        guard let assetByCoinDict = UserDefaults.standard.object(forKey: Constants.assetByCoinDictKey) else {
            return [String: Double]()
        }
        
        var ret = assetByCoinDict as! [String: Double]
        for (asset, amount) in ret {
            if(amount == 0) {
                ret.removeValue(forKey: asset)
            }
        }
        return ret
    }
    

}
