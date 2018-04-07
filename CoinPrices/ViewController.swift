//
//  ViewController.swift
//  FoodTracker
//
//  Created by Jijun Lu on 2/12/18.
//  Copyright © 2018 Jijun Lu. All rights reserved.
//

import UIKit
import GoogleMobileAds

struct CoinPrice : Decodable {
    let high : String
    let last: String
    let low: String
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GADBannerViewDelegate {

    var priceByCoinPair = [String: String]()
    var priceDictKeys = [String]()

    // Properties
    @IBOutlet weak var myAdBanner: GADBannerView!
 
    @IBOutlet weak var pricesTableView: UITableView!
    
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        return priceByCoinPair.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "priceCell", for: indexPath as IndexPath) as UITableViewCell
        
        let coinPair = self.priceDictKeys[indexPath.row]
        cell.textLabel?.text = String(format: "%@:   %@", coinPair, priceByCoinPair[coinPair]!)
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    // Actions

    // Get prices
    @IBAction func RefreshPrices(_ sender: Any) {
        getPricesImpl()
    }
    
    @objc func getPricesImpl() -> Void {
        priceByCoinPair.removeAll()
        
        getPriceByCurrencyPair(coinName:"btc", currency: "usd")
        getPriceByCurrencyPair(coinName:"eth", currency: "usd")
        getPriceByCurrencyPair(coinName:"xrp", currency: "usd")
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
            
            let pricePair = String(format: "%@/%@", coinName.uppercased(), currency.uppercased())
            
            self.priceByCoinPair[pricePair] = coinPrice.last
            self.priceDictKeys = self.priceByCoinPair.keys.sorted()
            self.pricesTableView.reloadData()
        })
        task.resume()
    }
    
    // Google ads
    func initAdMobBanner() {
        myAdBanner.adUnitID = Constants.adMobBannerUnitId
        myAdBanner.rootViewController = self
        myAdBanner.load(GADRequest())
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

}

