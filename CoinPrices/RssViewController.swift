//
//  RssViewController.swift
//  CoinPrices
//
//  Created by Jijun Lu on 4/10/18.
//  Copyright © 2018 Jijun Lu. All rights reserved.
//

import UIKit

class RssViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, RssParserDelegate {
    
    var rssParser : RssParser!
    
    @IBOutlet weak var rssTableView: UITableView!
    
    //var rssItems = [Dictionary<String, String>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rssTableView.dataSource = self
        rssTableView.delegate = self
        rssTableView.rowHeight = 80
        
        let url = NSURL(string: "https://cryptocurrencynews.com/feed/")
        rssParser = RssParser()
        rssParser.delegate = self
        rssParser.startParsingWithContentsOfURL(rssURL: url!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: XMLParserDelegate method implementation
    
    func parsingWasFinished() {
        print(rssParser.arrParsedData)
        rssTableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rssParser.arrParsedData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rssCell", for: indexPath as IndexPath) as! RssItemTableViewCell
        
        let currentDictionary = rssParser.arrParsedData[indexPath.row] as Dictionary<String, String>
        
        let attributedString = NSMutableAttributedString(string: currentDictionary["title"]!)
        attributedString.addAttribute(.link, value: currentDictionary["link"]!, range: NSRange(location: 0, length: currentDictionary["title"]!.count))
                
        cell.rssItemTextView.attributedText = attributedString
        cell.rssItemTextView.font = UIFont(name: "Avenir", size: 20)
        return cell
    }
    
    /*
     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
     return 80
     }
     */
    /*
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
     let dictionary = rssParser.arrParsedData[indexPath.row] as Dictionary<String, String>
     let tutorialLink = dictionary["link"]
     let publishDate = dictionary["pubDate"]
     
     let tutorialViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("idTutorialViewController") as TutorialViewController
     
     tutorialViewController.tutorialURL = NSURL(string: tutorialLink!)
     tutorialViewController.publishDate = publishDate
     
     showDetailViewController(tutorialViewController, sender: self)
     
     }
     */
}
