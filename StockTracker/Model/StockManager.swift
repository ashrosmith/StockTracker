//
//  StockManager.swift
//  StockTracker
//
//  Created by Ashley Smith on 2/26/22.
//

import Foundation

protocol StockManagerDelegate {
    func didUpdateStock(_stockManager: StockManager, stock: StockModel)
    func didFailWithError(error: Error)
}

struct StockManager {
    let stockURL = "https://api.polygon.io/v1/open-close"
    let apiKey = "PASTE_YOUR_POLYGON_API_KEY_HERE"
    var delegate: StockManagerDelegate?
    
    func fetchStockInformation(stocksTicker: String, date: String) {
        let urlString = "\(stockURL)/\(stocksTicker)/\(date)?adjusted=true&apiKey=\(apiKey)"
        performRequest(with: urlString)
        print(urlString)
    }

    func performRequest(with urlString: String) {
        if let fixedURLString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            if let url = URL(string: fixedURLString) {
                let session = URLSession(configuration: .default)
                let task = session.dataTask(with: url) { (data, response, error) in
                    if error != nil {
                        self.delegate?.didFailWithError(error: error!)
                        return
                    }
                    if let safeData = data {
                        if let stock = self.parseJSON(stockData: safeData) {
                            self.delegate?.didUpdateStock(_stockManager: self, stock: stock)
                        }
                    }
                }
                task.resume()
            } else {
                print ("Malformed URL")
            }
        }
    }
    
    func parseJSON(stockData: Data) -> StockModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(StockData.self, from: stockData)
            let symbol = decodedData.symbol
            let open = decodedData.open
            let high = decodedData.high
            let low = decodedData.low
            let close = decodedData.close
            let volume = decodedData.volume
            let afterHours = decodedData.afterHours
            let preMarket = decodedData.preMarket
            let stockInformation = StockModel(symbol: symbol, open: open, high: high, low: low, close: close, volume: volume, afterHours: afterHours, preMarket: preMarket)
            return stockInformation
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
    
