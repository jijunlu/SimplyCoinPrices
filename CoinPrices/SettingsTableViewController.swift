//
//  SettingsTableViewController.swift
//  CoinPrices
//
//  Created by Jijun Lu on 4/6/18.
//  Copyright © 2018 Jijun Lu. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {


    @IBOutlet weak var updateIntervalLabel: UILabel!
    @IBOutlet weak var updateIntervalSlider: UISlider!
    
    @IBOutlet weak var btcSwitch: UISwitch!
    @IBOutlet weak var ethSwitch: UISwitch!
    @IBOutlet weak var xrpSwitch: UISwitch!
    @IBOutlet weak var bchSwitch: UISwitch!
    @IBOutlet weak var ltcSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displaySettings()
    }
    
    func displaySettings()
    {
        // Update interval setting
        guard let updateInterval = UserDefaults.standard.object(forKey: Constants.updateIntervalSettingKey) else {
            updateIntervalSlider.value = Constants.defaultUpdateInterval
            updateIntervalLabel.text = String(Constants.defaultUpdateInterval)
            return
        }
        
        updateIntervalSlider.value = updateInterval as! Float
        updateIntervalLabel.text = String(updateInterval as! Float)
        
        // Coins to display
        guard let coinsToDisplay = UserDefaults.standard.object(forKey: Constants.coinsToDisplayKey) else {
            let defaultCoinsToDisplay = Dictionary(grouping: Constants.CoinMap.keys.sorted(), by: {$0})
            UserDefaults.standard.set(defaultCoinsToDisplay, forKey: Constants.coinsToDisplayKey)
            setCoinSwitches(coinsToDisplay: defaultCoinsToDisplay)
            return
        }
        setCoinSwitches(coinsToDisplay: coinsToDisplay as! [String: [String]])
    }
    
    func setCoinSwitches(coinsToDisplay: [String: [String]]) -> Void {
        btcSwitch.isOn = coinsToDisplay.keys.contains("BTC") ? true : false
        ethSwitch.isOn = coinsToDisplay.keys.contains("ETH") ? true : false
        xrpSwitch.isOn = coinsToDisplay.keys.contains("XRP") ? true : false
        bchSwitch.isOn = coinsToDisplay.keys.contains("BCH") ? true : false
        ltcSwitch.isOn = coinsToDisplay.keys.contains("LTC") ? true : false
    }

    @IBAction func onUpdateIntervalSliderChanged(_ sender: UISlider) {
        let newInterval = round(sender.value / Constants.updateIntervalStep ) * Constants.updateIntervalStep
        sender.value = newInterval
        updateIntervalLabel.text = String(newInterval)
        UserDefaults.standard.set(newInterval, forKey:Constants.updateIntervalSettingKey)
    }
    
    // When disable/enable coin switch
    @IBAction func onBtcSwitchChanged(_ sender: UISwitch) {
        var coinsToDisplay = UserDefaults.standard.object(forKey: Constants.coinsToDisplayKey) as! [String: [String]]
        if(sender.isOn) {
            coinsToDisplay["BTC"] = ["BTC"]
        } else {
            coinsToDisplay.removeValue(forKey: "BTC")
        }
        
        UserDefaults.standard.set(coinsToDisplay, forKey: Constants.coinsToDisplayKey)
    }
    
    @IBAction func onEthSwitchChanged(_ sender: UISwitch) {
        var coinsToDisplay = UserDefaults.standard.object(forKey: Constants.coinsToDisplayKey) as! [String: [String]]
        if(sender.isOn) {
            coinsToDisplay["ETH"] = ["ETH"]
        } else {
            coinsToDisplay.removeValue(forKey: "ETH")
        }
        
        UserDefaults.standard.set(coinsToDisplay, forKey: Constants.coinsToDisplayKey)
    }
    
    @IBAction func onXrpSwitchChanged(_ sender: UISwitch) {
        var coinsToDisplay = UserDefaults.standard.object(forKey: Constants.coinsToDisplayKey) as! [String: [String]]
        if(sender.isOn) {
            coinsToDisplay["XRP"] = ["XRP"]
        } else {
            coinsToDisplay.removeValue(forKey: "XRP")
        }
        
        UserDefaults.standard.set(coinsToDisplay, forKey: Constants.coinsToDisplayKey)
    }

    @IBAction func onBchSwitchChanged(_ sender: UISwitch) {
        var coinsToDisplay = UserDefaults.standard.object(forKey: Constants.coinsToDisplayKey) as! [String: [String]]
        if(sender.isOn) {
            coinsToDisplay["BCH"] = ["BCH"]
        } else {
            coinsToDisplay.removeValue(forKey: "BCH")
        }
        
        UserDefaults.standard.set(coinsToDisplay, forKey: Constants.coinsToDisplayKey)
    }

    @IBAction func onLtcSwitchChanged(_ sender: UISwitch) {
        var coinsToDisplay = UserDefaults.standard.object(forKey: Constants.coinsToDisplayKey) as! [String: [String]]
        if(sender.isOn) {
            coinsToDisplay["LTC"] = ["LTC"]
        } else {
            coinsToDisplay.removeValue(forKey: "LTC")
        }
        
        UserDefaults.standard.set(coinsToDisplay, forKey: Constants.coinsToDisplayKey)
    }
    

}
