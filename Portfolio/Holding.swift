//
//  Holding.swift
//  Portfolio
//
//  Created by Michael Shafer on 22/09/15.
//  Copyright © 2015 mshafer. All rights reserved.
//

import Foundation

class Holding: NSObject, NSCoding {
    // Required values
    var symbol: String
    var name: String
    var numberOfShares: Int
    var totalPurchasePrice: Double
    var currencyCode: String
    
    // Optional values
    var closingPrice: Double?
    var currentPrice: Double?
    
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
    
    init(symbol: String, name: String, numberOfShares: Int, totalPurchasePrice: Double, currencyCode: String) {
        self.symbol = symbol
        self.name = name
        self.numberOfShares = numberOfShares
        self.totalPurchasePrice = totalPurchasePrice
        self.currencyCode = currencyCode
    }
    
    // MARK: NSCoding
    
    required convenience init?(coder decoder: NSCoder) {
        print("Calling init with coder")
        guard let symbol = decoder.decodeObjectForKey("symbol") as? String,
            let name = decoder.decodeObjectForKey("name") as? String,
            let currencyCode = decoder.decodeObjectForKey("currencyCode") as? String
            else { return nil }
        
        self.init(
            symbol: symbol,
            name: name,
            numberOfShares: decoder.decodeIntegerForKey("numberOfShares"),
            totalPurchasePrice: decoder.decodeDoubleForKey("totalPurchasePrice"),
            currencyCode: currencyCode
        )
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.symbol, forKey: "symbol")
        coder.encodeObject(self.name, forKey: "name")
        coder.encodeInt(Int32(self.numberOfShares), forKey: "numberOfShares")
        coder.encodeDouble(self.totalPurchasePrice, forKey: "totalPurchasePrice")
        coder.encodeObject(self.currencyCode, forKey: "currencyCode")
    }
}