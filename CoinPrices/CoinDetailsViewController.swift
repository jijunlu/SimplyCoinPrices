//
//  CoinDetailsViewController.swift
//  CoinPrices
//
//  Created by Jijun Lu on 4/14/18.
//  Copyright © 2018 Jijun Lu. All rights reserved.
//

import UIKit

class CoinDetailsViewController: UIViewController {

    @IBOutlet weak var coinDetailsTextView: UITextView!
    
    var inputCoinType = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
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
            
            var cellText = String()
            for price in priceByMinutes.Data {
                let timeStamp = Date(timeIntervalSince1970: TimeInterval(price.time))

                let dateformatter = DateFormatter()
                dateformatter.dateStyle = DateFormatter.Style.short
                dateformatter.timeStyle = DateFormatter.Style.short
                let dateTimeStr = dateformatter.string(from: timeStamp)
                
                cellText.append(String(format:"%@: %f\n", dateTimeStr, price.close))
            }
            
            let attributedString = NSMutableAttributedString(string: cellText)
            
            self.coinDetailsTextView.attributedText = attributedString
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
