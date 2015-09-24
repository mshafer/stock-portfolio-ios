//
// Created by Michael Shafer on 23/09/15.
// Copyright (c) 2015 mshafer. All rights reserved.
//

import Foundation

protocol StockQuoteService {
    /**
        Update the closingPrice and currentPrice of the given list of Holding instances.
        The completion handler will be called after the values have been updated.

        :param: holdings A list of holdings to update
    */
    func getQuotesForHoldings(holdings: [Holding], onCompletion: (holdings: [Holding]) -> (), onError: () -> ())
    
    /**
        Search for stocks whose symbol or name matches the given filter string.
    */
    func searchForStockSymbols(filterString: String, onCompletion: (results: [StockSearchResult]) -> (), onError: () -> ())
}