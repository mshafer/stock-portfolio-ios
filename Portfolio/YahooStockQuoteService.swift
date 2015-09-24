//
// Created by Michael Shafer on 23/09/15.
// Copyright (c) 2015 mshafer. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class YahooStockQuoteService: StockQuoteService {
    var YAHOO_API_HOST: String = "https://query.yahooapis.com/v1/public/yql"
    var YAHOO_STOCK_FIELDS: [String] = ["Symbol", "Name", "PercentChange", "LastTradePriceOnly", "Currency"]
    var YAHOO_API_SEARCH_HOST: String = "https://autoc.finance.yahoo.com/autoc"

    // MARK: - getQuotesForHoldings
    
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
                    self.handleYahooApiResponse(holdings, json: JSON(json), onCompletion: onCompletion, onError: onError)
                case .Failure(_):
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
    
    /**
        Handle the response from the Yahoo API call
    
        :param: holdings The array containing the user's holdings. Each will be updated with the new info received from the API
        :param: json The raw JSON object received from the API call
        :param: onCompletion The handler for successful completion
        :param: onError The handler for an error
    */
    func handleYahooApiResponse(holdings: [Holding], json: JSON, onCompletion: (holdings: [Holding]) -> (), onError: () -> ()) {
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
        
        self.updateHoldings(holdings, usingQuotes: quotes)
        
        onCompletion(holdings: holdings)
    }
    
    /**
        Update the properties of each Holding with the new info from 'quotes'
    */
    func updateHoldings(holdings: [Holding], usingQuotes quotes: [JSON]) {
        var quotesBySymbol: Dictionary<String, JSON> = [:]
        for quote in quotes {
            quotesBySymbol[quote["Symbol"].stringValue] = quote
        }
        
        for holding in holdings {
            if let quote = quotesBySymbol[holding.symbol] {
                holding.name = quote["Name"].stringValue
                holding.changeTodayAsFraction = Util.percentageToFraction(quote["PercentChange"].stringValue)
                holding.currentPrice = quote["LastTradePriceOnly"].doubleValue
                holding.currencyCode = quote["Currency"].stringValue
            }
        }
    }
    
    // MARK: - searchForStockSymbols
    
    func searchForStockSymbols(filterString: String, onCompletion: (results: [StockSearchResult]) -> (), onError: () -> ()) {
        let queryParameters = [
            "query": filterString,
            "callback": "YAHOO.Finance.SymbolSuggest.ssCallback"
        ]
        
        Alamofire.request(.GET, YAHOO_API_SEARCH_HOST, parameters: queryParameters)
            .responseString { _, _, result in
                switch result {
                case .Success(let responseText):
                    let json = self.extractJsonFromYahooApiSearchResponse(responseText)
                    self.handleYahooApiSearchResponse(json!, onCompletion: onCompletion)
                case .Failure(_):
                    onError()
                }
        }
    }
    
    /**
        The response from Yahoo contains extraneous text, so we need to strip it off
    */
    func extractJsonFromYahooApiSearchResponse(responseText: String) -> JSON? {
        var stripped = responseText.stringByReplacingOccurrencesOfString("YAHOO.Finance.SymbolSuggest.ssCallback(", withString: "")
        stripped = stripped.substringToIndex(stripped.endIndex.predecessor()) // Remove last character
        
        if let dataFromString = stripped.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            let json = JSON(data: dataFromString)
            return json
        }
        
        return nil
    }
    
    /**
        Convert the JSON list of responses into StockSearchResult instances and call the completion handler
    */
    func handleYahooApiSearchResponse(json: JSON, onCompletion: (holdings: [StockSearchResult]) -> ()) {
        if let resultList = json["ResultSet"]["Result"].array {
            var results: [StockSearchResult] = []
            for result in resultList {
                let stockSearchResult = StockSearchResult(
                    symbol: result["symbol"].stringValue,
                    name: result["name"].stringValue,
                    exchange: result["exch"].stringValue
                )
                results.append(stockSearchResult)
            }
            onCompletion(holdings: results)
            return
        }
        onCompletion(holdings: [])
    }

}
