//
//  PortfolioPopUpViewController.swift
//  CoinPrices
//
//  Created by Jijun Lu on 4/9/18.
//  Copyright © 2018 Jijun Lu. All rights reserved.
//

import UIKit
import GoogleMobileAds

class PortfolioPopUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var adBanner: GADBannerView!
    @IBOutlet weak var coinPickerView: UIPickerView!
    @IBOutlet weak var selectedCoinText: UITextField!
    @IBOutlet weak var amountText: UITextField!

    var inputCoinType = String()
    var inputCoinAmount = Float()
    
    var coinPrices = [[String: String]]()
    var assetByCoinDict = [String: Float]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentAsset()
        
        if(inputCoinType.count > 0) {
            selectedCoinText.attributedText = NSMutableAttributedString(string: inputCoinType)
        }
        
        if(inputCoinAmount > 0) {
        amountText.attributedText = NSMutableAttributedString(string: String(inputCoinAmount))
        }
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)

        initAdMobBanner()
    }
    
    // Google ads
    func initAdMobBanner() {
        adBanner.adUnitID = Constants.adMobBannerUnitId
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

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func getRecentlySavedCoinPrices() -> [[String: String]] {
        let coinList = UserDefaults.standard.object(forKey: Constants.CoinPricesKey) as! [[String: String]]
        return coinList
    }
    
    func getCurrentAsset() -> Void {
        
        coinPrices = getRecentlySavedCoinPrices()
        
        let savedAssetByCoinDict = UserDefaults.standard.object(forKey: Constants.assetByCoinDictKey)
        
        if(savedAssetByCoinDict != nil) {
            assetByCoinDict = savedAssetByCoinDict as! [String: Float]
        }
        
        for coinPrice in coinPrices {
            if(!assetByCoinDict.keys.contains(coinPrice["symbol"]!)) {
                assetByCoinDict[coinPrice["symbol"]!] = 0.0
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
        
        self.view.endEditing(true)
        return coinPrices[row]["symbol"]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let selectedCoin = self.coinPrices[row]["symbol"]
        self.selectedCoinText.text = selectedCoin
        self.amountText.text = String(assetByCoinDict[selectedCoin!]!)
        self.coinPickerView.isHidden = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.selectedCoinText {
            self.coinPickerView.isHidden = false
            
            textField.endEditing(true)
        }
    }

    @IBAction func onClose(_ sender: Any) {
        SaveAndClose()
    }
    
    func SaveAndClose(){
        let selectedCoin = selectedCoinText.text
        let selectedCoinAmountText = amountText.text
        
        if(selectedCoin != nil && selectedCoinAmountText != nil) {
            assetByCoinDict[selectedCoin!] = Float(selectedCoinAmountText!)
            
            UserDefaults.standard.set(assetByCoinDict, forKey: Constants.assetByCoinDictKey)
        }
        
        self.dismiss(animated: true)
    }
}
