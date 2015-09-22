//
//  Holding.swift
//  Portfolio
//
//  Created by Michael Shafer on 22/09/15.
//  Copyright © 2015 mshafer. All rights reserved.
//

import Foundation

class Holding {
    // Required values
    var symbol: String
    var numberOfShares: Int
    var totalPurchasePrice: Double
    
    // Optional values
    var closingPrice: Double?
    var currentPrice: Double?
    var currency: String?
    
    // Computed properties
    var closingValue: Double {
        get {
            return Double(self.numberOfShares) * self.closingPrice!
        }
    }
    var currentValue: Double {
        get {
            return Double(self.numberOfShares) * self.currentPrice!
        }
    }
    var changeTodayAsFraction: Double {
        get {
            return (self.currentPrice! - self.closingPrice!) / self.closingPrice!
        }
    }
    var changeTodayAsDollars: Double {
        get {
            return self.changeTodayAsFraction * self.closingValue
        }
    }
    
    init(symbol: String, numberOfShares: Int, totalPurchasePrice: Double) {
        self.symbol = symbol
        self.numberOfShares = numberOfShares
        self.totalPurchasePrice = totalPurchasePrice
    }
}