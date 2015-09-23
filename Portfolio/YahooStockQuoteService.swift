//
// Created by Michael Shafer on 23/09/15.
// Copyright (c) 2015 mshafer. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class YahooStockQuoteService: StockQuoteService {
    var YAHOO_API_HOST: String = "https://query.yahooapis.com/v1/public/yql"
    var YAHOO_STOCK_FIELDS: [String] = ["Symbol", "Name", "PreviousClose", "LastTradePriceOnly", "Currency"]

    func getQuotesForHoldings(holdings: [Holding], onCompletion: (holdings: [Holding]) -> (), onError: () -> ()) {
        if holdings.count == 0 {
            onCompletion(holdings: holdings)
            return
        }
        
        let allSymbols = holdings.map { $0.symbol }
        let symbols = Array(Set(allSymbols)) // Remove duplicates
        let query = yqlQueryForSymbols(symbols)
        
        let queryParameters = [
            "q": query,
            "format": "json",
            "env": "http://datatables.org/alltables.env"
        ]
        
        Alamofire.request(.GET, YAHOO_API_HOST, parameters: queryParameters)
            .responseJSON { _, _, result in
                switch result {
                case .Success(let json):
                    self.handleYahooApiResponse(JSON(json), onCompletion: onCompletion, onError: onError)
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                    onError()
                }
            }
    }

    func yqlQueryForSymbols(symbols: [String]) -> String {
        // Yahoo needs quotes around each symbol
        let quotedSymbols = symbols.map { ["\"", $0, "\""].joinWithSeparator("") }
        return [
            "select",
            YAHOO_STOCK_FIELDS.joinWithSeparator(","),
            "from yahoo.finance.quotes where symbol in (",
            quotedSymbols.joinWithSeparator(","),
            ")"
        ].joinWithSeparator(" ")
    }
    
    func handleYahooApiResponse(json: JSON, onCompletion: (holdings: [Holding]) -> (), onError: () -> ()) {
        print(json)
        if let _ = json["error"].dictionary {
            onError()
            return
        }
        
        let quotes: [JSON]
        // Yahoo doesn't return a single-element list for one symbol - it just returns the object
        // Need to work out which case we're dealing with
        let valueForQuoteKey = json["query"]["results"]["quote"]
        if let listOfQuotes = valueForQuoteKey.array {
            quotes = listOfQuotes
        } else {
            // Wrap the single element in an array
            quotes = [valueForQuoteKey]
        }
        
        print(quotes)
        
        onCompletion(holdings: [])
    }
}
