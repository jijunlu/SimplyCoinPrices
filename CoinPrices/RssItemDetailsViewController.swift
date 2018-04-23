//
//  RssItemDetailsViewController.swift
//  CoinPrices
//
//  Created by Jijun Lu on 4/10/18.
//  Copyright © 2018 Jijun Lu. All rights reserved.
//

import UIKit
import WebKit
import GoogleMobileAds

class RssItemDetailsViewController: UIViewController {

    @IBOutlet weak var rssItemDetailsWebKitView: WKWebView!
    @IBOutlet weak var adBanner: GADBannerView!
    
    var urlStr = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let url = URL(string:urlStr)
        let request = URLRequest(url:url!)
        rssItemDetailsWebKitView.load(request)
        
        initAdMobBanner()
    }

    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                Utils.dismissFromLeft(sender: self)
            default:
                break
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func close(_ sender: Any) {
        Utils.dismissFromLeft(sender: self)
    }

    func initAdMobBanner() {
        adBanner.adUnitID = Constants.AdMobBannerUnitId
        adBanner.rootViewController = self
        adBanner.load(GADRequest())
    }

}
