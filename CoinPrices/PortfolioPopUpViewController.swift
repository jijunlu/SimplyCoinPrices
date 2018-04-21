//
//  PortfolioPopUpViewController.swift
//  CoinPrices
//
//  Created by Jijun Lu on 4/9/18.
//  Copyright © 2018 Jijun Lu. All rights reserved.
//

import UIKit
import GoogleMobileAds

class PortfolioPopUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var adBanner: GADBannerView!
    @IBOutlet weak var coinTypeText: UITextField!
    @IBOutlet weak var coinAmountText: UITextField!
    @IBOutlet weak var costBaseText: UITextField!
    
    var inputCoinType = String()
    var inputCoinAmount = Double()
    var inputCostBase = Double()
    
    var coinPrices = [[String: String]]()
    var assetByCoinDict = [String: [String:Double]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentAsset()
        
        if(inputCoinType.count > 0) {
            coinTypeText.attributedText = NSMutableAttributedString(string: inputCoinType)
        }
        
        if(inputCoinAmount > 0) {
            coinAmountText.attributedText = NSMutableAttributedString(string: String(inputCoinAmount))
        }
        
        if(inputCostBase > 0) {
            costBaseText.attributedText = NSMutableAttributedString(string: String(inputCostBase))
        }
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)

        initAdMobBanner()
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        coinTypeText.inputView = pickerView
        
        coinAmountText.keyboardType = UIKeyboardType.decimalPad
        costBaseText.keyboardType = UIKeyboardType.decimalPad
    }
    
    // Google ads
    func initAdMobBanner() {
        adBanner.adUnitID = Constants.AdMobBannerUnitId
        adBanner.rootViewController = self
        adBanner.load(GADRequest())
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                SaveAndClose()
            default:
                break
            }
        }
    }
    
    func getRecentlySavedCoinPrices() -> [[String: String]] {
        let coinList = UserDefaults.standard.object(forKey: Constants.CoinPricesKey) as! [[String: String]]
        return coinList
    }
    
    func getCurrentAsset() -> Void {
        let savedAssetByCoinDict = UserDefaults.standard.object(forKey: Constants.AssetByCoinDictKey)
        
        if(savedAssetByCoinDict != nil) {
            assetByCoinDict = savedAssetByCoinDict as! [String: [String:Double]]
        }
        
        coinPrices = getRecentlySavedCoinPrices()
        for coinPrice in coinPrices {
            if(!assetByCoinDict.keys.contains(coinPrice["symbol"]!)) {
                assetByCoinDict[coinPrice["symbol"]!] = [
                    "amount": 0.0,
                    "costBase": 0.0
                ]
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinPrices.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return coinPrices[row]["symbol"]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let selectedCoin = self.coinPrices[row]["symbol"]
        self.coinTypeText.text = selectedCoin
        
        let amountAndCost = assetByCoinDict[selectedCoin!]!
        self.coinAmountText.text = String(amountAndCost["amount"]!)
        self.costBaseText.text = String(amountAndCost["costBase"]!)
    }
    
    @IBAction func onClose(_ sender: Any) {
        SaveAndClose()
    }
    
    func SaveAndClose(){
        let selectedCoin = coinTypeText.text
        let selectedCoinAmountText = coinAmountText.text
        let selectedCostBaseText = costBaseText.text
        
        if(selectedCoin != nil && selectedCoinAmountText != nil) {
            assetByCoinDict[selectedCoin!] = [
                "amount": Double(selectedCoinAmountText!)!,
                "costBase": Double(selectedCostBaseText!)!
            ]
            
            UserDefaults.standard.set(assetByCoinDict, forKey: Constants.AssetByCoinDictKey)
        }
        
        Utils.dismissFromLeft(sender: self)
    }
}
