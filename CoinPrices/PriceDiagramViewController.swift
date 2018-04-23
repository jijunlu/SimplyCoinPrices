//
//  CoinDetailsViewController.swift
//  CoinPrices
//
//  Created by Jijun Lu on 4/14/18.
//  Copyright © 2018 Jijun Lu. All rights reserved.
//

import UIKit
import Charts
import GoogleMobileAds

class PriceDiagramViewController: UIViewController {

    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var wrapperScrollView: UIScrollView!
    @IBOutlet weak var sliderView: UISlider!
    @IBOutlet weak var historicalDataRangeLabel: UILabel!
    
    @IBOutlet weak var pick1hButton: UIButton!
    @IBOutlet weak var pick4hButton: UIButton!
    @IBOutlet weak var pick1dButton: UIButton!
    @IBOutlet weak var pick1wButton: UIButton!
    @IBOutlet weak var pick1mButton: UIButton!
    @IBOutlet weak var pick1yButton: UIButton!
    @IBOutlet weak var pick5yButton: UIButton!
    
    @IBOutlet weak var diagramTitleLabel: UILabel!
    @IBOutlet weak var adBanner: GADBannerView!
    @IBOutlet weak var priceChartNavBar: UINavigationBar!
    
    var dataRangeButtons = [UIButton?]()
    
    var inputCoinType = String()
    var inputCoinName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataRangeButtons = [pick1hButton, pick4hButton, pick1dButton, pick1wButton, pick1mButton, pick1yButton, pick5yButton]
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        configChartView()
        
        loadCoinDetails()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.wrapperScrollView.refreshControl = refreshControl

        initAdMobBanner()
    }
    

    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                Utils.dismissFromLeft(sender: self)
            default:
                break
            }
        }
    }
    
    @objc func refresh(refreshControl: UIRefreshControl) {
        loadCoinDetails()

        refreshControl.endRefreshing()
    }
    
    @IBAction func onPick1h(_ sender: UIButton) {
        setDataRange(dataRange: "1h")
        loadCoinDetails()
    }
    
    @IBAction func onPick4h(_ sender: UIButton) {
        setDataRange(dataRange: "4h")
        loadCoinDetails()
    }
    
    @IBAction func onPick1d(_ sender: UIButton) {
        setDataRange(dataRange: "1d")
        loadCoinDetails()
    }
    
    @IBAction func onPick1w(_ sender: Any) {
        setDataRange(dataRange: "1w")
        loadCoinDetails()
    }
    
    @IBAction func onPick1m(_ sender: Any) {
        setDataRange(dataRange: "1m")
        loadCoinDetails()
    }
    
    
    @IBAction func onPick1y(_ sender: Any) {
        setDataRange(dataRange: "1y")
        loadCoinDetails()
    }
    
    @IBAction func onPick5y(_ sender: Any) {
        setDataRange(dataRange: "5y")
        loadCoinDetails()
    }
    
    func setDataRange(dataRange: String) {
        UserDefaults.standard.set(dataRange, forKey:Constants.HistoricalDataRangeKey)
    }
    
    struct PriceData: Decodable {
        let time: UInt32
        let close: Float
    }
    
    struct HistoricalData : Decodable {
        let Data : [PriceData]
    }
    
    func getSavedDataRange() -> String {
        guard let historicalDataRange = UserDefaults.standard.object(forKey: Constants.HistoricalDataRangeKey) else {
            return "1h"
        }
        
        return historicalDataRange as! String
    }
    
    func setSelectedButton(sender: UIButton) {
        for button in dataRangeButtons {
            if(button == sender) {
                button?.isSelected = true
            } else {
                button?.isSelected = false
            }
        }
    }
    
    
    func loadCoinDetails() -> Void {
        let historicalDataRange = getSavedDataRange()
        
        var urlStr = String(format: "https://min-api.cryptocompare.com/data/histominute?fsym=%@&tsym=USD&limit=60", inputCoinType.uppercased())
        
        switch historicalDataRange {
        case "1h":
            setSelectedButton(sender: pick1hButton)
            urlStr = String(format: "https://min-api.cryptocompare.com/data/histominute?fsym=%@&tsym=USD&limit=60", inputCoinType.uppercased())
        case "4h":
            setSelectedButton(sender: pick4hButton)
            urlStr = String(format: "https://min-api.cryptocompare.com/data/histominute?fsym=%@&tsym=USD&limit=240", inputCoinType.uppercased())
        case "1d":
            setSelectedButton(sender: pick1dButton)
            urlStr = String(format: "https://min-api.cryptocompare.com/data/histominute?fsym=%@&tsym=USD&limit=1440", inputCoinType.uppercased())
        case "1w":
            setSelectedButton(sender: pick1wButton)
            urlStr = String(format: "https://min-api.cryptocompare.com/data/histohour?fsym=%@&tsym=USD&limit=168", inputCoinType)
        case "1m":
            setSelectedButton(sender: pick1mButton)
            urlStr = String(format: "https://min-api.cryptocompare.com/data/histohour?fsym=%@&tsym=USD&limit=720", inputCoinType)
        case "1y":
            setSelectedButton(sender: pick1yButton)
            urlStr = String(format: "https://min-api.cryptocompare.com/data/histoday?fsym=%@&tsym=USD&limit=365", inputCoinType)
        case "5y":
            setSelectedButton(sender: pick5yButton)
            urlStr = String(format: "https://min-api.cryptocompare.com/data/histoday?fsym=%@&tsym=USD&limit=1825", inputCoinType)
        default:
            setSelectedButton(sender: pick1hButton)
        }
        
        let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: OperationQueue.main)
        let url = URL(string: urlStr)!
        
        let task = session.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data else {
                print("data error")
                return
            }
            
            guard let priceByMinutes = try? JSONDecoder().decode(HistoricalData.self, from: data) else {
                print("decode error")
                return
            }
            
            var dataEntries = [ChartDataEntry]()
            
            for price in priceByMinutes.Data {
                dataEntries.append(ChartDataEntry(x: Double(price.time), y: Double(price.close)))
            }
            
            self.diagramTitleLabel.text = String(format: "Latest %@ (%@) price: $ %.4f", self.inputCoinName, self.inputCoinType.uppercased(), Double(priceByMinutes.Data[priceByMinutes.Data.count - 1].close))
            
            let chartDataSet = LineChartDataSet(values: dataEntries, label: "Prices")
            chartDataSet.colors = [UIColor.blue]
            chartDataSet.drawCirclesEnabled = false
            
            let chartData = LineChartData(dataSet: chartDataSet)
            
            self.chartView.data?.clearValues()
            self.chartView.data = chartData
        })
        task.resume()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func configChartView() -> Void {
        chartView.noDataText = ""
        
        chartView.chartDescription?.enabled = false
        
        chartView.backgroundColor = .white
        
        chartView.legend.enabled = false
        chartView.maxVisibleCount = 1
        
        let xAxis = chartView.xAxis
        xAxis.enabled = false
        
        self.chartView.xAxis.valueFormatter = DateValueFormatter()
        
        let marker = TimePriceMarkerView(color: UIColor(white: 180/250, alpha: 1),
                                         font: .systemFont(ofSize: 16),
                                         textColor: .white,
                                         insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8),
                                         xAxisValueFormatter: chartView.xAxis.valueFormatter!)
        marker.chartView = chartView
        marker.minimumSize = CGSize(width: 80, height: 40)
        chartView.marker = marker
    }
    
    @IBAction func onClose(_ sender: Any) {
        Utils.dismissFromLeft(sender: self)
    }

    
    // Google ads
    func initAdMobBanner() {
        adBanner.adUnitID = Constants.AdMobBannerUnitId
        adBanner.rootViewController = self
        adBanner.load(GADRequest())
    }
}
