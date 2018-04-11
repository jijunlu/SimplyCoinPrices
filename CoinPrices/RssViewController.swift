//
//  RssViewController.swift
//  CoinPrices
//
//  Created by Jijun Lu on 4/10/18.
//  Copyright © 2018 Jijun Lu. All rights reserved.
//

import UIKit
import GoogleMobileAds

class RssViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, RssParserDelegate, GADBannerViewDelegate {
    
    @IBOutlet weak var adBanner: GADBannerView!
    var rssParser : RssParser!
    
    @IBOutlet weak var rssTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rssTableView.dataSource = self
        rssTableView.delegate = self
        rssTableView.rowHeight = 88
        
        let url = NSURL(string: "https://cryptocurrencynews.com/feed/")
        rssParser = RssParser()
        rssParser.delegate = self
        rssParser.startParsingWithContentsOfURL(rssURL: url!)
        
        initAdMobBanner()
    }
    
    func initAdMobBanner() {
        adBanner.adUnitID = Constants.adMobBannerUnitId
        adBanner.rootViewController = self
        adBanner.load(GADRequest())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func parsingWasFinished() {
        rssTableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rssParser.arrParsedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rssCell", for: indexPath as IndexPath) as! RssItemTableViewCell
        
        let currentDictionary = rssParser.arrParsedData[indexPath.row] as Dictionary<String, String>
        
        let cellText = String(format: "%@ - %@", currentDictionary["title"]!, currentDictionary["pubDate"]!)
        
        let attributedString = NSMutableAttributedString(string: cellText)
 
        cell.rssItemTextView.attributedText = attributedString
        cell.rssItemTextView.font = UIFont(name: "Avenir", size: 18)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     let dictionary = rssParser.arrParsedData[indexPath.row] as Dictionary<String, String>
     let rssItemLink = dictionary["link"]
     let publishDate = dictionary["pubDate"]
     
        let rssItemDetailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rssItemDetailsVC") as! RssItemDetailsViewController
     
        rssItemDetailsViewController.linky = rssItemLink!
        rssItemDetailsViewController.pubDate = publishDate!
     
        showDetailViewController(rssItemDetailsViewController, sender: self)
     }
    
}
