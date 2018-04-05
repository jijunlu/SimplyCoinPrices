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

class ViewController: UIViewController, GADBannerViewDelegate {

    // Properties
    @IBOutlet weak var btcPriceLabel: UILabel!
    @IBOutlet weak var ethPriceLabel: UILabel!
    @IBOutlet weak var xrpPriceLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var getPricesButton: UIButton!
    
    @IBOutlet weak var sideMenuConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var myAdBanner: GADBannerView!
    
    let ADMOB_BANNER_UNIT_ID = "ca-app-pub-4258982541138576/9768265072"
 
    var isSlideMenuHidden = true
    
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenuConstraint.constant = -158
        
        initAdMobBanner()

        getPricesImpl()
        
        addTimer()
    }
    
    // Actions
    @IBAction func toggleSideMenu(_ sender: Any) {
        if(isSlideMenuHidden){
            sideMenuConstraint.constant = 0
        }
        else {
            sideMenuConstraint.constant = -158
        }
        
        UIView.animate(withDuration: 0.3, animations:{
            self.view.layoutIfNeeded()
        })

        isSlideMenuHidden = !isSlideMenuHidden
    }
    
    @IBAction func getPrice(_ sender: Any) {
        getPricesImpl()
    }
    
    @objc func getPricesImpl() -> Void {
        getPriceByCurrencyPair(coinName:"btc", currency: "usd", labelView: btcPriceLabel)
        getPriceByCurrencyPair(coinName:"eth", currency: "usd", labelView: ethPriceLabel)
        getPriceByCurrencyPair(coinName:"xrp", currency: "usd", labelView: xrpPriceLabel)
    }
    
    func getPriceByCurrencyPair(coinName: String, currency: String, labelView: UILabel!) -> Void {
        let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: OperationQueue.main)
        let url = URL(string: String(format: "https://www.bitstamp.net/api/v2/ticker/%@%@", coinName.lowercased(), currency.lowercased()))!
        let task = session.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data else {
                print("data error")
                return
            }
            
            guard let coinPrice = try? JSONDecoder().decode(CoinPrice.self, from: data) else {
                print("decode error")
                return
            }
            labelView.text = String(format: "%@/%@:   %@", coinName.uppercased(), currency.uppercased(), coinPrice.last)
            
            self.timestampLabel.text = String(format: "@ %@", DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium))
        })
        task.resume()
    }
    
    func initAdMobBanner() {
        myAdBanner.adUnitID = ADMOB_BANNER_UNIT_ID
        myAdBanner.rootViewController = self
        myAdBanner.load(GADRequest())
    }
    
    func addTimer() -> Void {
        _ = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(self.getPricesImpl), userInfo: nil, repeats: true)
    }
}

