//
//  CustomPercentFormatter.swift
//  Yorgan
//
//  Created by Berat Yükselen on 10.05.2025.
//

import UIKit
import Foundation
import DGCharts

class CustomPercentFormatter: ValueFormatter {
    private var total: Double

    init(total: Double) {
        self.total = total
    }

    override func string(for value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        let percent = (value / total) * 100
        return String(format: "%.1f%%", percent)
    }
}

