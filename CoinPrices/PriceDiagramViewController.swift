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
    
    var inputCoinType = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        configChartView()
        
        getCoinDetails(coinType: inputCoinType.uppercased(), currency: "USD")
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.wrapperScrollView.refreshControl = refreshControl
    }
    
    @objc func refresh(refreshControl: UIRefreshControl) {
        getCoinDetails(coinType: inputCoinType.uppercased(), currency: "USD")

        refreshControl.endRefreshing()
    }
    
    struct PriceData: Decodable {
        let time: UInt32
        let close: Float
    }
    
    struct HistoricalData : Decodable {
        let Data : [PriceData]
    }
    
    func getCoinDetails(coinType: String, currency: String) -> Void {
        let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: OperationQueue.main)
        let url = URL(string: String(format: "https://min-api.cryptocompare.com/data/histominute?fsym=%@&tsym=USD&limit=1440", coinType.uppercased()))!
        
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
            
            self.chartView.data = chartData
        })
        task.resume()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    func configChartView() -> Void {
        chartView.noDataText = ""
        
        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = false
        chartView.highlightPerDragEnabled = true
        
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
        
        chartView.animate(xAxisDuration: 2.5)
    }
}
