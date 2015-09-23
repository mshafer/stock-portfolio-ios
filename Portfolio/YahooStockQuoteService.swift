//
// Created by Michael Shafer on 23/09/15.
// Copyright (c) 2015 mshafer. All rights reserved.
//

import Foundation

class YahooStockQuoteService: StockQuoteService {
    var YAHOO_API_HOST: String = "https://query.yahooapis.com/v1/public/yql"
    var YAHOO_STOCK_FIELDS: [String] = ["Symbol", "Name", "PreviousClose", "LastTradePriceOnly", "Currency"]

    func getQuotesForHoldings(holdings: [Holding], completion: (holdings: [Holding]) -> ()) {
        let allSymbols = holdings.map { $0.symbol }
        let symbols = Array(Set(allSymbols)) // Remove duplicates
        let query = yqlQueryForSymbols(symbols)
        let url = urlForYqlQuery(query)
        
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
    
    func urlForYqlQuery(query: String) -> String {
        return [
            YAHOO_API_HOST,
            "?q=",
            query.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!,
            "&format=json&env=http%3A%2F%2Fdatatables.org%2Falltables.env"
        ].joinWithSeparator("")
    }
}
