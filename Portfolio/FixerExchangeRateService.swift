//
//  FixerExchangeRateService.swift
//  Portfolio
//
//  Created by Michael Shafer on 26/09/15.
//  Copyright © 2015 mshafer. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class FixerExchangeRateService: ExchangeRateService {
    final var FIXER_API_HOST = NSURL(string: "https://api.fixer.io")
    
    var listeners: [ExchangeRateListener] = []
    var baseCurrency: String
    var exchangeRates: JSON! {
        didSet {
            for listener in listeners {
                listener.exchangeRatesDidChange()
            }
        }
    }
    var exchangeRatesAreAvailable: Bool {
        get {
            return self.exchangeRates != nil
        }
    }
    
    required init(baseCurrency: String) {
        self.baseCurrency = baseCurrency
    }
    
    func updateExchangeRates() {
        let url = NSURL(string: "latest", relativeToURL: FIXER_API_HOST)
        let queryParameters = [
            "base": self.baseCurrency
        ]
        
        Alamofire.request(.GET, url!, parameters: queryParameters)
            .responseJSON { _, _, result in
                switch result {
                case .Success(let json):
                    self.parseLatestRatesResponse(JSON(json))
                case .Failure(_):
                    break
                }
        }
    }
    
    func convert(value: Double, fromCurrency: String) -> Double? {
        if fromCurrency == baseCurrency {
            return value
        }
        
        guard let exchangeRate = exchangeRates[fromCurrency].double else {
            return nil
        }
        
        print("Converting \(value) \(fromCurrency) to \(value / exchangeRate) \(baseCurrency)")
        
        return value / exchangeRate
    }
    
    func addListener(listener: ExchangeRateListener) {
        listeners.append(listener)
    }
    
    func removeListener(listener: ExchangeRateListener) {
//        let index = listeners.indexOf()
//        listeners.removeAtIndex(index)
    }
    
    // MARK: - Private functions
    
    private func parseLatestRatesResponse(json: JSON) {
        self.exchangeRates = json["rates"]
    }
}