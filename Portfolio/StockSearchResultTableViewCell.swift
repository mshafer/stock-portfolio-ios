//
//  StockSearchResultTableViewCell.swift
//  Portfolio
//
//  Created by Michael Shafer on 24/09/15.
//  Copyright © 2015 mshafer. All rights reserved.
//

import UIKit

class StockSearchResultTableViewCell: UITableViewCell {

    @IBOutlet var symbol: UILabel!
    @IBOutlet var name: UILabel!
    @IBOutlet var exchange: UILabel!
    
    func configureForSearchResult(searchResult: StockSearchResult) {
        symbol.text = searchResult.symbol
        name.text = searchResult.name
        exchange.text = searchResult.exchange
    }
}
