//
//  StockSearchResult.swift
//  Portfolio
//
//  Created by Michael Shafer on 24/09/15.
//  Copyright © 2015 mshafer. All rights reserved.
//

import UIKit

class StockSearchResult {
    var symbol: String
    var name: String
    var exchange: String
    
    init(symbol: String, name: String, exchange: String) {
        self.symbol = symbol
        self.name = name
        self.exchange = exchange
    }
}
