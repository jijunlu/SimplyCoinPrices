//
//  RssViewController.swift
//  CoinPrices
//
//  Created by Jijun Lu on 4/10/18.
//  Copyright © 2018 Jijun Lu. All rights reserved.
//

import UIKit
import GoogleMobileAds

struct NewsSourceInfo : Decodable {
    let name: String
}

struct NewsItem : Decodable {
    let title : String
    let url: String
    let published_on: UInt32
    let source_info: NewsSourceInfo
}

class RssViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, GADBannerViewDelegate {
    
    @IBOutlet weak var adBanner: GADBannerView!
    var refreshControl : UIRefreshControl!
    
    @IBOutlet weak var rssScrollView: UIScrollView!
    @IBOutlet weak var rssTableView: UITableView!
    
    var newsItems = [NewsItem]()

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
        let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: OperationQueue.main)
        let url = URL(string: Constants.rssFeedUrl)!
        
        let task = session.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data else {
                print("data error")
                return
            }
            
            guard let items = try? JSONDecoder().decode([NewsItem].self, from: data) else {
                print("decode error")
                return
            }
            
            self.newsItems = items
            self.rssTableView.reloadData()
            
        })
        task.resume()
    }
    
    
    func initAdMobBanner() {
        adBanner.adUnitID = Constants.adMobBannerUnitId
        adBanner.rootViewController = self
        adBanner.load(GADRequest())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rssCell", for: indexPath as IndexPath)
        
        let currentItem = newsItems[indexPath.row]
       
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let pubDateStr = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(currentItem.published_on)))
        
        let cellText = String(format: "%@\n%@  %@", currentItem.title, currentItem.source_info.name, pubDateStr)
        
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
     let newItem = newsItems[indexPath.row]
     let url = newItem.url
     
        let rssItemDetailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rssItemDetailsVC") as! RssItemDetailsViewController
     
        rssItemDetailsViewController.urlStr = url
        
        showDetailViewController(rssItemDetailsViewController, sender: self)
     }
    
}
