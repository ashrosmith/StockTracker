//
//  StockData.swift
//  StockTracker
//
//  Created by Ashley Smith on 2/26/22.
//

import Foundation

struct StockData: Codable {
    let symbol: String
    let open: Double
    let high: Double
    let low: Double
    let close: Double
    let volume: Double
    let afterHours: Double
    let preMarket: Double
}


