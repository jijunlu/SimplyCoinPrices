//
//  Utils.swift
//  CoinPrices
//
//  Created by Jijun Lu on 4/21/18.
//  Copyright © 2018 Jijun Lu. All rights reserved.
//

import Foundation
import UIKit

public class Utils {
    static func parsePriceFromJson(priceVal: Any) -> String {
        if priceVal is String {
            return priceVal as! String
        } else {
            return String(priceVal as! Double)
        }
    }
    
    static func get4PrecisionPriceString(priceInfo: Double, prefix: String = "", suffix: String = "") -> String {
        return String(format:"%@%.4f%@", prefix, priceInfo, suffix)
    }
    
    static func dismissFromLeft(sender: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        sender.view.layer.add(transition, forKey: "leftToRightTransition")
        sender.dismiss(animated: true, completion: nil)
    }
    
    static func getSavedCoinPriceDict() -> [String: [String: String]] {
        let savedCoinPrices = UserDefaults.standard.object(forKey: Constants.CoinPricesKey) as! [[String: String]]
        
        var coinPriceDict = [String: [String: String]]()
        for coinPrice in savedCoinPrices {
            coinPriceDict[coinPrice["symbol"]!] = coinPrice
        }
        
        return coinPriceDict
    }
}
