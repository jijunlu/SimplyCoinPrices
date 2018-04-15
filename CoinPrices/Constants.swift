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
    
    static let coinsToDisplayDictKey = "com.jijunlu.j3.SimplyCoinPrices.CoinsToDisplay"
    
    static let CoinPricesKey = "com.jijunlu.j3.CoinPrices.CoinPrices"
    
    static let CoinTickersKey = "com.jijunlu.j3.CoinPrices.CoinTickers"
    
    static let coinListDictKey = "com.jijunlu.j3.CoinPrices.CoinListDict"
    
    static let assetByCoinDictKey = "com.jijunlu.j3.CoinPrices.AssetByCoinDict"
        
    static let CoinTickerUrl = "https://api.coinmarketcap.com/v1/ticker/"
    
    static let rssFeedUrl = "https://min-api.cryptocompare.com/data/news/?lang=EN"
    
    static let adMobBannerUnitId = "ca-app-pub-4258982541138576/9768265072"
    
    static let adMobApplicationId = "ca-app-pub-4258982541138576~2955444711"
    
    static let defaultUpdateInterval : Float = 30
    
    static let updateIntervalStep : Float = 5
    
}
