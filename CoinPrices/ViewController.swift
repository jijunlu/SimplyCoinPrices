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
    
    // Ad banner and interstitial views
    var adMobBannerView = GADBannerView()
    let ADMOB_BANNER_UNIT_ID = "ca-app-pub-4258982541138576/9768265072"
 
    var timer: Timer!
    var refresher: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // In this case, we instantiate the banner with desired ad size.
        initAdMobBanner()

        getPricesImpl()
        
        _ = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(self.getPricesImpl), userInfo: nil, repeats: true)
    }
    
    // Actions
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
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            // iPhone
            adMobBannerView.adSize =  GADAdSizeFromCGSize(CGSize(width: 320, height: 50))
            adMobBannerView.frame = CGRect(x: 0, y: view.frame.size.height, width: 320, height: 50)
        } else  {
            // iPad
            adMobBannerView.adSize =  GADAdSizeFromCGSize(CGSize(width: 468, height: 60))
            adMobBannerView.frame = CGRect(x: 0, y: view.frame.size.height, width: 468, height: 60)
        }
        
        adMobBannerView.adUnitID = ADMOB_BANNER_UNIT_ID
        adMobBannerView.rootViewController = self
        adMobBannerView.delegate = self
        view.addSubview(adMobBannerView)
        
        let request = GADRequest()
        adMobBannerView.load(request)
    }
    
    // Hide the banner
    func hideBanner(_ banner: UIView) {
        UIView.beginAnimations("hideBanner", context: nil)
        banner.frame = CGRect(x: view.frame.size.width/2 - banner.frame.size.width/2, y: view.frame.size.height - banner.frame.size.height, width: banner.frame.size.width, height: banner.frame.size.height)
        UIView.commitAnimations()
        banner.isHidden = true
    }
    
    // Show the banner
    func showBanner(_ banner: UIView) {
        UIView.beginAnimations("showBanner", context: nil)
        banner.frame = CGRect(x: view.frame.size.width/2 - banner.frame.size.width/2, y: view.frame.size.height - banner.frame.size.height, width: banner.frame.size.width, height: banner.frame.size.height)
        UIView.commitAnimations()
        banner.isHidden = false
    }
    
    // AdMob banner available
    func adViewDidReceiveAd(_ view: GADBannerView) {
        showBanner(adMobBannerView)
    }
    
    // NO AdMob banner available
    func adView(_ view: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        hideBanner(adMobBannerView)
    }
}

