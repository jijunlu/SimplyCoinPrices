//
//  PortfolioPopUpViewController.swift
//  CoinPrices
//
//  Created by Jijun Lu on 4/9/18.
//  Copyright © 2018 Jijun Lu. All rights reserved.
//

import UIKit

class PortfolioPopUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var coinPickerView: UIPickerView!
    @IBOutlet weak var selectedCoinText: UITextField!
    @IBOutlet weak var amountText: UITextField!

    
    var coinList = [String]()
    var assetByCoinDict = [String: Float]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getCurrentAsset()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func getCoinList() -> [String] {
        guard let coinList = UserDefaults.standard.object(forKey: Constants.coinsToDisplayDictKey) else {
            return Constants.CoinMap.keys.sorted()
        }
        
        let temp = coinList as! [String: [String]]
        return temp.keys.sorted()
    }
    
    func getCurrentAsset() -> Void {
        
        coinList = getCoinList()
        
        let savedAssetByCoinDict = UserDefaults.standard.object(forKey: Constants.assetByCoinDictKey)
        
        if(savedAssetByCoinDict != nil) {
            assetByCoinDict = savedAssetByCoinDict as! [String: Float]
        }
        
        for coinType in coinList {
            if(!assetByCoinDict.keys.contains(coinType)) {
                assetByCoinDict[coinType] = 0.0
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
        return coinList.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        self.view.endEditing(true)
        return coinList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let selectedCoin = self.coinList[row]
        self.selectedCoinText.text = selectedCoin
        self.amountText.text = String(assetByCoinDict[selectedCoin]!)
        self.coinPickerView.isHidden = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.selectedCoinText {
            self.coinPickerView.isHidden = false
            
            textField.endEditing(true)
        }
    }
    
    @IBAction func saveChanges(_ sender: Any) {
        let selectedCoin = selectedCoinText.text
        let selectedCoinAmountText = amountText.text
        
        if(selectedCoin != nil && selectedCoinAmountText != nil) {
            assetByCoinDict[selectedCoin!] = Float(selectedCoinAmountText!)
        }
        
        UserDefaults.standard.set(assetByCoinDict, forKey: Constants.assetByCoinDictKey)
    }
    
    @IBAction func closeView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
