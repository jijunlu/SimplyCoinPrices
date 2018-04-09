//
//  Constants.swift
//  CoinPrices
//
//  Created by Jijun Lu on 4/5/18.
//  Copyright © 2018 Jijun Lu. All rights reserved.
//

import Foundation

struct Constants {
    static let updateIntervalSettingKey = "com.jijunlu.j3.SimplyCoinPrices.UpdateInterval"
    
    static let coinsToDisplayKey = "com.jijunlu.j3.SimplyCoinPrices.CoinsToDisplay"
    
    static let coinPriceDictKey = "com.jijunlu.j3.CoinPrices.CoinPriceDict"
    
    static let baseUrl = "https://www.bitstamp.net/api/v2/ticker"
    
    static let adMobBannerUnitId = "ca-app-pub-4258982541138576/9768265072"
    
    static let adMobApplicationId = "ca-app-pub-4258982541138576~2955444711"
    
    static let defaultUpdateInterval : Float = 30
    
    static let updateIntervalStep : Float = 5
    
    static let CoinMap : [String: [String: String]] = [
        "BTC":  [
            "FullName": "Bitcoin",
            "IsOn": String(true)
        ],
        "ETH": [
            "FullName": "Ethereum",
            "IsOn": String(true)
        ],
        "XRP": [
            "FullName": "Ripple",
            "IsOn": String(true)
        ],
        "BCH": [
            "FullName": "Bitcoin Cash",
            "IsOn": String(true)
        ],
        "LTC": [
            "FullName": "Litecoin",
            "IsOn": String(true)
        ]
    ]
    
}
