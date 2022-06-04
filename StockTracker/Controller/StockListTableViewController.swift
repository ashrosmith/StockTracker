//
//  StockListTableViewController.swift
//  StockTracker
//
//  Created by Ashley Smith on 2/26/22.
//

import UIKit
import SwipeCellKit
import RealmSwift

class StockListTableViewController: UITableViewController {
 
    let realm = try! Realm()
    var stocks: Results<StockList>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadStocks()
        let image = UIImageView(image: UIImage(named: "tableViewBackground"))
        tableView.backgroundView = image
        image.contentMode = UIView.ContentMode.scaleAspectFill
        tableView.rowHeight = 80.0
        tableView.separatorColor = UIColor(red: 0.19, green: 0.21, blue: 0.32, alpha: 1.00)
        
    }
    
//MARK: - Add Stocks Button
    
    @IBAction func addStockButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Stock", message: "", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add Ticker", style: .default) { (action) in
            let newStock = StockList()
            newStock.symbol = textField.text!
            self.save(stock: newStock)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        
        let cream = UIColor(red: 0.93, green: 0.90, blue: 0.81, alpha: 1.00)
        alert.view.tintColor = cream
        alert.setValue(NSAttributedString(string: alert.title!, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.medium), NSAttributedString.Key.foregroundColor : cream]), forKey: "attributedTitle")
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter ticker as ABC"
            alertTextField.textColor = cream
            textField = alertTextField
        }
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
//MARK: - Realm Methods
    
    func save(stock: StockList) {
        do {
            try realm.write {
                realm.add(stock)
            }
        } catch {
            print("Error saving context. \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadStocks() {
        stocks = realm.objects(StockList.self)
        tableView.reloadData()
    }
    
    
// MARK: - Table View Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocks?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        if let stock = stocks?[indexPath.row] {
            cell.textLabel?.text = stock.symbol
            cell.backgroundColor = UIColor(red: 0.93, green: 0.90, blue: 0.81, alpha: 1.00)
            cell.textLabel?.textColor = UIColor(red: 0.19, green: 0.21, blue: 0.32, alpha: 1.00)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "goToStockInformation", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! StockInformationViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            if let stock = stocks?[indexPath.row] {
                destinationVC.symbol = stock.symbol
            }
        }
    }
}

//MARK: - Swipe Table View Cell Methods

extension StockListTableViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

          let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
              self.updateModel(at: indexPath)
          }
        
        deleteAction.image = UIImage(systemName: "trash")
          return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    
    func updateModel(at indexPath: IndexPath) {
        if let stockForDeletion = self.stocks?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(stockForDeletion)
               }
            } catch {
                print("Error deleting entry, \(error).")
            }
        }
    }
}

