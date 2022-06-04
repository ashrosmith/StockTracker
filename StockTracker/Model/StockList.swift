//
//  StockList.swift
//  StockTracker
//
//  Created by Ashley Smith on 2/28/22.
//

import Foundation
import RealmSwift

class StockList: Object {
    @objc dynamic var symbol: String = ""
}
