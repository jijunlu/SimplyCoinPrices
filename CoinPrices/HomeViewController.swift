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

struct Ticker : Decodable {
    let name: String
    let symbol: String
    let price_usd: String // "8273.52",
    let price_btc: String //"1.0",
    let market_cap_usd: String // "140477850066",
    let available_supply: String // "16979212.0",
    let total_supply: String // "16979212.0",
    //let max_supply: String // "21000000.0",
    let percent_change_1h: String // "-0.06",
    let percent_change_24h: String // "3.96",
    let percent_change_7d: String // "17.62",
    let last_updated: String // "1523809773"
}

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GADBannerViewDelegate {
    
    var coinTickerList = [[String: String]]()
    
    var priceDict = [[String:String]]()
    
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
     
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.pricesTableView.refreshControl = refreshControl
    }
    
    @objc func refresh(refreshControl: UIRefreshControl) {
        getPrices()
        
        refreshControl.endRefreshing()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getTickersAndPrices()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinTickerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "priceCell", for: indexPath as IndexPath) as! CoinPriceTableViewCell
        
        let tickerInfo = self.coinTickerList[indexPath.row]
        cell.column1?.text = tickerInfo["name"]
        cell.column2?.text = tickerInfo["price_usd"]
        let percentStr = String(format: "%@%%", tickerInfo["percent_change_24h"]!)
        cell.column3?.text = percentStr
        
        cell.column1?.textAlignment = .center
        cell.column2?.textAlignment = .center
        cell.column3?.textAlignment = .center
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tickerInfo = self.coinTickerList[indexPath.row]
        
        let coinDetailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "coinDetailsViewController") as! PriceDiagramViewController
        
        coinDetailsViewController.inputCoinType = tickerInfo["symbol"]!
        
        showDetailViewController(coinDetailsViewController, sender: self)
    }
    
    // Actions
    
    // Get prices
    @objc func getPrices() {
        let top100Tickers = UserDefaults.standard.object(forKey: "Top100Tickers") as! [String]
        
        let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: OperationQueue.main)
        let url = URL(string: String(format: "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=%@&tsyms=USD", top100Tickers.joined(separator: ",")))!
        
        let task = session.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data else {
                print("!!!!!!!!!!!!!!!! data error !!!!!!!!!!!!!!!")
                return
            }
            
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            
            let jsonDict = json as! [String:Any]
            let displayDict = jsonDict["RAW"] as! [String:Any]
            
            var arrayOfDict = [[String: String]]()
            for ticker in top100Tickers {
                if(!displayDict.keys.contains(ticker)) {
                    continue
                }
                
                let fullTickerData = displayDict[ticker] as! [String: Any]
                let usdData = fullTickerData["USD"] as? [String:Any]
                
                arrayOfDict.append([
                    "name": ticker,
                    "symbol": ticker,
                    "price_usd": self.parsePrice(priceVal: usdData!["PRICE"]!),
                    "percent_change_24h": String(format:"%.2f", usdData!["CHANGEPCT24HOUR"] as! Double)
                    ])
            }
            
            self.coinTickerList = arrayOfDict
            UserDefaults.standard.set(arrayOfDict, forKey: Constants.CoinPricesKey)
            
            self.pricesTableView.reloadData()
            
        })
        task.resume()

        addTimer()
    }
    
    func parsePrice(priceVal: Any) -> String {
        if priceVal is String {
            return priceVal as! String
        } else {
            return String(priceVal as! Double)
        }
    }
    
    func getTickersAndPrices() -> Void {
        let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: OperationQueue.main)
        let url = URL(string: String(Constants.CoinTickerUrl))!
        let task = session.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data else {
                print("!!!!!!!!!!!!!!!! data error !!!!!!!!!!!!!!!")
                return
            }

            guard let parsedResults = try? JSONDecoder().decode([Ticker].self, from: data) else {
                print("!!!!!!!!!!!!!!! decode error !!!!!!!!!!!!!!!")
                return
            }
            
            var i: Int = 0
            var tickerList = [String]()
            for ticker in parsedResults {
                if(i < 68){
                    tickerList.append(ticker.symbol)
                    i += 1
                }
            }
            
            UserDefaults.standard.set(tickerList, forKey: "Top100Tickers")
            
            self.getPrices()
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
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(updateInterval), target: self, selector: #selector(self.getPrices), userInfo: nil, repeats: true)
    }
    
    func getUpdateInterval() -> Float {
        guard let updateIntervalFromSettings = UserDefaults.standard.object(forKey: Constants.updateIntervalSettingKey) else {
            return Constants.defaultUpdateInterval
        }
        
        return updateIntervalFromSettings as! Float
    }
}


