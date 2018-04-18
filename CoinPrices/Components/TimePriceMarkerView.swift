//
//  XYMarkerView.swift
//  CoinPrices
//
//  Created by Jijun Lu on 4/14/18.
//  Copyright © 2018 Jijun Lu. All rights reserved.
//

import Foundation
import Charts

public class TimePriceMarkerView: BalloonMarker {
    public var xAxisValueFormatter: IAxisValueFormatter
    fileprivate var yFormatter = NumberFormatter()
    
    public init(color: UIColor, font: UIFont, textColor: UIColor, insets: UIEdgeInsets,
                xAxisValueFormatter: IAxisValueFormatter) {
        self.xAxisValueFormatter = xAxisValueFormatter
        yFormatter.minimumFractionDigits = 1
        yFormatter.maximumFractionDigits = 1
        super.init(color: color, font: font, textColor: textColor, insets: insets)
    }
    
    public override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        let string = ""
            + xAxisValueFormatter.stringForValue(entry.x, axis: XAxis())
            + "\n$"
            + String(format:"%.4f", entry.y)
        setLabel(string)
    }
    
}
