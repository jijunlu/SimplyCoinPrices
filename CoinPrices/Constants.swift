//
//  Constants.swift
//  CoinPrices
//
//  Created by Jijun Lu on 4/5/18.
//  Copyright © 2018 Jijun Lu. All rights reserved.
//

import Foundation

struct Constants {
    // UserDefaults keys
    static let UpdateIntervalSettingKey = "com.jijunlu.j3.SimplyCoinPrices.UpdateInterval"
    static let HistoricalDataRangeKey = "com.jijunlu.j3.SimplyCoinPrices.HistoricalDataRange"
    static let CoinPricesKey = "com.jijunlu.j3.CoinPrices.CoinPrices"
    static let AssetByCoinDictKey = "com.jijunlu.j3.CoinPrices.AssetByCoinDict"
    static let Top100CoinsKey = "com.jijunlu.j3.CoinPrices.Top100Tickers"
    
    // Notification names
    static let NotificationOfPriceUpdateKey = "com.jijunlu.j3.CoinPrices.NotificationOfPriceUpdate"
    
    // URLs
    static let CoinTickerUrl = "https://api.coinmarketcap.com/v1/ticker/"
    static let RssFeedUrl = "https://min-api.cryptocompare.com/data/news/?lang=EN"
    static let CoinPriceUrl = "https://min-api.cryptocompare.com/data/pricemultifull?tsyms=USD&fsyms="
    
    // Admob
    static let AdMobBannerUnitId = "ca-app-pub-4258982541138576/9768265072"
    static let AdMobApplicationId = "ca-app-pub-4258982541138576~2955444711"
    
    // App settings
    static let DefaultUpdateInterval : Float = 10
    static let UpdateIntervalStep : Float = 5
    static let HistoricalDataRanges: [Int] = [
        60,
        240,
        480,
        720,
        1440
    ]
    
    static let BaseCurrencies = [ "USD", "BTC", "ETH" ]
    static let DefaultBaseCurrency = "USD"
}
