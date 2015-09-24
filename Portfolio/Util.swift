//
//  Util.swift
//  Portfolio
//
//  Created by Michael Shafer on 23/09/15.
//  Copyright © 2015 mshafer. All rights reserved.
//

import Foundation

class Util {
    
    // TODO: Complete this list!
    static var localeByCurrencyCode: [String: NSLocale] = [
        "USD": NSLocale(localeIdentifier: "en_US"),
        "NZD": NSLocale(localeIdentifier: "en_NZ"),
        "JPY": NSLocale(localeIdentifier: "ja_JP"),
    ]
    
    class func currencyToString(value: Double, currencyCode: String) -> String {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.minimumFractionDigits = 2
        formatter.currencyCode = currencyCode
        if let locale = localeByCurrencyCode[currencyCode] {
            formatter.locale = locale
        }
        return formatter.stringFromNumber(NSNumber(double: value))!
    }
    
    class func fractionToPercentage(value: Double) -> String {
        return String(format: "%.2f%%", value * 100)
    }
    
    class func percentageToFraction(percentageString: String) -> Double {
        let numberString = percentageString.stringByReplacingOccurrencesOfString("%", withString: "")
        return (numberString as NSString).doubleValue / 100
    }
    
    class func documentsDirectory() -> NSString {
        return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    }
}