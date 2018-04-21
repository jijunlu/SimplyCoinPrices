//
//  SettingWrapperViewController.swift
//  CoinPrices
//
//  Created by Jijun Lu on 4/10/18.
//  Copyright © 2018 Jijun Lu. All rights reserved.
//

import UIKit
import GoogleMobileAds

class SettingWrapperViewController: UIViewController, GADBannerViewDelegate {

    @IBOutlet weak var adBanner: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initAdMobBanner()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initAdMobBanner() {
        adBanner.adUnitID = Constants.AdMobBannerUnitId
        adBanner.rootViewController = self
        adBanner.load(GADRequest())
    }

}
