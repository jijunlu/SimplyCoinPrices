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

    
    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displaySettings()
    }
    
    func displaySettings()
    {
        versionLabel.text = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        
        // Update interval setting
        guard let updateInterval = UserDefaults.standard.object(forKey: Constants.UpdateIntervalSettingKey) else {
            updateIntervalSlider.value = Constants.DefaultUpdateInterval
            updateIntervalLabel.text = String(Constants.DefaultUpdateInterval)
            return
        }
        
        updateIntervalSlider.value = updateInterval as! Float
        updateIntervalLabel.text = String(updateInterval as! Float)
    }

    @IBAction func onUpdateIntervalSliderChanged(_ sender: UISlider) {
        let newInterval = round(sender.value / Constants.UpdateIntervalStep ) * Constants.UpdateIntervalStep
        sender.value = newInterval
        updateIntervalLabel.text = String(newInterval)
        UserDefaults.standard.set(newInterval, forKey:Constants.UpdateIntervalSettingKey)
    }
}
