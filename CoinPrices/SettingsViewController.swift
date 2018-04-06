//
//  SettingsViewController.swift
//  CoinPrices
//
//  Created by Jijun Lu on 4/5/18.
//  Copyright © 2018 Jijun Lu. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var updateIntervalSlider: UISlider!
    @IBOutlet weak var updateIntervalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        displaySettings()
    }
    
    func displaySettings()
    {
        guard let updateInterval = UserDefaults.standard.object(forKey: Constants.updateIntervalSettingKey) else {
            updateIntervalSlider.value = Constants.defaultUpdateInterval
            updateIntervalLabel.text = String(Constants.defaultUpdateInterval)
            return
        }
        
        updateIntervalSlider.value = updateInterval as! Float
        updateIntervalLabel.text = String(updateInterval as! Float)
    }
    
    @IBAction func updateIntervalChanges(_ sender: UISlider) {
        let newInterval = round(sender.value / Constants.updateIntervalStep ) * Constants.updateIntervalStep
        sender.value = newInterval
        updateIntervalLabel.text = String(newInterval)
        UserDefaults.standard.set(newInterval, forKey:Constants.updateIntervalSettingKey)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
