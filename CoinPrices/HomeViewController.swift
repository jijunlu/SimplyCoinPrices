//
//  HomeViewController.swift
//  CoinPrices
//
//  Created by Jijun Lu on 4/7/18.
//  Copyright © 2018 Jijun Lu. All rights reserved.
//

import UIKit
import GoogleMobileAds

struct CoinPrice : Decodable {
    let high : String
    let last: String
    let low: String
}

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GADBannerViewDelegate {
    
    var priceByCoinDict = [String: String]()
    var priceDictKeys = [String]()
    
    // Properties
    @IBOutlet weak var adBanner: GADBannerView!
    @IBOutlet weak var pricesTableView: UITableView!
    
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pricesTableView.rowHeight = 58
        
        pricesTableView.delegate = self
        pricesTableView.dataSource = self
        
        initAdMobBanner()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getPricesImpl()
        addTimer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return priceByCoinDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "priceCell", for: indexPath as IndexPath) as! TwoColumnsTableViewCell
        
        let coinType = self.priceDictKeys[indexPath.row]
        cell.column1?.text = coinType
        cell.column2?.text = priceByCoinDict[coinType]!

        cell.column1?.textAlignment = .center
        cell.column2?.textAlignment = .center

        return cell
    }
    
    // Actions
    
    // Get prices
    @IBAction func RefreshPrices(_ sender: Any) {
        getPricesImpl()
    }
    
    @objc func getPricesImpl() -> Void {
        priceByCoinDict.removeAll()
        
        let coinsToDisplay = getCoinsToDisplay()
        if(coinsToDisplay.count == 0)
        {
            priceByCoinDict = [String: String]()
            priceDictKeys = [String]()
            pricesTableView.reloadData()
        }
        for coin in coinsToDisplay {
            getPriceByCurrencyPair(coinName: coin.lowercased(), currency: "usd")
        }
    }
    
    func getPriceByCurrencyPair(coinName: String, currency: String) -> Void {
        let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: OperationQueue.main)
        let url = URL(string: String(format: "%@/%@%@", Constants.baseUrl, coinName.lowercased(), currency.lowercased()))!
        let task = session.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data else {
                print("data error")
                return
            }
            
            guard let coinPrice = try? JSONDecoder().decode(CoinPrice.self, from: data) else {
                print("decode error")
                return
            }
            
            self.priceByCoinDict[coinName.uppercased()] = coinPrice.last
            self.priceDictKeys = self.priceByCoinDict.keys.sorted()
            UserDefaults.standard.set(self.priceByCoinDict, forKey: Constants.coinPriceDictKey)
            self.pricesTableView.reloadData()

        })
        task.resume()
    }
    
    // Google ads
    func initAdMobBanner() {
        adBanner.adUnitID = Constants.adMobBannerUnitId
        adBanner.rootViewController = self
        adBanner.load(GADRequest())
    }
    
    // Automatic update
    func addTimer() -> Void {
        if(timer != nil) {
            timer.invalidate()
        }
        let updateInterval = getUpdateInterval()
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(updateInterval), target: self, selector: #selector(self.getPricesImpl), userInfo: nil, repeats: true)
    }
    
    func getUpdateInterval() -> Float {
        guard let updateIntervalFromSettings = UserDefaults.standard.object(forKey: Constants.updateIntervalSettingKey) else {
            return Constants.defaultUpdateInterval
        }
        
        return updateIntervalFromSettings as! Float
    }
    
    func getCoinsToDisplay() -> [String] {
        guard let coinsToDisplay = UserDefaults.standard.object(forKey: Constants.coinsToDisplayDictKey) else {
            return Constants.CoinMap.keys.sorted()
        }
        
        let temp = coinsToDisplay as! [String: [String]]
        return temp.keys.sorted()
    }
}


