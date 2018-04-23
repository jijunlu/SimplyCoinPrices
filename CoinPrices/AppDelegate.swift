//
//  AppDelegate.swift
//  FoodTracker
//
//  Created by Jijun Lu on 2/12/18.
//  Copyright © 2018 Jijun Lu. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GADMobileAds.configure(withApplicationID: Constants.AdMobApplicationId)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], for: UIControlState.normal)

        //UIApplication.shared.setMinimumBackgroundFetchInterval(120)

        return true
    }
    

    func parsePrice(priceVal: Any) -> String {
        if priceVal is String {
            return priceVal as! String
        } else {
            return String(priceVal as! Double)
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    /*
     func application(_ application: UIApplication,
     performFetchWithCompletionHandler completionHandler:
     @escaping (UIBackgroundFetchResult) -> Void) {
     // Check for new data.
     getPrices()
     completionHandler(.newData)
     }
     
     
     @objc func getPrices() -> Void {
     
     
     let center = UNUserNotificationCenter.current()
     let options: UNAuthorizationOptions = [.alert, .sound, .badge];
     center.requestAuthorization(options: options) {
     (granted, error) in
     if !granted {
     print("Something went wrong")
     }
     }
     center.getNotificationSettings { (settings) in
     if settings.authorizationStatus != .authorized {
     print("Something went wrong 2")
     }
     }
     
     let top100Tickers = UserDefaults.standard.object(forKey: "Top100Tickers") as! [String]
     
     let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: OperationQueue.main)
     let url = URL(string: String(format: "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=%@&tsyms=USD", top100Tickers.joined(separator: ",")))!
     
     let task = session.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
     guard let data = data else {
     print("!!!!!!!!!!!!!!!! data error !!!!!!!!!!!!!!!")
     return
     }
     
     let json = try? JSONSerialization.jsonObject(with: data, options: [])
     
     let jsonDict = json as! [String:Any]
     let displayDict = jsonDict["RAW"] as! [String:Any]
     
     var arrayOfDict = [[String: String]]()
     for ticker in top100Tickers {
     if(!displayDict.keys.contains(ticker)) {
     continue
     }
     
     let fullTickerData = displayDict[ticker] as! [String: Any]
     let usdData = fullTickerData["USD"] as? [String:Any]
     
     arrayOfDict.append([
     "name": ticker,
     "symbol": ticker,
     "price_usd": self.parsePrice(priceVal: usdData!["PRICE"]!),
     "percent_change_24h": String(format:"%.2f", usdData!["CHANGEPCT24HOUR"] as! Double)
     ])
     }
     
     
     print("===========================")
     print(arrayOfDict[0]["price_usd"]!)
     
     let trigger = UNTimeIntervalNotificationTrigger(timeInterval:1, repeats: false)
     
     let content = UNMutableNotificationContent()
     content.title = "Latest Bitcoin Price"
     content.body = String(format: "Bitcoin Prics is: %@", arrayOfDict[0]["price_usd"]!)
     content.sound = UNNotificationSound.default()
     
     let request = UNNotificationRequest(identifier: arrayOfDict[0]["price_usd"]!, content: content, trigger: trigger)
     UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
     UNUserNotificationCenter.current().add(request) {(error) in
     if let error = error {
     print("Uh oh! We had an error: \(error)")
     }
     }
     
     })
     task.resume()
     }
     */
    
}

