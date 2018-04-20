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
                dismissFromLeft()
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
        dismissFromLeft()
    }

    func initAdMobBanner() {
        adBanner.adUnitID = Constants.adMobBannerUnitId
        adBanner.rootViewController = self
        adBanner.load(GADRequest())
    }
    
    func dismissFromLeft() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        view.layer.add(transition, forKey: "leftToRightTransition")
        dismiss(animated: true, completion: nil)
    }
}
