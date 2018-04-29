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
    @IBOutlet weak var portfolioChangeLabel: UILabel!
    @IBOutlet weak var portfolioTableView: UITableView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var adBanner: GADBannerView!

    @IBOutlet weak var wrapperScrollView: UIScrollView!
    
    var assetByCoinType = [String: [String:Double]]()
    var assetCoinTypes = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        portfolioTableView.dataSource = self
        portfolioTableView.delegate = self
        
        portfolioTableView.rowHeight = 58
        
        calculatePortfolioTotal()
        
        initAdMobBanner()
        
        NotificationCenter.default.addObserver(self, selector: #selector(OnNotificationOfPriceUpdate(notification:)), name: NSNotification.Name(rawValue: Constants.NotificationOfPriceUpdateKey), object: nil)
    }

    @objc func OnNotificationOfPriceUpdate(notification: NSNotification) {
        calculatePortfolioTotal()
    }
    
    func initAdMobBanner() {
        adBanner.adUnitID = Constants.AdMobBannerUnitId
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
    
    func calculatePortfolioTotal() -> Void {
        let savedCoinPriceDict =  Utils.getSavedCoinPriceDict()
        
        assetByCoinType = getAssetDict()
        assetCoinTypes = assetByCoinType.keys.sorted()

        var totalUsd : Double = 0
        var totalCost: Double = 0
        for (coin, amountAndCostBase) in assetByCoinType {
            if(savedCoinPriceDict.keys.contains(coin.uppercased())){
                totalUsd += amountAndCostBase["amount"]! * Double(savedCoinPriceDict[coin.uppercased()]!["price"]!)!
                totalCost += amountAndCostBase["costBase"]!
            }
        }
        
        portfolioTotalLabel.text! = String(format: "Total: $%.2f (+/-: $%.2f)", totalUsd, totalUsd - totalCost)
        portfolioTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assetByCoinType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "portfolioCell", for: indexPath as IndexPath) as! PortfolioTableViewCell
        
        let pricesByCoinType = Utils.getSavedCoinPriceDict()
        
        let coinType = self.assetCoinTypes[indexPath.row]
        //cell.column0?.text = pricesByCoinType[coinType]?["name"]
        cell.column1?.text = String(format: "%@\n(%@)", (pricesByCoinType[coinType]?["name"])!, coinType)
        cell.column2?.text = String(format:"%.4f\n@ $%@", assetByCoinType[coinType]!["amount"]!, pricesByCoinType[coinType.uppercased()]!["price"]!)
        
        
        let totalValue = pricesByCoinType.keys.sorted().contains(coinType.uppercased()) ? Double(pricesByCoinType[coinType.uppercased()]!["price"]!)! * assetByCoinType[coinType]!["amount"]! : 0.0
        
        cell.column3?.text = String(format: "$%.2f", totalValue)
        
        //cell.column0?.textAlignment = .left
        cell.column1?.numberOfLines = 0
        cell.column2?.numberOfLines = 0
        
        cell.column1?.textAlignment = .left
        cell.column2?.textAlignment = .right
        cell.column3?.textAlignment = .center
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coinType = self.assetCoinTypes[indexPath.row]
        let coinAmount = assetByCoinType[coinType] != nil ? assetByCoinType[coinType]!["amount"] : 0.0
        let costBase = assetByCoinType[coinType] != nil ? assetByCoinType[coinType]!["costBase"] : 0.0

        
        let editPortfolioViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "editPortfolioViewController") as! PortfolioPopUpViewController
        
        let pricesByCoinType = Utils.getSavedCoinPriceDict()
        
        editPortfolioViewController.inputCoinName = pricesByCoinType[coinType]!["name"]!
        editPortfolioViewController.inputCoinAmount = coinAmount!
        editPortfolioViewController.inputCostBase = costBase!
        
        showDetailViewController(editPortfolioViewController, sender: self)
    }
 
    func getAssetDict() -> [String: [String:Double]] {
        guard let assetByCoinDict = UserDefaults.standard.object(forKey: Constants.AssetByCoinDictKey) else {
            return [String: [String:Double]]()
        }
        
        var ret = assetByCoinDict as! [String: [String:Double]]
        for (coinType, amountAndCostBase) in ret {
            if(amountAndCostBase["amount"] == 0) {
                ret.removeValue(forKey: coinType)
            }
        }
        return ret
    }
    

}
