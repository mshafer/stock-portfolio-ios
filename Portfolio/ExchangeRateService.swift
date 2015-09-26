//
//  ExchangeRateService.swift
//  Portfolio
//
//  Created by Michael Shafer on 26/09/15.
//  Copyright © 2015 mshafer. All rights reserved.
//

import Foundation

protocol ExchangeRateService {
    init(baseCurrency: String)
    
    var exchangeRatesAreAvailable: Bool { get }
    
    /**
        Force the exchange rates to be updated
    */
    func updateExchangeRates()
    
    /**
        Convert the given value from the given currency to this ExchangeRateService's base currency
        
        So that this call can be synchronous, nil will be returned if the exchange rates are still being downloaded,
        but you can add yourself as a listener if you want to know when they are available.
    */
    func convert(value: Double, fromCurrency: String) -> Double?
    
    /**
        Subscribe to notifications that exchange rates have been updated
    */
    func addListener(listener: ExchangeRateListener)
    func removeListener(listener: ExchangeRateListener)
}