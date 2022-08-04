//
//  StockDataTest.swift
//  StockTrackerTests
//
//  Created by Ashley Smith on 6/15/22.
//

import XCTest
@testable import StockTracker

class StockDataTest: XCTestCase {

    func testCanParseStockInformation() {
        let stockInformation =  """
        [
        "symbol": "TSLA",
        "open": 33.4,
        "high": 35.6,
        "low": 32.9,
        "close": 33.6,
        "volume": 30000.0,
        "afterHours": 33.6,
        "preMarket": 33.4
                            ]
        """
        let stockData = stockInformation.data(using: .utf8)!
        let decoder = JSONDecoder()
        let decodedData = try! decoder.decode(StockData.self, from: stockData)
        XCTAssertEqual("TSLA", decodedData.symbol)
        XCTAssertEqual(33.4, decodedData.open)
        XCTAssertEqual(35.6, decodedData.high)
        XCTAssertEqual(32.9, decodedData.low)
        XCTAssertEqual(33.6, decodedData.close)
        XCTAssertEqual(30000, decodedData.volume)
        XCTAssertEqual(33.6, decodedData.afterHours)
        XCTAssertEqual(33.4, decodedData.preMarket)
        
    }

}
