//
//  CoinDetailsViewController.swift
//  CoinPrices
//
//  Created by Jijun Lu on 4/14/18.
//  Copyright © 2018 Jijun Lu. All rights reserved.
//

import UIKit
import Charts

class PriceDiagramViewController: UIViewController {

    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var wrapperScrollView: UIScrollView!
    @IBOutlet weak var sliderView: UISlider!
    @IBOutlet weak var historicalDataRangeLabel: UILabel!
    
    @IBOutlet weak var pick1hButton: UIButton!
    @IBOutlet weak var pick4hButton: UIButton!
    @IBOutlet weak var pick8hButton: UIButton!
    @IBOutlet weak var pick1dButton: UIButton!
    @IBOutlet weak var pick1wButton: UIButton!
    @IBOutlet weak var pick1mButton: UIButton!
    @IBOutlet weak var pick1yButton: UIButton!
    
    var dataRangeButtons = [UIButton?]()
    
    var inputCoinType = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataRangeButtons = [pick1hButton, pick4hButton, pick8hButton, pick1dButton, pick1wButton, pick1mButton, pick1yButton]
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        configChartView()
        
        loadCoinDetails()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.wrapperScrollView.refreshControl = refreshControl
    }
    

    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                self.dismiss(animated: true)
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
        ReloadChartViewOnDataRangeChange(sender: sender, dataRangeInMinutesStr: "60")
    }
    
    @IBAction func onPick4h(_ sender: UIButton) {
        ReloadChartViewOnDataRangeChange(sender: sender, dataRangeInMinutesStr: "240")
    }
    
    @IBAction func onPick8h(_ sender: UIButton) {
        ReloadChartViewOnDataRangeChange(sender: sender, dataRangeInMinutesStr: "480")
    }
    
    @IBAction func onPick1d(_ sender: UIButton) {
        ReloadChartViewOnDataRangeChange(sender: sender, dataRangeInMinutesStr: "1440")
    }
    
    func ReloadChartViewOnDataRangeChange(sender: UIButton, dataRangeInMinutesStr: String) {
        if(sender.isSelected) {
            return
        }
        
        for button in dataRangeButtons {
            if(button == sender) {
                sender.isSelected = true
            } else {
                sender.isSelected = false
            }
        }
        
        UserDefaults.standard.set(dataRangeInMinutesStr, forKey:Constants.historicalDataRangeKey)
        
        loadCoinDetails()
    }
    
    struct PriceData: Decodable {
        let time: UInt32
        let close: Float
    }
    
    struct HistoricalData : Decodable {
        let Data : [PriceData]
    }
    
    func getSavedDataRange() -> String {
        guard let historicalDataRangeInMinutes = UserDefaults.standard.object(forKey: Constants.historicalDataRangeKey) else {
            return "60"
        }
        
        return historicalDataRangeInMinutes as! String
    }
    
    func loadCoinDetails() -> Void {
        let historicalDataRangeInMinutes = getSavedDataRange()
        let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: OperationQueue.main)
        let url = URL(string: String(format: "https://min-api.cryptocompare.com/data/histominute?fsym=%@&tsym=USD&limit=%@", inputCoinType.uppercased(), historicalDataRangeInMinutes))!
        
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
        
        let xAxis = chartView.xAxis
        xAxis.enabled = false
        
        self.chartView.xAxis.valueFormatter = DateValueFormatter()
        self.chartView.legend.enabled = false
        
        self.chartView.chartDescription?.text = "Crypto Price Chart"
        
        let marker = TimePriceMarkerView(color: UIColor(white: 180/250, alpha: 1),
                                         font: .systemFont(ofSize: 12),
                                         textColor: .white,
                                         insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8),
                                         xAxisValueFormatter: chartView.xAxis.valueFormatter!)
        marker.chartView = chartView
        marker.minimumSize = CGSize(width: 80, height: 40)
        chartView.marker = marker
        
        //chartView.animate(xAxisDuration: 2.5)
    }
}
