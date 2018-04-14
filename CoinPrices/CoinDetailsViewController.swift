//
//  CoinDetailsViewController.swift
//  CoinPrices
//
//  Created by Jijun Lu on 4/14/18.
//  Copyright © 2018 Jijun Lu. All rights reserved.
//

import UIKit
import Charts

class CoinDetailsViewController: UIViewController {

    @IBOutlet weak var chartView: LineChartView!
    
    var inputCoinType = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        chartView.noDataText = ""
        
        /*
        chartView.chartDescription?.enabled = false

        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = false
        chartView.highlightPerDragEnabled = true
        
        //chartView.backgroundColor = .white
        */
        
        chartView.legend.enabled = false
        
        let xAxis = chartView.xAxis
        xAxis.enabled = false
        
        /*
        xAxis.labelPosition = .topInside
        xAxis.labelFont = .systemFont(ofSize: 10, weight: .light)
        xAxis.labelTextColor = UIColor(red: 255/255, green: 192/255, blue: 56/255, alpha: 1)
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = true
        xAxis.centerAxisLabelsEnabled = true
        //xAxis.granularity = 3600
        xAxis.valueFormatter = DateValueFormatter()
        
        let leftAxis = chartView.leftAxis
        leftAxis.labelPosition = .insideChart
        leftAxis.labelFont = .systemFont(ofSize: 12, weight: .light)
        leftAxis.drawGridLinesEnabled = true
        leftAxis.granularityEnabled = true
        //leftAxis.axisMinimum = 7900
        //leftAxis.axisMaximum = 8100
        //leftAxis.yOffset = -9
        leftAxis.labelTextColor = UIColor(red: 255/255, green: 192/255, blue: 56/255, alpha: 1)
        
 
        
        chartView.rightAxis.enabled = false
        */
        //chartView.legend.form = .line
        
        //chartView.animate(xAxisDuration: 2.5)

        
        
        
        getCoinDetails(coinType: inputCoinType.uppercased(), currency: "USD")
    }

    func ShowDetails(coinType: String) -> Void {
        
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
        let url = URL(string: String(format: "https://min-api.cryptocompare.com/data/histominute?fsym=%@&tsym=USD&limit=240", coinType.uppercased()))!
        
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
                let dateformatter = DateFormatter()
                dateformatter.dateStyle = DateFormatter.Style.short
                dateformatter.timeStyle = DateFormatter.Style.short
                
                dataEntries.append(ChartDataEntry(x: Double(price.time), y: Double(price.close)))
            }
            
            let chartDataSet = LineChartDataSet(values: dataEntries, label: "Prices")
            chartDataSet.colors = [UIColor.blue]
            chartDataSet.drawCirclesEnabled = false
            
            let chartData = LineChartData(dataSet: chartDataSet)
            
            self.chartView.data = chartData
            self.chartView.xAxis.valueFormatter = DateValueFormatter()
            self.chartView.legend.enabled = false
            
            //self.chartView.chartDescription?.text = "Crypto Price Chart"
        })
        task.resume()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
}
