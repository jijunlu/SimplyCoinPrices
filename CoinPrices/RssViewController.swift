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
    var refreshControl : UIRefreshControl!
    
    @IBOutlet weak var rssScrollView: UIScrollView!
    @IBOutlet weak var rssTableView: UITableView!
    
    var allParsedData = [Dictionary<String, String>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rssTableView.dataSource = self
        rssTableView.delegate = self
        
        loadNews()
        
        initAdMobBanner()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        rssTableView.refreshControl = refreshControl
    }
    
    @objc func refresh(refreshControl: UIRefreshControl) {
        loadNews()
        
        refreshControl.endRefreshing()
    }

    func loadNews() -> Void {
            let url = NSURL(string: Constants.rssFeedUrl)
            rssParser = RssParser()
            rssParser.delegate = self
            rssParser.startParsingWithContentsOfURL(rssURL: url!)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "rssCell", for: indexPath as IndexPath)
        
        let currentDictionary = rssParser.arrParsedData[indexPath.row] as Dictionary<String, String>
        
        let cellText = String(format: "%@\n%@", currentDictionary["title"]!, currentDictionary["pubDate"]!.prefix(16).suffix(11) as CVarArg)
        
        cell.textLabel?.text = cellText
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont(name: "Avenir", size:20)
        //let attributedString = NSMutableAttributedString(string: cellText)
 
        //cell.rssItemTextView.attributedText = attributedString
        //cell.rssItemTextView.font = UIFont(name: "Avenir", size: 18)

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
