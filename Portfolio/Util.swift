//
//  Util.swift
//  Portfolio
//
//  Created by Michael Shafer on 23/09/15.
//  Copyright © 2015 mshafer. All rights reserved.
//

import Foundation

class Util {
    class func currencyToString(value: Double, currencyCode: String) -> String {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.minimumFractionDigits = 2
        formatter.currencyCode = currencyCode
        if let locale = localeByCurrencyCode[currencyCode] {
            formatter.locale = locale
        } else {
            print("Unable to find locale for \(currencyCode)")
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
    
    class func debounce( delay:NSTimeInterval, queue:dispatch_queue_t, action: (()->()) ) -> ()->() {
        var lastFireTime : dispatch_time_t = 0
        let dispatchDelay = Int64(delay * Double(NSEC_PER_SEC))
        
        return {
            lastFireTime = dispatch_time(DISPATCH_TIME_NOW,0)
            dispatch_after(
                dispatch_time(
                    DISPATCH_TIME_NOW,
                    dispatchDelay
                ),
                queue) {
                    let now = dispatch_time(DISPATCH_TIME_NOW,0)
                    let when = dispatch_time(lastFireTime, dispatchDelay)
                    if now >= when {
                        action()
                    }
            }
        }
    }
    
    class func getLocalCurrencyCode() -> String {
        return NSLocale.currentLocale().objectForKey(NSLocaleCurrencyCode) as! String
    }
    
    private static var localeByCurrencyCode: [String: NSLocale] = [
        "AUD": NSLocale(localeIdentifier: "en_AU"),
        "BGN": NSLocale(localeIdentifier: "bg_BG"),
        "BRL": NSLocale(localeIdentifier: "pt_BR"),
        "CAD": NSLocale(localeIdentifier: "en_CA"),
        "CHF": NSLocale(localeIdentifier: "gsw_CH"),
        "CNY": NSLocale(localeIdentifier: "zh_Hans_CN"),
        "CZK": NSLocale(localeIdentifier: "cs_CZ"),
        "DKK": NSLocale(localeIdentifier: "da_DK"),
        "GBP": NSLocale(localeIdentifier: "en_GB"),
        "HKD": NSLocale(localeIdentifier: "zh_Hans_HK"),
        "HRK": NSLocale(localeIdentifier: "hr_HR"),
        "HUF": NSLocale(localeIdentifier: "hu_HU"),
        "IDR": NSLocale(localeIdentifier: "id_ID"),
        "ILS": NSLocale(localeIdentifier: "he_IL"),
        "INR": NSLocale(localeIdentifier: "hi_IN"),
        "JPY": NSLocale(localeIdentifier: "ja_JP"),
        "KRW": NSLocale(localeIdentifier: "ko_KR"),
        "MXN": NSLocale(localeIdentifier: "es_MX"),
        "MYR": NSLocale(localeIdentifier: "ms_MY"),
        "NOK": NSLocale(localeIdentifier: "nn_NO"),
        "NZD": NSLocale(localeIdentifier: "en_NZ"),
        "PHP": NSLocale(localeIdentifier: "fil_PH"),
        "PLN": NSLocale(localeIdentifier: "pl_PL"),
        "RON": NSLocale(localeIdentifier: "ro_RO"),
        "RUB": NSLocale(localeIdentifier: "ru_RU"),
        "SEK": NSLocale(localeIdentifier: "sv_SE"),
        "SGD": NSLocale(localeIdentifier: "en_SG"),
        "THB": NSLocale(localeIdentifier: "th_TH"),
        "TRY": NSLocale(localeIdentifier: "tr_TR"),
        "USD": NSLocale(localeIdentifier: "en_US"),
        "ZAR": NSLocale(localeIdentifier: "en_ZA")
    ]
    
    
//    private static var localeByCurrencyCode: [String: NSLocale] = {
//        let currentLocale = NSLocale.currentLocale()
//        var localeByCurrencyCode: [String: NSLocale] = [:]
//        for identifier in NSLocale.availableLocaleIdentifiers() {
//            let locale = NSLocale(localeIdentifier: identifier)
//            if let currencyCode = locale.objectForKey(NSLocaleCurrencyCode) {
//                localeByCurrencyCode[currencyCode as! String] = locale
//            }
//        }
//        return localeByCurrencyCode
//    }()
}