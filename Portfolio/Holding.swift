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
    var changeTodayAsFraction: Double?
    var currentPrice: Double?
    
    // Computed properties
    var closingValue: Double? {
        get {
            guard let currentValue = self.currentValue,
                let changeTodayAsFraction = self.changeTodayAsFraction else {
                return nil
            }
            return currentValue / (1 + changeTodayAsFraction)
        }
    }
    var currentValue: Double? {
        get {
            guard let currentPrice = self.currentPrice else {
                return nil
            }
            return Double(self.numberOfShares) * currentPrice
        }
    }
    var changeTodayAsDollars: Double? {
        get {
            guard let changeTodayAsFraction = self.changeTodayAsFraction,
                let closingValue = self.closingValue else {
                    return nil
            }
            return changeTodayAsFraction * closingValue
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