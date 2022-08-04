//
//  StockInformationViewController.swift
//  StockTracker
//
//  Created by Ashley Smith on 2/26/22.
//

import UIKit

class StockInformationViewController: UIViewController {
  
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var closeLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var marketStatusLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var preMarketLabel: UILabel!
    @IBOutlet weak var afterHoursLabel: UILabel!
    
    var symbol = String()
    var date = String()
    var stockManager = StockManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        marketStatusLabel.sizeToFit()
        symbolLabel.text = symbol
        stockManager.delegate = self
        loadStockInformation()
    }
    
 //MARK: - Search By Date Alert
    
    @IBAction func searchByDate(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Search by Date", message: "", preferredStyle: .alert)
        let searchAction = UIAlertAction(title: "Search", style: .default) { (action) in
            let searchDate = textField.text!
            self.dateLabel.text = searchDate
            self.marketStatusLabel.text = "Showing stock data from \(searchDate)."
            self.loadStockInformation()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        
        let cream = UIColor(red: 0.93, green: 0.90, blue: 0.81, alpha: 1.00)
        alert.view.tintColor = cream
        alert.setValue(NSAttributedString(string: alert.title!, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.medium), NSAttributedString.Key.foregroundColor : cream]), forKey: "attributedTitle")
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter date as yyyy-MM-dd"
            alertTextField.textColor = cream
            textField = alertTextField
        }
        
        alert.addAction(searchAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
//MARK: - Load Stock Information By Date Methods
    
    private func loadStockInformation() {
        if let ticker = symbolLabel.text {
            if let date = dateLabel.text {
                if date == "Date" {
                    getCurrentDate()
                } else {
                    stockManager.fetchStockInformation(stocksTicker: ticker, date: date)
                }
            }
        }
    }
    
    private func getCurrentDate() {
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: date)!
        let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: date)!
        let weekday = Calendar.current.component(.weekday, from: date)
        if let ticker = symbolLabel.text {
            if weekday == 7 {
                dateLabel.text = df.string(from: yesterday)
                marketStatusLabel.text = "The stock market is closed on Saturdays! Showing stock data from Friday."
                stockManager.fetchStockInformation(stocksTicker: ticker, date: df.string(from: yesterday))
            } else if weekday == 1 {
                dateLabel.text = df.string(from: twoDaysAgo)
                marketStatusLabel.text = "The stock market is closed on Sundays! Showing stock data from Friday."
                stockManager.fetchStockInformation(stocksTicker: ticker, date: df.string(from: twoDaysAgo))
            } else {
                dateLabel.text = df.string(from: date)
                marketStatusLabel.text = "The stock market is open today. Check back after close for updated data."
                stockManager.fetchStockInformation(stocksTicker: ticker, date: df.string(from: date))
            }
        }
    }
}
//MARK: - Stock Manager Delegate Methods

extension StockInformationViewController: StockManagerDelegate {
        
    func didUpdateStock(_stockManager: StockManager, stock: StockModel) {
        DispatchQueue.main.async {
            self.openLabel.text = String(stock.open)
            self.highLabel.text = String(stock.high)
            self.lowLabel.text = String(stock.low)
            self.closeLabel.text = String(stock.close)
            self.volumeLabel.text = String(stock.volume)
            self.afterHoursLabel.text = String(stock.afterHours)
            self.preMarketLabel.text = String(stock.preMarket)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
