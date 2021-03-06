//
//  Quote.swift
//  Portfolio
//
//  Created by Michael Shafer on 25/09/15.
//  Copyright © 2015 mshafer. All rights reserved.
//

import UIKit

struct Stock {
    // Required values
    var symbol: String
    var name: String
    var currencyCode: String?
    
    init(symbol: String, name: String) {
        self.symbol = symbol
        self.name = name
    }
}
